pageextension 60459 SalesNRecvSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Allow Document Deletion Before")
        {
            field("Keep Sales Quote on Make Order"; "Keep Sales Quote on Make Order")
            {
                ApplicationArea = all;
            }
            field("Def. Pymt Terms for New Cust"; "Def. Pymt Terms for New Cust")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}