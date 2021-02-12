pageextension 67336 WhseShipmentSubformExt extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Qty. (Base)")
        {
            field("Qty. to Pick"; "Qty. to Pick")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field(gShipName; gShipName)
            {
                Caption = 'Ship-to Name';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        movebefore("&Line"; "<Fast Pack>")
        modify("<Fast Pack>")
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = True;
            ShortcutKey = "Alt+F11";
        }
    }

    var
        bWarning: Boolean;
        gShipName: Text[100];

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";

    begin
        gShipName := '';
        CALCFIELDS("Missing Reqd License", "Missing Reqd Liability Waiver", "Missing Reqd Quality Release");
        IF ("Pick Qty." > 0) AND ("Missing Reqd License" OR "Missing Reqd Liability Waiver" OR "Missing Reqd Quality Release")
        THEN BEGIN
            bWarning := FALSE;
        END;
        if SalesHeader.get("Source Document", "Source Line No.") then
            gShipName := SalesHeader."Ship-to Name";
    end;
}