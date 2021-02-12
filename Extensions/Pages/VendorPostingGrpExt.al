pageextension 60149 VendorPostingGrpExt extends "Vendor Posting Group Card"
{
    layout
    {
        addafter("Service Charge Acc.")
        {
            field("Protected Posting Group"; "Protected Posting Group")
            {
                ApplicationArea = ALL;
            }
        }
    }
}