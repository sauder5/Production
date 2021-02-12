tableextension 60123 PurchInvLineExt extends "Purch. Inv. Line"
{
    fields
    {
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
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
            OptionMembers = " ","Purchase Contract",Receipt;
            DataClassification = CustomerContent;
        }
        field(51024; "Rcpt Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51026; "Prepmt Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51027; "Prepmt Line Quantity"; Decimal)
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
            DataClassification = CustomerContent;
        }
    }
}