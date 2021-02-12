tableextension 60900 AssemblyHeaderExt extends "Assembly Header"
{
    fields
    {
        field(52000; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order";
            DataClassification = CustomerContent;
        }
        field(52001; "Produced Item Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}