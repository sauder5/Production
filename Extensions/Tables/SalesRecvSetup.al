tableextension 60311 SalesRecvSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Keep Sales Quote on Make Order"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Def. Pymt Terms for New Cust"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }
}