table 50018 "Compliance Group"
{
    DrillDownPageID = "Compliance Groups";
    LookupPageID = "Compliance Groups";

    fields
    {
        field(1; "Waiver Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "License Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Liability Waiver Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Quality Release Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(50; "Customer Compliance Exists"; Boolean)
        {
            CalcFormula = Exist(Compliance WHERE("Waiver Code" = FIELD("Waiver Code"),
                                                  "Customer No." = FIELD("Customer No. Filter")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Customer No. Filter"; Code[20])
        {
            Description = 'Ffilter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Waiver Code")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        recRuppSetup: Record "Rupp Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        /*recRuppSetup.GET();
        recRuppSetup.TESTFIELD(recRuppSetup."Compliance Group Nos");
        "Waiver Name" := NoSeriesMgt.GetNextNo(recRuppSetup."Compliance Group Nos", WORKDATE, TRUE);
        */
        //IF "Vendor No." ='' THEN
        //  ERROR('Please enter Vendor No. and try again');

    end;

    trigger OnDelete()
    var
        recCompGrpItems: Record "Compliance Group Product Item";
    begin
        recCompGrpItems.SetFilter("Waiver Code", "Waiver Code");
        recCompGrpItems.DeleteAll();
    end;
}

