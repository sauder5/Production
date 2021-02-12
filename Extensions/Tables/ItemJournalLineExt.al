tableextension 60083 ItemJournalLineExt extends "Item Journal Line"
{
    fields
    {
        field(51000; "Rupp Product Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51006; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}