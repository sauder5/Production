report 50081 "Production Lot Bushel Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/ProductionLotBushelReport.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Grower Ticket"; "Grower Ticket")
        {
            column(GenericName; "Generic Name Code")
            {
            }
            column(TicketNo; "Grower Ticket No.")
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
            column(VendorName; recVendor.Name)
            {
            }
            column(PostDate; "Posting Date")
            {
            }
            column(GrossQty; "Gross Qty in Purchase UOM")
            {
            }
            column(ShriinkQty; "Shrink Qty per UOM")
            {
            }
            column(NetQty; "Net Qty in Purchase UOM")
            {
            }
            column(SettledQty; "Settled Quantity")
            {
            }
            column(RemainingQty; "Remaining Quantity")
            {
            }
            column(Amount; decAmount)
            {
            }
            column(ItemNo; "Item No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not recVendor.Get("Vendor No.") then
                    Clear(recVendor);
                if not recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then
                    Clear(recScaleTkt);

                decAmount := Round(recScaleTkt."Unit Cost" * "Remaining Quantity", 0.01);
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
        recVendor: Record Vendor;
        recScaleTkt: Record "Scale Ticket Header";
        decAmount: Decimal;
}

