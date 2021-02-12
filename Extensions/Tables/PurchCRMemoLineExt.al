tableextension 60125 PurchCRMemoLineExt extends "Purch. Cr. Memo Line"
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
        field(51021; "Purchase Contract Line No."; integer)
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Rcpt No."; code[20])
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
    }

    var
        myInt: Integer;
}