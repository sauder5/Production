tableextension 60115 SalesCRMemoLineExt extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50107; "Original Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50108; "Unit Price per CUOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50109; "Common Unit of Measure"; Code[10])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
            DataClassification = CustomerContent;
        }
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51010; "Seasonal Cash Disc Code"; Code[20])
        {
            TableRelation = "Season Code";
            DataClassification = CustomerContent;
        }
    }
}