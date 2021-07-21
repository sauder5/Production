// Added by TAE on 2021-07-20 to support the online customer center and ordering
pageextension 60135 "PostedSalesCrMemoSubformExt" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Package Tracking No.")
        {
            field("Shipment Date"; "Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Shipment Date';
                Visible = false;
            }
        }
    }
}