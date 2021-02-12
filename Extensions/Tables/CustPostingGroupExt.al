tableextension 60092 CustPostingGroupExt extends "Customer Posting Group"
{
    fields
    {
        field(50001; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50002; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50003; "Customer Price Group"; Code[10])
        {
            TableRelation = "Customer Price Group";
            DataClassification = CustomerContent;
        }
        field(51000; "To Print Seas Disc Sch on Conf"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}