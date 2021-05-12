page 50066 "Customer Payment Link Subpage"
{
    // //SOC-SC 12-17-15
    //   Added field "Manual Discount Amount"
    //   Added column "Invoice Payment Terms Code"
    // 
    // //SOC-SC 04-01-16
    //   Speed up opening of screen

    Caption = 'Customer Payment Links';
    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Customer Payment Link";
    SourceTableView = SORTING("Customer No.", "Order No.", "Invoice No.")
                      WHERE(Request = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order No."; "Order No.")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Order Exists"; "Order Exists")
                {
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    Visible = false;
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                    Visible = false;
                }
                field("Payment Date"; "Payment Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Payment CLE No."; "Payment CLE No.")
                {
                    Visible = false;
                }
                field("Pmt. Remaining Amount"; "Pmt. Remaining Amount")
                {
                    Visible = false;
                }
                field("Season Code"; "Season Code")
                {
                }
                field("Grace Period Days"; "Grace Period Days")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Manual Discount Amount"; "Manual Discount Amount")
                {
                }
                field("Max Possible Amount to Apply"; "Max Possible Amount to Apply")
                {
                }
                field("Amount to Link"; "Amount to Link")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //IF "Amount to Link" <> 0 THEN
                        CurrPage.Update(true);
                        SetPmtEntry("Payment CLE No.");
                    end;
                }
                field("Discount Factor"; "Discount Factor")
                {
                    Visible = false;
                }
                field("Effective Amount to Link"; "Effective Amount to Link")
                {
                }
                field("Effective Discount Amt to Link"; "Effective Discount Amt to Link")
                {
                    Visible = false;
                }
                field("Remaining Amt to Link"; "Remaining Ord-Inv Amt to Link")
                {
                }
                field("Invoice CLE No."; "Invoice CLE No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Processed; Processed)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Amount Applied"; "Amount Applied")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Cancelled; Cancelled)
                {
                    Visible = false;
                }
                field("Invoice Payment Terms Code"; "Invoice Payment Terms Code")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Autofill Amount to Apply")
            {
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F7';

                trigger OnAction()
                begin
                    //IF "Amount Applied" = 0 THEN BEGIN
                    if not Processed then begin
                        if "Amount to Link" = 0 then begin
                            if "Max Possible Amount to Apply" > 0 then begin
                                Validate("Amount to Link", "Max Possible Amount to Apply");
                                CurrPage.Update();
                                SetPmtEntry("Payment CLE No.");
                            end;
                        end;
                    end;
                end;
            }
            action("Post Application for Invoice")
            {
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    /*recInvCLE.GET("Invoice CLE No.");
                    CustPmtLinkMgt.ApplyInvoiceCLEAtPosting(recInvCLE);
                    */
                    CustPmtLinkMgt.ApplyInvCPLAsLinked(Rec);
                    ResetPmtEntry();

                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    var
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
    begin
        //CustPmtLinkMgt.RefreshCustomerPmtLinks("Customer No.");
    end;

    trigger OnOpenPage()
    begin
        SetRange(Processed, false);
        //ResetPmtEntry(); //SOC-SC 04-01-16 commenting
        //UpdateLines();   //SOC-SC 04-01-16 commenting
    end;

    var
        gtPmtDate: Date;
        gdPmtRemAmt: Decimal;
        gdPmtEntryNo: Integer;
        gcCustNo: Code[20];

    [Scope('Internal')]
    procedure SetPmtEntry(PmtEntryNo: Integer)
    var
        recPmtCLE: Record "Cust. Ledger Entry";
    begin
        if recPmtCLE.Get(PmtEntryNo) then begin
            recPmtCLE.CalcFields("Remaining Amount", "Linked Seasonal Amount");
            gtPmtDate := recPmtCLE."Posting Date";
            gdPmtRemAmt := -recPmtCLE."Remaining Amount" - recPmtCLE."Linked Seasonal Amount";
            gdPmtEntryNo := PmtEntryNo;
            UpdateLines();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateLines()
    begin
        SetRange("Amount to Link", 0);
        //SETFILTER("Order No.", '<>%1', "Order No.");
        //SETFILTER("Invoice No.", '<>%1', "Invoice No.");
        if Rec.FindSet() then begin
            //MODIFYALL("Payment Date", gtPmtDate);
            //MODIFYALL("Pmt. Remaining Amount", gdPmtRemAmt);
            repeat
                Validate("Pmt. Remaining Amount", gdPmtRemAmt);
                Validate("Payment CLE No.", gdPmtEntryNo);
                Validate("Payment Date", gtPmtDate);
                Modify();
            until Next = 0;
        end;
        SetRange("Amount to Link");
        SetRange("Order No.");
        SetRange("Invoice No.");
        FindSet();
        CurrPage.Update(false);
        //MESSAGE('No. of lines: %1', Rec.COUNT); //SOC-SC 04-01-16
    end;

    [Scope('Internal')]
    procedure ResetPmtEntry()
    begin
        gtPmtDate := 0D;
        gdPmtRemAmt := 0;
        gdPmtEntryNo := 0;
        //SETFILTER("Order No.", '<>%1', "Order No."); //SOC-SC 04-01-16 commenting
        //SETFILTER("Invoice No.", '<>%1', "Invoice No."); //SOC-SC 04-01-16 commenting
        if FindSet() then
            UpdateLines();
    end;

    [Scope('Internal')]
    procedure SetCust(CustNo: Code[20])
    begin
        gcCustNo := CustNo;

        //SOC-SC 04-01-16
        FilterGroup(2);
        SetRange("Customer No.", gcCustNo);
        FilterGroup(0);
        //SOC-SC 04-01-16
    end;
}

