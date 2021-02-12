report 50052 "Customer Sale Items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CustomerSaleItems.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            column(CustNo; Customer."No.")
            {
            }
            column(CustName; Customer.Name)
            {
            }
            column(CustAddress; Customer.Address)
            {
            }
            column(CustCity; Customer.City)
            {
            }
            column(CustState; Customer.County)
            {
            }
            column(CustZip; Customer."Post Code")
            {
            }
            column(CustPhone; Customer."Phone No.")
            {
            }
            column(ShowDetail; ShowDetail)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Source No." = FIELD("No.");
                DataItemTableView = SORTING("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.") WHERE("Entry Type" = FILTER(Sale));
                RequestFilterFields = "Posting Date";
                column(ItemNo; "Item Ledger Entry"."Item No.")
                {
                }
                column(Description; recItem.Description)
                {
                }
                column(Quantity; "Item Ledger Entry".Quantity)
                {
                }
                column(SalesAmt; "Item Ledger Entry"."Sales Amount (Actual)")
                {
                }
                column(Lot; "Item Ledger Entry"."Lot No.")
                {
                }
                column(ShipName; ShipName)
                {
                }
                column(ShipAddr; ShipAddr)
                {
                }
                column(ShipCity; ShipCity)
                {
                }
                column(ShipState; ShipState)
                {
                }
                column(ShipZip; ShipZip)
                {
                }
                column(DocNum; "Item Ledger Entry"."Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not recItem.Get("Item Ledger Entry"."Item No.") then
                        Clear(recItem);

                    Clear(recSalesShip);
                    Clear(ShipName);
                    Clear(ShipAddr);
                    Clear(ShipCity);
                    Clear(ShipState);
                    Clear(ShipZip);

                    with "Item Ledger Entry" do begin
                        case "Document Type" of
                            "Document Type"::"Sales Return Receipt":
                                if recReturnLine.Get("Document No.", "Document Line No.") then
                                    if recitemLedger.Get(recReturnLine."Appl.-from Item Entry") then
                                        if recSalesShip.Get(recitemLedger."Document No.") then begin
                                            ShipName := recSalesShip."Ship-to Name";
                                            ShipAddr := recSalesShip."Ship-to Address";
                                            ShipCity := recSalesShip."Ship-to City";
                                            ShipState := recSalesShip."Ship-to County";
                                            ShipZip := recSalesShip."Ship-to Post Code";
                                        end;
                            "Document Type"::"Sales Shipment":
                                if recSalesShip.Get("Document No.") then begin
                                    ShipName := recSalesShip."Ship-to Name";
                                    ShipAddr := recSalesShip."Ship-to Address";
                                    ShipCity := recSalesShip."Ship-to City";
                                    ShipState := recSalesShip."Ship-to County";
                                    ShipZip := recSalesShip."Ship-to Post Code";
                                end;
                            "Document Type"::"Sales Invoice":
                                if recSalesInv.Get("Document No.") then begin
                                    ShipName := recSalesInv."Ship-to Name";
                                    ShipAddr := recSalesInv."Ship-to Address";
                                    ShipCity := recSalesInv."Ship-to City";
                                    ShipState := recSalesInv."Ship-to County";
                                    ShipZip := recSalesInv."Ship-to Post Code";
                                end;
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
            area(content)
            {
                group(Control1000000002)
                {
                    ShowCaption = false;
                    field(ShowDetail; ShowDetail)
                    {
                        Caption = 'Show Detail';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        gDescription: Text;
        recItem: Record Item;
        ShowDetail: Boolean;
        recReturnRcpt: Record "Return Receipt Header";
        recSalesShip: Record "Sales Shipment Header";
        recReturnLine: Record "Return Receipt Line";
        recitemLedger: Record "Item Ledger Entry";
        recSalesInv: Record "Sales Invoice Header";
        ShipName: Text[50];
        ShipAddr: Text[50];
        ShipCity: Text[30];
        ShipState: Text[10];
        ShipZip: Text[10];
}

