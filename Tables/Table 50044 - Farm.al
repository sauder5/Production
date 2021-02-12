table 50044 Farm
{
    // version GroProd

    Description = 'Farm';

    fields
    {
        field(10; "Farm No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Farm Name"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Land Owner"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(40; Vendor; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Farm No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Farm No.", "Farm Name", "Land Owner")
        {
        }
    }

    trigger OnDelete();
    var
        recFarmField: Record "Farm Field";
    begin
        recFarmField.RESET;
        recFarmField.SETFILTER("Farm No.", "Farm No.");
        if recFarmField.FINDSET then
            ERROR('Farm cannot be deleted. It is in use on Farm Field %1', recFarmField."Farm Field No.");
    end;

    trigger OnInsert();
    begin
        if "Farm No." = '' then
            "Farm No." := NoSeriesMgt.GetNextNo('R_FARMNO', TODAY(), true);
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

