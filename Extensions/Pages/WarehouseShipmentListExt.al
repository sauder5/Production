pageextension 67339 WarehouseShipmentListExt extends "Warehouse Shipment List"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("ShippingAgentCode"; SalesHeader."Shipping Agent Code")
            {
                ApplicationArea = all;
            }
            field("E-Ship Agent Service"; SalesHeader."E-Ship Agent Service")
            {
                ApplicationArea = all;
            }
            field("Sales Order Number"; SalesHeader."No.")
            {
                ApplicationArea = all;
            }
            field("Ship-to Name"; SalesHeader."Ship-to Name")
            {
                ApplicationArea = all;
            }
            field("Country"; SalesHeader."Ship-to Country/Region Code")
            {
                ApplicationArea = all;
            }
            field(Salesperson; SalesHeader."Salesperson Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Posted &Warehouse Shipments")
        {
            action("Seed Worksheet")
            {
                ApplicationArea = all;
                RunObject = report "Get Pick Lines for Seed Wksh";
            }
        }
        addafter("Re&open")
        {
            action("Pick Ticket per Qty. to Pick")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    recWSHdr.SETRANGE("No.", "No.");
                    IF recWSHdr.FINDSET() THEN
                        REPORT.RUNMODAL(Report::"Pick List - Warehouse Shipment", TRUE, FALSE, recWSHdr);
                end;
            }
            action("Pick Ticket by Sorting")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    recWSHdr.SETRANGE("No.", "No.");
                    IF recWSHdr.FINDSET() THEN
                        REPORT.RUNMODAL(report::"Whse. - Shipment -Rupp", TRUE, FALSE, recWSHdr);
                end;
            }
            action("Pick Ticket per Order")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    cPrevPickNo: Code[20];
                begin
                    recWAL.SETCURRENTKEY("Source Document", "Source No.", "Location Code");
                    recWAL.SETRANGE("Whse. Document Type", recWAL."Whse. Document Type"::Shipment);
                    recWAL.SETRANGE("Whse. Document No.", "No.");
                    IF recWAL.FINDSET() THEN BEGIN
                        recWAH.RESET();
                        cPrevPickNo := '';
                        REPEAT
                            IF recWAL."No." <> cPrevPickNo THEN BEGIN
                                recWAH.SETRANGE(Type, recWAL."Activity Type");
                                recWAH.SETRANGE("No.", recWAL."No.");
                                recWAH.FINDFIRST();
                                recWAH.MARK(TRUE);
                            END;
                            cPrevPickNo := recWAL."No.";
                        UNTIL recWAL.NEXT = 0;

                        recWAH.SETRANGE(Type);
                        recWAH.SETRANGE("No.");
                        IF recWAH.MARKEDONLY(TRUE) THEN BEGIN
                            recWAH.FINDSET();
                            CLEAR(repPickTicket);
                            repPickTicket.SETTABLEVIEW(recWAH);
                            repPickTicket.RUNMODAL();
                            CLEAR(repPickTicket);
                        END;
                    END;
                end;
            }
            action("Print Label")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Report.RunModal(Report::"Print Pkg Label", false, false);
                end;
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";
        recWSHdr: Record "Warehouse Shipment Header";
        recWAL: Record "Warehouse Activity Line";
        recWAH: Record "Warehouse Activity Header";
        repPickTicket: Report "Pick List - Warehouse Shipment";

    trigger OnAfterGetRecord()
    var
        WhseShipLine: Record "Warehouse Shipment Line";
    begin
        /*        WhseShipLine.SETFILTER("No.", "No.");
                IF WhseShipLine.FINDFIRST() THEN
                    SalesHeader.GET(WhseShipLine."Source Document", WhseShipLine."Source No.")
                ELSE
                    CLEAR(SalesHeader);
        */
    end;
}