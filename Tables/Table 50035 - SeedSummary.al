table 50035 "Seed Summary"
{
    // //SOC-SC 08-27-15
    //   Increased length of "Internal Lot No." to 40

    DrillDownPageID = "Seed Summary";
    LookupPageID = "Seed Summary";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Manifest Header";
        }
        field(2; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = Product;
        }
        field(3; "Internal Lot No."; Code[40])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(11; "Seed Size"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'FF';
            Editable = false;
            FieldClass = Normal;
            OptionMembers = ,Small,Large;
        }
        field(12; "Actual Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateGNPRequired();
            end;
        }
        field(13; "GNP Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.", "Product Code", "Internal Lot No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure UpdateGNPRequired()
    var
        recRuppSetup: Record "Rupp Setup";
    begin
        // CALCFIELDS("Seed Size");
        "GNP Required" := false;
        recRuppSetup.Get();
        recRuppSetup.TestField("Min Wt in g for Large Seed GNP");
        recRuppSetup.TestField("Min Wt in g for Small Seed GNP");
        case "Seed Size" of
            "Seed Size"::Small:
                begin
                    if "Actual Weight in g" > recRuppSetup."Min Wt in g for Small Seed GNP" then begin //500
                        "GNP Required" := true;
                    end;
                end;
            "Seed Size"::Large:
                begin
                    if "Actual Weight in g" > recRuppSetup."Min Wt in g for Large Seed GNP" then begin //5000
                        "GNP Required" := true;
                    end;
                end;
        end;
    end;
}

