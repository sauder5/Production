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