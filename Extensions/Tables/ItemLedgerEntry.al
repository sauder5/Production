tableextension 60032 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51001; "Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52000; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order";
            DataClassification = ToBeClassified;
        }
        modify("Remaining Quantity")
        {
            trigger OnAfterValidate()
            var
                recItemUOM: Record "Item Unit of Measure";
            begin
                if recItemUOM.Get("Item No.", "Unit of Measure Code") then begin
                    Validate("Qty. in Common UOM", Quantity * recItemUOM."Qty. per Common UOM");
                    Validate("Qty. in Lowest UOM", Quantity * recItemUOM."Qty. per Lowest UOM");
                end;
            end;
        }
    }
}