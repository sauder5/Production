table 50023 "Payment Account"
{

    fields
    {
        field(1; "Payment Method Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Account Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Account Type"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Account Lookup".Code WHERE("Payment Method Code" = FIELD("Payment Method Code"),
                                                                 "Lookup Option" = CONST(2));
        }
        field(12; "Account Use"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Account Lookup".Code WHERE("Payment Method Code" = FIELD("Payment Method Code"),
                                                                 "Lookup Option" = CONST(1));
        }
        field(20; "Regular Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Special Terms Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Status 1"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Account Lookup".Code WHERE("Payment Method Code" = FIELD("Payment Method Code"),
                                                                 "Lookup Option" = CONST(3));
        }
        field(31; "Status 2"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Account Lookup".Code WHERE("Payment Method Code" = FIELD("Payment Method Code"),
                                                                 "Lookup Option" = CONST(4));
        }
        field(32; Closed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Last Updated"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Imported Customer No"; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Payment Method Code", "Customer No.", "Account No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

