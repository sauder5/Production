pageextension 60133 PostedSalesInvSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("Unit Price Reason Code"; "Unit Price Reason Code")
            {
                ApplicationArea = all;
            }
            field("Cancelled Reason Code"; "Cancelled Reason Code")
            {
                ApplicationArea = all;
            }
            field("Generic Name Code"; recItem."Generic Name Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    var
        recItem: Record Item;

    trigger OnAfterGetRecord()
    begin
        if Type = Type::Item then
            if not recItem.get("No.") then
                Clear(recItem);
    end;
}