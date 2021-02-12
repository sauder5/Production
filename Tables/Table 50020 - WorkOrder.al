table 50020 "Work Order"
{
    // //SOC-SC 08-28-15
    //   Update Lines' Status; Added function UpdateStatusOfLines()


    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(10; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Finished;

            trigger OnValidate()
            begin
                UpdateStatusOfLines(); //SOC-SC 08-28-15
            end;
        }
        field(20; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(30; Template; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Created from Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Work Order" WHERE(Template = CONST(true));

            trigger OnValidate()
            var
                cduWOMgt: Codeunit "Work Order Management";
            begin

                if "Created from Template" <> '' then begin
                    if "Created from Template" <> xRec."Created from Template" then begin
                        cduWOMgt.CopyWorkOrder("Created from Template", Rec);
                    end;
                end;
            end;
        }
        field(40; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(41; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;

            trigger OnValidate()
            begin

                GetDefaultBin();
                if "Location Code" = '' then
                    "Bin Code" := '';
            end;
        }
        field(51; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(60; Quantity; Decimal)
        {
            CalcFormula = Sum("Produced Item".Quantity WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Quantity to Assemble"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Quantity to Assemble" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Assembled Quantity"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Assembled Quantity" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Remaining Quantity"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Remaining Quantity" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Qty. in Lowest UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Qty. in Lowest UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(501; "Qty. to Assemble in Lowest UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Qty. to Assemble in Lowest UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(502; "Assembled Qty. in Lowest UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Assembled Qty. in Lowest UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(503; "Remaining Qty. in Lowest UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Remaining Qty. in Lowest UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(510; "Qty. in Common UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Qty. in Common UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF - same as Product Qty';
            Editable = false;
            FieldClass = FlowField;
        }
        field(511; "Qty. to Assemble in Common UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Qty. to Assemble in Common UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF - same as Product Qty to Assemble';
            Editable = false;
            FieldClass = FlowField;
        }
        field(512; "Assembled Qty. in Common UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Assembled Qty. in Common UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF - same as Assembled Product Qty';
            Editable = false;
            FieldClass = FlowField;
        }
        field(513; "Remaining Qty. in Common UOM"; Decimal)
        {
            CalcFormula = Sum("Produced Item"."Remaining Qty. in Common UOM" WHERE("Work Order No." = FIELD("No.")));
            DecimalPlaces = 0 : 5;
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recProducedItem: Record "Produced Item";
        recConsumedItem: Record "Consumed Item";
        recAssemblyHeader: Record "Assembly Header";
        recPostAssmHdr: Record "Posted Assembly Header";
    begin

        CalcFields("Assembled Quantity");
        TestField("Assembled Quantity", 0);

        recPostAssmHdr.Reset;
        recPostAssmHdr.SetRange("Work Order No.", "No.");
        if recPostAssmHdr.FindFirst() then
            Error('Cannot delete Work Order. Posted Assembly record exists.');

        recProducedItem.Reset;
        recProducedItem.SetRange("Work Order No.", "No.");
        if recProducedItem.FindSet() then
            recProducedItem.DeleteAll(true);

        recConsumedItem.Reset;
        recConsumedItem.SetRange("Work Order No.", "No.");
        if recConsumedItem.FindSet() then
            recConsumedItem.DeleteAll(true);

        recAssemblyHeader.Reset;
        recAssemblyHeader.SetRange("Work Order No.", "No.");
        if recAssemblyHeader.FindSet() then
            recAssemblyHeader.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        recRuppSetup: Record "Rupp Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        if "No." = '' then begin
            recRuppSetup.Get();
            recRuppSetup.TestField("Work Order Nos");
            "No." := NoSeriesMgt.GetNextNo(recRuppSetup."Work Order Nos", WorkDate, true);
        end;

        "Created By" := UserId();
        "Created Date Time" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        //ToDo
        CheckStatus();
    end;

    trigger OnRename()
    begin
        //ToDo
    end;

    var
        gbSkipStatusCheck: Boolean;

    [Scope('Internal')]
    procedure CheckStatus()
    begin

        if not gbSkipStatusCheck then
            TestField(Status, Status::Open);
    end;

    [Scope('Internal')]
    procedure SkipStatusCheck(SkipCheck: Boolean)
    begin

        gbSkipStatusCheck := SkipCheck;
    end;

    [Scope('Internal')]
    procedure GetDefaultBin()
    var
        recLocation: Record Location;
        WMSManagement: Codeunit "WMS Management";
    begin

        if "Bin Code" = '' then begin
            if ("Location Code" <> '') then begin
                recLocation.Get("Location Code");
                if GetFromAssemblyBin(recLocation, "Bin Code") then
                    exit;

                //IF recLocation."Bin Mandatory" AND (NOT recLocation."Directed Put-away and Pick") THEN
                //  WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code");
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetFromAssemblyBin(Location: Record Location; var BinCode: Code[20]) BinCodeNotEmpty: Boolean
    begin

        if Location."Bin Mandatory" then
            BinCode := Location."To-Assembly Bin Code";
        BinCodeNotEmpty := BinCode <> '';
    end;

    local procedure UpdateStatusOfLines()
    var
        recConsumedItems: Record "Consumed Item";
    begin
        recConsumedItems.Reset();
        recConsumedItems.SetRange("Work Order No.", "No.");
        if recConsumedItems.FindSet() then begin
            recConsumedItems.ModifyAll(Status, Status);
        end;
    end;
}

