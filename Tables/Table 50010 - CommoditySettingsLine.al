table 50010 "Commodity Settings Line"
{
    DrillDownPageID = "Quality Premium Lines";
    LookupPageID = "Quality Premium Lines";

    fields
    {
        field(1; "Quality Premium Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Commodity Settings";
        }
        field(2; "Test Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            OptionMembers = ,Splits,Moisture,"Test Weight",Vomitoxin;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "From Result"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(11; "To Result"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(12; "Unit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(13; "Shrink %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 3;
        }
    }

    keys
    {
        key(Key1; "Quality Premium Code", "Test Type", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;

    trigger OnInsert()
    begin
        TestStatusOpen();
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
    end;

    trigger OnRename()
    begin
        TestStatusOpen();
    end;

    var
        gRecQltyPrem: Record "Commodity Settings";

    local procedure TestStatusOpen()
    begin
        GetQualityPremiumHdr;
        gRecQltyPrem.TestField(Status, gRecQltyPrem.Status::Open);
    end;

    local procedure GetQualityPremiumHdr()
    begin
        TestField("Quality Premium Code");
        if "Quality Premium Code" <> gRecQltyPrem.Code then
            gRecQltyPrem.Get("Quality Premium Code");
    end;

    [Scope('Internal')]
    procedure SetQualityPremiumHdr(QltyPrem: Record "Commodity Settings")
    begin
        gRecQltyPrem := QltyPrem;
    end;
}

