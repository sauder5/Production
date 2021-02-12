report 50007 "Items to Produce"
{
    // //SOC-SC 10-29-14
    //   Added ReqFilterFields
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/ItemstoProduce.rdlc';
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("<SalesLine>"; "Sales Line")
        {
            DataItemTableView = SORTING("Shipment Date", "No.", "Location Code") WHERE("Document Type" = CONST(Order), Type = CONST(Item));
            RequestFilterFields = "Shipment Date", "No.", "Document No.", "Sell-to Customer No.";
            column(DocType; "Document Type")
            {
            }
            column(OrderNo; "Document No.")
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(LocCode; "Location Code")
            {
            }
            column(Desc; Description)
            {
            }
            column(QtyOrdered; Quantity)
            {
            }
            column(QtyOutstanding; "Outstanding Quantity")
            {
            }
            column(QOH; gdQOH)
            {
            }
            column(QtyonPick; gdQtyonPick)
            {
            }
            column(QtytoProduce; gdQtytoProduce)
            {
            }
            column(ShippingAgent; gcShippingAgent)
            {
            }
            column(EShip; gcEShip)
            {
            }

            trigger OnAfterGetRecord()
            var
                recItem: Record Item;
                recSalesHeader: Record "Sales Header";
            begin

                recSalesHeader.Get("Document Type", "Document No.");

                gcShippingAgent := recSalesHeader."Shipping Agent Code";
                gcEShip := recSalesHeader."E-Ship Agent Service";

                recItem.Get("No.");
                recItem.CalcFields(recItem."Qty. on Pick", Inventory);
                gdQtyonPick := recItem."Product Qty. in Base UOM";
                gdQOH := recItem.Inventory;

                /*gdQtytoProduce  := "<SalesLine>"."Outstanding Quantity" - (gdQOH - gdQtyonPick);
                
                IF gdQtytoProduce < 0 THEN
                  gdQtytoProduce  := 0;    */

            end;

            trigger OnPreDataItem()
            begin
                SetFilter("No.", '<>%1', '');
            end;
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
        gdQOH: Decimal;
        gdQtyonPick: Decimal;
        gcShippingAgent: Code[10];
        gcEShip: Code[30];
        gdQtytoProduce: Decimal;
}

