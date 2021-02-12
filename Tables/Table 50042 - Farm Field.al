table 50042 "Farm Field"
{
    // version GroProd


    fields
    {
        field(10; "Farm Field No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Farm Field Name"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Farm No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Farm."Farm No.";
        }
        field(40; Acreage; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; Longitude; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        field(60; Latitude; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        field(70; State; Text[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rupp State Codes".State;
        }
        field(80; County; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(90; Township; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(100; Image; Media)
        {
            CaptionML = ENU = 'Image',
                        ESM = 'Imagen',
                        FRC = 'Image',
                        ENC = 'Image';
            DataClassification = AccountData;
            ExtendedDatatype = None;
        }
    }

    keys
    {
        key(Key1; "Farm Field No.")
        {
        }
        key(Key2; "Farm No.", "Farm Field No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Farm Field No.", "Farm Field Name", Acreage)
        {
        }
    }

    trigger OnDelete();
    var
        recProdLot: Record "Production Lot";
    begin
        recProdLot.RESET;
        recProdLot.SETFILTER("Farm No.", "Farm No.");
        recProdLot.SETFILTER("Farm Field No.", "Farm Field No.");
        if recProdLot.FINDSET then
            ERROR('Farm Field cannot be deleted. It is in use on Production Lot %1', recProdLot."Production Lot No.");
    end;

    trigger OnInsert();
    begin
        "Farm Field No." := NoSeriesMgt.GetNextNo('R_FARMFLD', TODAY(), true);
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

