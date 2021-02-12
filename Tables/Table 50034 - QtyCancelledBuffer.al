table 50034 "Qty Cancelled Buffer"
{

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(20; Date; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50100; "Qty. Requested"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50101; "Qty. Cancelled"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

