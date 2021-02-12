table 50009 "Commodity Settings"
{
    DrillDownPageID = "Quality Premium List";
    LookupPageID = "Quality Premium List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Created By"; Code[35])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Modified By"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Test Type Filter"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Splits,Moisture,"Test Weight";
        }
        field(40; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released;
        }
        field(50; "Seed Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Estimated Yield per Acre"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Grain Program Payable Acct"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No.";
        }
        field(80; "Comm. Annual Prem per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified By" := UserId;
        "Modified Date Time" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        TestField(Status, Status::Open);
    end;

    [Scope('Internal')]
    procedure OpenDiscountsForTest(TestType: Option " ",Splits,Moisture,"Test Weight")
    var
        pgDiscountForTest: Page "Quality Premium for Test";
        recDiscount: Record "Commodity Settings";
    begin
        Clear(pgDiscountForTest);
        recDiscount.Reset();
        recDiscount.SetRange(Code, Code);
        pgDiscountForTest.SetTableView(recDiscount);
        pgDiscountForTest.SetTestType(TestType);
        pgDiscountForTest.RunModal();
        Clear(pgDiscountForTest);
    end;
}

