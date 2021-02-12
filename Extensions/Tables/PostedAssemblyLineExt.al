tableextension 60911 PostedAssemblyLineExt extends "Posted Assembly Line"
{
    fields
    {
        field(52000; "Work Order No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(52001; "Consumed Item Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}