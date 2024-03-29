table 50041 "Rupp Product Group"
{
    DrillDownPageId = "Rupp Product Codes";
    LookupPageId = "Rupp Product Codes";
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Rupp Product Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; Description; text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Rupp Product Group Code")
        {
            Clustered = true;
        }
    }
}