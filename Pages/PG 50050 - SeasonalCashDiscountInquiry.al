page 50050 "Seasonal Cash Discount Inquiry"
{
    PageType = CardPart;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(gcSeasonCode; gcSeasonCode)
            {
                Caption = 'Season Code';
                DrillDown = true;

                trigger OnDrillDown()
                var
                    recSeason: Record "Season Code";
                begin
                    recSeason.Reset();
                    if recSeason.FindSet() then begin
                        if PAGE.RunModal(50051, recSeason) = ACTION::LookupOK then begin
                            gcSeasonCode := recSeason.Code;
                        end;
                    end;
                end;

                trigger OnValidate()
                begin
                    CalculateAmountToPay();
                end;
            }
            field(gdOrderAmount; gdOrderAmount)
            {
                Caption = 'Order Amount';

                trigger OnValidate()
                begin
                    CalculateAmountToPay();
                end;
            }
            field(gcPmtTerms; gcPmtTerms)
            {
                Caption = 'Payment Terms';

                trigger OnDrillDown()
                var
                    recPmtTerms: Record "Payment Terms";
                begin
                    recPmtTerms.Reset();
                    if recPmtTerms.FindSet() then begin
                        if PAGE.RunModal(0, recPmtTerms) = ACTION::LookupOK then begin
                            gcPmtTerms := recPmtTerms.Code;
                        end;
                    end;
                end;

                trigger OnValidate()
                begin
                    CalculateAmountToPay();
                end;
            }
            field(gtPaymentDate; gtPaymentDate)
            {
                Caption = 'Payment Date';

                trigger OnValidate()
                begin
                    CalculateAmountToPay();
                end;
            }
            field(giGracePeriodDays; giGracePeriodDays)
            {
                Caption = 'Grace Period Days';

                trigger OnValidate()
                begin
                    CalculateAmountToPay();
                end;
            }
            field(gdAmountToPay; gdAmountToPay)
            {
                Caption = 'Amount to Pay';
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field(gdDiscount; gdDiscount)
            {
                Caption = 'Discount';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Recalculate)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalculateAmountToPay();
                end;
            }
        }
    }

    var
        gcSeasonCode: Code[20];
        gdOrderAmount: Decimal;
        gtPaymentDate: Date;
        giGracePeriodDays: Integer;
        gdAmountToPay: Decimal;
        gcPmtTerms: Code[10];
        gdDiscount: Decimal;

    [Scope('Internal')]
    procedure CalculateAmountToPay()
    var
        dDiscountPc: Decimal;
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        dAmt: Decimal;
    begin
        if (gtPaymentDate = 0D) or (gdOrderAmount = 0) then begin
            gdAmountToPay := 0;
        end else begin
            dDiscountPc := CustPmtLinkMgt.GetDiscountPc(gcSeasonCode, giGracePeriodDays, gtPaymentDate, gcPmtTerms);
            dAmt := Round((100 * gdOrderAmount) / (100 + dDiscountPc), 0.00001);
            gdAmountToPay := Round(dAmt, 0.01);
        end;
        gdDiscount := gdOrderAmount - gdAmountToPay;
    end;
}

