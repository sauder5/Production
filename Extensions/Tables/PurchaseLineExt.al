tableextension 60039 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50002; "Future PO"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Purchase Header"."Future PO" WHERE("No." = FIELD("Document No."), "Document Type" = FIELD("Document Type")));
        }
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51002; "Outstanding Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Outstanding Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51020; "Purchase Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51021; "Purchase Contract Inv Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Rcpt No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51023; "Auto-generating Process"; Option)
        {
            OptionMembers = ,"Purchase Contract",Receipt;
            DataClassification = CustomerContent;
        }
        field(51024; "Rcpt Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51028; "Purchase Contract Rct Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51030; "Original PO Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51031; "PO Qty Change Reason"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("PO Qty Changed"));
            DataClassification = CustomerContent;
        }
    }

    procedure UpdateUOMQuantities()
    var
        RuppFunc: Codeunit "Rupp Functions";
        dQtyPerLUOM: Decimal;
    begin
        //SOC-SC 08-23-14
        IF Type = Type::Item THEN
            RuppFunc.GetQtyLUOMandQtyCUOM("No.", "Unit of Measure Code", "Outstanding Quantity", "Outstanding Qty. in Lowest UOM", "Outstanding Qty. in Common UOM", dQtyPerLUOM);

    end;
}