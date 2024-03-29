tableextension 60111 SalesShipmentLineExt extends "Sales Shipment Line"
{
    fields
    {
        field(50100; "Qty. Requested"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50101; "Qty. Cancelled"; decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50102; "Inventory Status Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("Inventory Status"));
            DataClassification = CustomerContent;
        }
        field(50103; "Cancelled Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("Line Cancelled"));
            DataClassification = CustomerContent;
        }
        field(50104; "Unit Price Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("Sales Line Unit Price"));
            DataClassification = CustomerContent;
        }
        field(50105; "Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50106; "High Value Charges"; Boolean)
        {
            DataClassification = CustomerContent;
        }
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
        field(51021; "Original Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Substituted Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51023; Substitute; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51025; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(52000; "Geographical Restriction"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}