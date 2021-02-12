table 50008 "Seasonal Discount Appl. Entry"
{
    DrillDownPageID = "Seasonal Disc. Appl. Entries";
    LookupPageID = "Seasonal Disc. Appl. Entries";

    fields
    {
        field(1; "Seas Disc. Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Payment Cust. Ledger Entry"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Cust. Ledger Entry" WHERE("Document Type" = CONST(Invoice));
        }
        field(11; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Applied to Cust. Ledger Entry"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Payment Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Deposit,"Cash Receipt Journal";
        }
        field(15; "Payment Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Applied to Doc Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,,Invoice,"Credit Memo",,,Refund;
        }
        field(17; "Applied to Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Product Code"; Code[17])
        {
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(20; "Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Applied Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Applied Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Added at Application"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(25; Applied; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Applied Amount Less Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Payment External Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Discount Amount Not Applied"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; Unapplied; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(41; "Unapplied By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(42; "Unapplied Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Seas Disc. Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Applied, false);
    end;
}

