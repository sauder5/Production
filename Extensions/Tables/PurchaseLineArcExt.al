tableextension 65110 PurchaseLineArcExt extends "Purchase Line Archive"
{
    fields
    {
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51010; "Quality Premium Code"; Code[10])
        {
            TableRelation = "Commodity Settings";
            DataClassification = CustomerContent;
        }
        field(51011; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51012; "Delivery Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(51013; "Delivery End Date"; Date)
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
        field(51025; "Premium/Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
}