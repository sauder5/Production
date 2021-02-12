pageextension 67335 WarehouseShipmentExt extends "Warehouse Shipment"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("Create Pick for Qty. to Pick"; "Create Pick for Qty. to Pick")
            {
                ApplicationArea = all;
            }
        }
        addbefore("External Document No.")
        {
            field("UPS Simple Rate"; bSimpleRate)
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    IF bSimpleRate THEN BEGIN
                        VALIDATE("Shipping Agent Code", 'UPSSIMPLE');
                        VALIDATE("E-Ship Agent Service", 'STANDARD');
                    END ELSE
                        "External Tracking No." := '';
                end;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("E-Ship Agent Service"; "E-Ship Agent Service")
            {
                ApplicationArea = all;
                trigger OnLookup(var Text: Text): Boolean
                var
                    ShippingAgent: Record "Shipping Agent";
                    recWHShipLine: Record "Warehouse Shipment Line";
                    recSalesHead: Record "Sales Header";
                    EShipAgentService: Record "E-Ship Agent Service";
                begin
                    TESTFIELD("Shipping Agent Code");
                    ShippingAgent.GET("Shipping Agent Code");
                    //rsi-ks
                    recWHShipLine.RESET;
                    CLEAR(recSalesHead);
                    recWHShipLine.SETFILTER("No.", "No.");
                    IF recWHShipLine.FINDSET THEN
                        IF recSalesHead.GET(recSalesHead."Document Type"::Order, recWHShipLine."Source No.") THEN;
                    //rsi-ks
                    EShipAgentService.LookupEShipAgentService(ShippingAgent, "E-Ship Agent Service", recSalesHead."Ship-to Country/Region Code");
                    IF PAGE.RUNMODAL(0, EShipAgentService) = ACTION::LookupOK THEN
                        VALIDATE("E-Ship Agent Service", EShipAgentService.Code);
                end;
            }
        }
        addafter("Shipment Method Code")
        {
            Group("")
            {
                field("External Tracking No."; "External Tracking No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        modify(Control1000000008)
        {
            Visible = not bSimpleRate;
        }
        modify("Shipping Agent Code")
        {
            trigger OnAfterValidate()
            begin
                if "No." <> xRec."No." then begin
                    clear("E-Ship Agent Service");
                    clear("Shipping Agent Service Code");
                end;
            end;
        }
    }

    actions
    {
        addafter("Create Pick")
        {
            action("Pick Ticket with Qty. To Pick")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    recWSHdr.SETRANGE("No.", "No.");
                    IF recWSHdr.FINDSET() THEN
                        REPORT.RUNMODAL(Report::"Pick List - Warehouse Shipment", TRUE, FALSE, recWSHdr);
                end;
            }
            action("Pick Ticket per Order")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    //SOC-SC 08-04-15
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
            action("Pick Ticket by Sorting")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    recWSHdr.SETRANGE("No.", "No.");
                    IF recWSHdr.FINDSET() THEN
                        REPORT.RUNMODAL(Report::"Whse. - Shipment -Rupp", TRUE, FALSE, recWSHdr);
                end;
            }
        }
    }

    var
        bSimpleRate: Boolean;
        recWSHdr: Record "Warehouse Shipment Header";
        recWAL: Record "Warehouse Activity Line";
        recWAH: Record "Warehouse Activity Header";
        cPrevPickNo: Code[20];
        repPickTicket: Report "Pick Ticket per Order";
}