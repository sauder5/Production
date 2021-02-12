table 50053 "Prepayment Amounts"
{
    // version GroProd


    fields
    {
        field(10; "Prepayment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(30; "Prepayment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Prepayment Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Amount Remaining" := "Prepayment Amount" - "Amount Consumed";
            end;
        }
        field(50; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Paid,Consumed';
            OptionMembers = Open,Paid,Consumed;
        }
        field(60; "Amount Consumed"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Amount Remaining" := "Prepayment Amount" - "Amount Consumed";
            end;
        }
        field(70; "Amount Remaining"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));
        }
        field(90; "Date Paid"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Prepayment No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "Prepayment No." = '' then
            "Prepayment No." := NoSeriesMgt.GetNextNo('R_PREPAY', TODAY(), true);
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

