pageextension 60134 "PostedSalesCreditMemoExt" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer No."; "Sell-to Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sell-to Customer No.';
                Visible = false;
            }
        }
    }
}