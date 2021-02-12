pageextension 60046 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        addbefore(Control1)
        {
            group(TotalGrid)
            {
                Caption = '';
                Grid(GridTot)
                {
                    Caption = '';
                    GridLayout = Rows;
                    group(Totals)
                    {
                        field(gdTotalAmt; gdTotalAmt)
                        {
                            ApplicationArea = all;
                            Caption = 'Total Amount';
                            Editable = false;
                        }
                        field(gdTotalAmtShippedNotInv; gdTotalAmtShippedNotInv)
                        {
                            ApplicationArea = all;
                            Caption = 'Amount Shipped Not Invoice';
                            Editable = false;
                        }
                    }
                }
            }
            group(Credit)
            {
                showcaption = false;
                field(gsCreditLimitWarning; gsCreditLimitWarning)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                    Visible = gbExceedingCreditLimit;
                }
            }
        }
        addafter("No.")
        {
            field(gsSearchDescr; gsSearchDescr)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Search Description';
            }
            field("Compliance Group Code"; "Compliance Group Code")
            {
                applicationarea = all;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field(gsGeneric; gsGeneric)
            {
                ApplicationArea = all;
                Caption = 'Generic Name Code';
                Editable = false;
            }
        }
        modify(Type)
        {
            trigger onAfterValidate()
            begin
                gbnonItem := (Type <> Type::Item);
            end;
        }
        addbefore(Quantity)
        {
            field("Qty. Requested"; "Qty. Requested")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    GetUnitPricePerCUOM();
                end;
            }
        }
        addafter(Quantity)
        {
            field("Qty. Cancelled"; "Qty. Cancelled")
            {
                applicationarea = all;
            }
            field("Cancelled Reason Code"; "Cancelled Reason Code")
            {
                applicationarea = all;
            }
            field("Inventory Status Code"; "Inventory Status Code")
            {
                applicationarea = all;
            }
        }
        addafter("Unit Price")
        {
            field("Unit Price Reason Code"; "Unit Price Reason Code")
            {
                applicationarea = all;
            }
            field("Unit Price per CUOM"; "Unit Price per CUOM")
            {
                applicationarea = all;
            }
            field("Unit Discount"; "Unit Discount")
            {
                applicationarea = all;
            }
        }
        addafter("Qty. to Ship")
        {
            field("Std. Pack Qty. to Ship"; "Std. Pack Qty. to Ship")
            {
                applicationarea = all;
            }
            field("Package Qty. to Ship"; "Package Qty. to Ship")
            {
                applicationarea = all;
            }
        }
        addafter("Quantity Shipped")
        {
            field("Outstanding Qty. in Lowest UOM"; "Outstanding Qty. in Lowest UOM")
            {
                applicationarea = all;
            }
            field("Outstanding Qty. in Common UOM"; "Outstanding Qty. in Common UOM")
            {
                applicationarea = all;
            }
        }
        addafter("Line No.")
        {
            field("Pick Qty."; "Pick Qty.")
            {
                applicationarea = all;
            }
            field("Pick Creation DateTime"; "Pick Creation DateTime")
            {
                applicationarea = all;
            }
            field("Customer Price Group"; "Customer Price Group")
            {
                applicationarea = all;
            }
        }
        modify(Control51)
        {
            Visible = false;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                SetCreditLimitVisibility();
            end;
        }
    }

    actions
    {
        addafter("Select Nonstoc&k Items")
        {
            action("Get Seasonal Cash Disc Qty")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    SeasDiscMgt.GetSLSeasCashDiscQty(Rec);
                end;
            }
            action("Item Discount Calculator")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    pgItemDiscCalc: Page "Item Discount Calculator";
                begin
                    pgItemDiscCalc.SetValuesFromSalesLine(Rec);
                    pgItemDiscCalc.Run();
                end;
            }
        }
        addafter(SelectMultiItems)
        {
            action("Search Description")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Product Availability';
                trigger onAction()
                var
                    recItem: Record Item;
                begin
                    IF Type = Type::Item THEN BEGIN
                        IF "No." <> '' THEN BEGIN
                            recItem.GET("No.");
                            recItem.RESET();
                            recItem.SETRANGE("Product Code", "Product Code");
                            recItem.FINDSET();
                            PAGE.RUNMODAL(Page::"Product Availability", recItem);
                        END;
                    END;
                end;
            }
            action("Prices for Product")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Sales Prices";
                RunPageLink = "Sales Type" = CONST("Customer Price Group"), "Sales Code" = FIELD("Customer Price Group"), Product = FIELD("Product Code");
            }
        }
    }

    var
        gdTotalAmt: Decimal;
        gdTotalAmtShippedNotInv: Decimal;
        gsCreditLimitWarning: Text[50];
        gsGeneric: Text[20];
        gsSearchDescr: Text[50];
        TypeChosen: Boolean;
        gdUnitPricePerCUOM: Decimal;
        gbnonItem: Boolean;
        gbExceedingCreditLimit: Boolean;
        SeasDiscMgt: Codeunit "Seasonal Discounts Mgt.";


    trigger OnOpenPage()
    begin
        gsCreditLimitWarning := 'EXCEEDING CREDIT LIMIT!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
        gbExceedingCreditLimit := FALSE;
    end;

    trigger onAfterGetRecord()
    begin
        gbNonItem := (Type <> Type::Item); //SOC-SC 08-01-14
        gsSearchDescr := GetSearchDescr(); //SOC-SC 10-14-14
        gsGeneric := GetGenericCode(); //RSI-KS 06-05-15
        gdTotalAmt := GetTotalCount(gdTotalAmtShippedNotInv);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        gdTotalAmt := GetTotalCount(gdTotalAmtShippedNotInv);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        gbnonItem := (Type <> Type::Item);
        gsSearchDescr := '';
    end;

    local procedure GetGenericCode() retValue: Text
    var
        recItem: Record Item;
    begin
        retValue := '';
        IF Type = Type::Item THEN
            IF recItem.GET("No.") THEN
                retValue := recItem."Generic Name Code";
    end;

    procedure SetCreditLimitVisibility()
    var
        PMMgt: Codeunit "Product Management";
    begin
        gbExceedingCreditLimit := PMMgt.GetExceedingCreditLimit(Rec); //PM1.0
    end;

    procedure GetSearchDescr() retSearchDesc: Text[50]
    var
        recItem: Record Item;
    begin
        retSearchDesc := '';

        IF Type = Type::Item THEN
            IF recItem.GET("No.") THEN
                retSearchDesc := recItem."Search Description";
    end;

    procedure GetUnitPricePerCUOM() retUnitPricePerCUOM: Decimal
    begin
        retUnitPricePerCUOM := 0;
    end;

    procedure GetTotalCount(var retTotalAmtShippedNotInv: Decimal) retTotalAmt: Decimal
    var
        recSL: Record "Sales Line";
    begin
        retTotalAmt := 0;
        retTotalAmtShippedNotInv := 0;
        recSL.RESET();
        recSL.SETRANGE("Document Type", "Document Type");
        recSL.SETRANGE("Document No.", "Document No.");
        IF recSL.FINDSET() THEN BEGIN
            recSL.CALCSUMS("Line Amount", recSL."Shipped Not Invoiced");
            retTotalAmt := recSL."Line Amount";
            retTotalAmtShippedNotInv := recSL."Shipped Not Invoiced";
        END;
    end;
}