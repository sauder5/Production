tableextension 60222 ShiptoAddress extends "Ship-to Address"
{
    fields
    {
        field(52000; "Region Code"; Code[20])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
        field(52010; "Freight Charges Option"; Option)
        {
            OptionMembers = "User Decides","One Time Charge","All Actual Charges";
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}