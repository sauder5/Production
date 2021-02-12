pageextension 67002 SalesPricesExt extends "Sales Prices"
{
    layout
    {
        addafter("Sales Code")
        {
            field("Region Code"; "Region Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item No.")
        {
            field(Description; gsDescription)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Unit Price")
        {
            field("Unit Price per Common UOM"; "Unit Price per Common UOM")
            {
                ApplicationArea = all;
            }
            field("Common UOM"; "Common UOM")
            {
                ApplicationArea = all;
            }
            field("Qty. per Common UOM"; "Qty. per Common UOM")
            {
                ApplicationArea = all;
            }
        }
        addafter("Allow Line Disc.")
        {
            field("Unit Discount"; "Unit Discount")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Allow Group Discount"; "Allow Group Discount")
            {
                ApplicationArea = all;
            }
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                if recItem.get("Item No.") then
                    gsDescription := recItem.Description;
            end;
        }
    }

    actions
    {
    }

    var
        gsDescription: Text[50];
        recItem: Record Item;

    trigger OnAfterGetRecord()
    begin
        gsDescription := recItem.Description;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        gsDescription := '';
        IF recItem.GET("Item No.") THEN
            gsDescription := recItem.Description;
    end;
}