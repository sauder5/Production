page 50106 "Item Discount Calculator"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    SourceTable = Item;
    SourceTableView = WHERE("Sales Blocked" = CONST(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Details)
            {
                Caption = 'Details';
                field(gsCustNo; gsCustNo)
                {
                    Caption = 'Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin

                        //
                        UpdateCustomerInfo();
                        GetUnitPrice();
                    end;
                }
                field(gsCustName; gsCustName)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(gsCustPriceGroup; gsCustPriceGroup)
                {
                    Caption = 'Customer Price Group';
                    TableRelation = "Customer Price Group";

                    trigger OnValidate()
                    begin

                        //
                        GetUnitPrice();
                    end;
                }
                field(gsRegionCode; gsRegionCode)
                {
                    Caption = 'Region Code';
                    TableRelation = Region;

                    trigger OnValidate()
                    begin

                        //
                        GetUnitPrice();
                    end;
                }
                field("No."; "No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                }
                field(Description; Description)
                {
                    Caption = 'Item Description';
                    Editable = false;
                }
                field(gcPmtTerms; gcPmtTerms)
                {
                    Caption = 'Payment Terms';
                    TableRelation = "Payment Terms";
                }
                field("Seasonal Cash Disc Code"; "Seasonal Cash Disc Code")
                {
                }
                field(gtPaymentDate; gtPaymentDate)
                {
                    Caption = 'Payment Date';

                    trigger OnValidate()
                    begin

                        //
                        GetDiscountPct();
                    end;
                }
                field(giGracePeriodDays; giGracePeriodDays)
                {
                    Caption = 'Grace Period Days';
                    //The DecimalPlaces property is only supported on fields of type Decimal.
                    //DecimalPlaces = 0:0;

                    trigger OnValidate()
                    begin

                        //
                        GetDiscountPct();
                    end;
                }
                field(gdDiscountPct; gdDiscountPct)
                {
                    Caption = 'Discount %';

                    trigger OnValidate()
                    begin

                        //
                        if gdDiscountPct >= 100 then
                            Error('Discount % cannot be >= 100');
                        RecalculateQuantityOrAmount();
                    end;
                }
                field(gdUnitPrice; gdUnitPrice)
                {
                    Caption = 'Unit Price';

                    trigger OnValidate()
                    begin

                        //
                        RecalculateQuantityOrAmount();
                    end;
                }
                field(gdQuantity; gdQuantity)
                {
                    Caption = 'Quantity to Buy';

                    trigger OnValidate()
                    begin

                        //
                        RecalculateAmount();
                    end;
                }
                field(gdAmount; gdAmount)
                {
                    Caption = 'Amount to Pay';

                    trigger OnValidate()
                    begin

                        RecalculateQuantity();
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Calculate)
                {
                    Caption = 'Calculate';
                    Image = RefreshLines;

                    trigger OnAction()
                    begin

                        //RefreshBOM;
                        //CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        //
        GetUnitPrice();
        GetDiscountPct();
    end;

    trigger OnOpenPage()
    begin

        gtPaymentDate := WorkDate;
    end;

    var
        UnitOfMeasureCode: Code[10];
        InventoryQty: Decimal;
        GrossReq: Decimal;
        SchedRcpt: Decimal;
        ReservedReq: Decimal;
        ReservedRcpt: Decimal;
        CurrentQuantity: Decimal;
        CurrentReservedQty: Decimal;
        TotalQuantity: Decimal;
        gtPaymentDate: Date;
        gdAmount: Decimal;
        gdQuantity: Decimal;
        giGracePeriodDays: Integer;
        gdUnitPrice: Decimal;
        gdDiscountPct: Decimal;
        gsCustNo: Code[30];
        gsCustPriceGroup: Code[30];
        gsRegionCode: Code[20];
        gsCustName: Text[80];
        gsContNo: Code[20];
        gsCampaignNo: Code[20];
        gsVariantCode: Code[20];
        gsUOM: Code[20];
        gsCurrencyCode: Code[20];
        gtStartingDate: Date;
        gdQtyPerUOM: Decimal;
        gcPmtTerms: Code[10];

    [Scope('Internal')]
    procedure SetValues(CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; RegionCode: Code[20])
    begin

        gsCustNo := CustNo;
        gsContNo := ContNo;
        gsCustPriceGroup := CustPriceGrCode;
        gsCampaignNo := CampaignNo;
        gsVariantCode := VariantCode;
        gsUOM := UOM;
        gsCurrencyCode := gsCurrencyCode;
        gtStartingDate := StartingDate;
        gsRegionCode := RegionCode;
        if ItemNo <> '' then
            if Get(ItemNo) then;
    end;

    [Scope('Internal')]
    procedure GetDiscountPct()
    var
        cduCustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
    begin

        //cduCustPmtLinkMgt.GetDiscountPc("Seasonal Cash Disc Code", giGracePeriodDays, gtPaymentDate, gdDiscountPct);
        gdDiscountPct := cduCustPmtLinkMgt.GetDiscountPc("Seasonal Cash Disc Code", giGracePeriodDays, gtPaymentDate, gcPmtTerms);

        RecalculateQuantityOrAmount();
    end;

    [Scope('Internal')]
    procedure RecalculateQuantity()
    begin

        gdQuantity := 0;

        if (gdUnitPrice <> 0) then
            if gdDiscountPct <> 100 then
                gdQuantity := (100 * gdAmount) / (gdUnitPrice * (100 - gdDiscountPct))
    end;

    [Scope('Internal')]
    procedure RecalculateAmount()
    begin

        gdAmount := gdUnitPrice * gdQuantity * (100 - gdDiscountPct) / 100
    end;

    [Scope('Internal')]
    procedure RecalculateQuantityOrAmount()
    begin

        if gdQuantity <> 0 then begin
            RecalculateAmount();
        end else begin
            if gdAmount <> 0 then
                RecalculateQuantity();
        end;
    end;

    [Scope('Internal')]
    procedure GetUnitPrice()
    var
        cduSalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TempSalesPrice: Record "Sales Price" temporary;
    begin

        //cduSalesPriceCalcMgt.FindSalesPrice(ToSalesPrice,CustNo,ContNo,CustPriceGrCode,CampaignNo,ItemNo,VariantCode,UOM,CurrencyCode,StartingDate,ShowAll)
        //cduSalesPriceCalcMgt.FindSalesPrice(TempSalesPrice,gsCustNo,'',gsCustPriceGroup,'', "No.", '','','',WORKDATE,FALSE);
        //cduSalesPriceCalcMgt.CalcBestUnitPrice(TempSalesPrice);

        //cduSalesPriceCalcMgt.GetUnitPrice(gsCustNo,ContNo,CustPriceGrCode,CampaignNo,ItemNo,VariantCode,UOM,CurrencyCode,StartingDate)

        gdUnitPrice := cduSalesPriceCalcMgt.GetUnitPrice(gsCustNo, '', gsCustPriceGroup, '', "No.", '', '', '', WorkDate, gsRegionCode, gdQuantity, gdQtyPerUOM);

        RecalculateQuantityOrAmount();
    end;

    [Scope('Internal')]
    procedure UpdateCustomerInfo()
    var
        recCust: Record Customer;
    begin

        gsCustName := '';
        if gsCustNo <> '' then begin
            if recCust.Get(gsCustNo) then begin
                gsRegionCode := recCust."Region Code";
                gsCustPriceGroup := recCust."Customer Price Group";
                gsCustName := recCust.Name;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure SetValuesFromSalesLine(SalesLine: Record "Sales Line")
    var
        recSH: Record "Sales Header";
    begin

        with SalesLine do begin
            if Type = Type::Item then begin
                recSH.Get("Document Type", "Document No.");
                gsCustNo := recSH."Bill-to Customer No.";
                UpdateCustomerInfo();
                giGracePeriodDays := recSH."Grace Period Days";
                gdQuantity := Quantity;
                gdQtyPerUOM := "Qty. per Unit of Measure";

                //gsContNo          := recSH."Sell-to Contact No.";

                SetValues(recSH."Bill-to Customer No.", recSH."Sell-to Contact No.", "Customer Price Group", recSH."Campaign No.", "No.",
                          "Variant Code", "Unit of Measure Code", "Currency Code", recSH."Order Date", recSH."Region Code");
            end;
        end;
    end;
}

