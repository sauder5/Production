tableextension 60121 PurchRcptLineExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(51000; "Product Code"; Code[20])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51020; "Purchase Contract No."; Code[17])
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
            OptionMembers = " ","Purchase Contract",Receipt;
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
    }
}