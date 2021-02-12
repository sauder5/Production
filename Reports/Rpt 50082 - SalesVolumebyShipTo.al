report 50082 "Sales Volume by ShipTo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/SalesVolumebyShipTo.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            column(CustNum; Customer."No.")
            {
            }
            column(CustName; Customer.Name)
            {
            }
            column(CustSalesPerson; Customer."Salesperson Code")
            {
            }
            column(CustPostingGroup; Customer."Customer Posting Group")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Source No." = FIELD("No.");
                DataItemTableView = WHERE("Entry Type" = FILTER(Sale));
                column(ItemNum; "Item Ledger Entry"."Item No.")
                {
                }
                column(ItemPostingDate; "Item Ledger Entry"."Posting Date")
                {
                }
                column(ItemDesc; gItemDesc)
                {
                }
                column(ItemQty; "Item Ledger Entry".Quantity)
                {
                }
                column(ItemUOM; "Item Ledger Entry"."Unit of Measure Code")
                {
                }
                column(ItemSalesAmt; "Item Ledger Entry"."Sales Amount (Actual)")
                {
                }
                column(ShipToName; gShiptoName)
                {
                }
                column(DocumentNumber; gOrderNum)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    gShiptoName := '';
                    gOrderNum := '';
                    gItemDesc := '';
                    if recItem.Get("Item Ledger Entry"."Item No.") then
                        gItemDesc := recItem.Description;

                    case "Item Ledger Entry"."Document Type" of
                        "Item Ledger Entry"."Document Type"::"Sales Shipment":
                            begin
                                if not recShipHeader.Get("Item Ledger Entry"."Document No.") then
                                    Clear(recShipHeader);
                                gShiptoName := recShipHeader."Ship-to Name";
                                gOrderNum := recShipHeader."Order No.";
                            end;
                        "Item Ledger Entry"."Document Type"::"Sales Return Receipt":
                            begin
                                if not recReturnHeader.Get("Item Ledger Entry"."Document No.") then
                                    Clear(recReturnHeader);
                                gShiptoName := recReturnHeader."Sell-to Customer Name";
                                if recReturnLine.Get("Item Ledger Entry"."Document No.", "Item Ledger Entry"."Document Line No.") then
                                    gOrderNum := recReturnLine."Return Order No.";
                            end;
                        "Item Ledger Entry"."Document Type"::"Sales Invoice":
                            begin
                                if not recSalesInv.Get("Item Ledger Entry"."Document No.") then
                                    Clear(recSalesInv);
                                gShiptoName := recSalesInv."Ship-to Name";
                                gOrderNum := recSalesInv."No.";
                            end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recShipHeader: Record "Sales Shipment Header";
        recReturnHeader: Record "Return Receipt Header";
        recReturnLine: Record "Return Receipt Line";
        recItem: Record Item;
        recSalesInv: Record "Sales Invoice Header";
        gShiptoName: Text[50];
        gOrderNum: Code[20];
        gItemDesc: Text[50];
}

