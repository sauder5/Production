tableextension 60113 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50100; "Qty. Requested"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50101; "Qty. Cancelled"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50102; "Inventory Status Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = Const("Inventory Status"));
            DataClassification = CustomerContent;
        }
        field(50103; "Cancelled Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Line Cancelled"));
            DataClassification = CustomerContent;
        }
        field(50104; "Unit Price Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Sales Line Unit Price"));
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
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
            DataClassification = CustomerContent;
        }
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51001; "Qty. Can be Produced"; Decimal)
        {
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