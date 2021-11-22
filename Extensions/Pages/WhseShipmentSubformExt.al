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
        //        CALCFIELDS("Missing Reqd License", "Missing Reqd Liability Waiver", "Missing Reqd Quality Release");
        CalcFields("Rupp Missing Liability Waiver", "Rupp Missing License", "Rupp Missing Quality Release");
        IF ("Pick Qty." > 0) AND ("Rupp Missing License" OR "Rupp Missing Liability Waiver" OR "Rupp Missing Quality Release")
        THEN BEGIN
            bWarning := FALSE;
        END;
        if SalesHeader.get("Source Document", "Source Line No.") then
            gShipName := SalesHeader."Ship-to Name";
    end;
}