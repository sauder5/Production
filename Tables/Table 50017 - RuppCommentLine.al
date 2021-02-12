table 50017 "Rupp Comment Line"
{
    DrillDownPageID = "Receipt Lines";
    LookupPageID = "Receipt Lines";

    fields
    {
        field(1; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(3; "Document Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; Comment; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
        field(11; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(12; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //IF Date = 0D THEN
        //  Date := WORKDATE;
    end;
}

