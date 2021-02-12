table 50043 "Cropping Practice"
{
    // version GroProd


    fields
    {
        field(10; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Cropping Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

