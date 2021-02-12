page 50084 "Grower Ticket"
{
    // version GroProd

    PageType = Card;
    SourceTable = "Grower Ticket";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("Grower Ticket No."; "Grower Ticket No.")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field("Production Lot No."; "Production Lot No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; recVendor.Name)
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field("Grower Share %"; "Grower Share %")
                {
                }
                field(Status; Status)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Gross Wgt (LB)"; "Gross Wgt (LB)")
                {
                }
                field("Tare Wgt (LB)"; "Tare Wgt (LB)")
                {
                }
                field("Net Wgt (LB)"; "Net Wgt (LB)")
                {
                }
                field("Gross Qty in Purchase UOM"; "Gross Qty in Purchase UOM")
                {
                }
                field("Shrink Qty per UOM"; "Shrink Qty per UOM")
                {
                }
                field("Net Qty in Purchase UOM"; "Net Qty in Purchase UOM")
                {
                }
                field("Total Premi / Disc per UOM"; "Total Premi / Disc per UOM")
                {
                }
                field("Settled Quantity"; "Settled Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if not recVendor.GET("Vendor No.") then
            CLEAR(recVendor);
    end;

    var
        recVendor: Record Vendor;
}

