page 50088 "Scale Ticket List"
{
    // version GroProd

    CardPageID = "Scale Ticket";
    Editable = false;
    PageType = ListPart;
    SourceTable = "Scale Ticket Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Scale Ticket No.";"Scale Ticket No.")
                {
                }
                field("Production Lot No.";"Production Lot No.")
                {
                }
                field("Receipt Date";"Receipt Date")
                {
                }
                field("Paper Scale Ticket No.";"Paper Scale Ticket No.")
                {
                }
                field("Vendor No.";"Vendor No.")
                {
                }
                field(Status;Status)
                {
                }
                field("Posting Date";"Posting Date")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("Bin Code";"Bin Code")
                {
                }
                field("Unit Cost";"Unit Cost")
                {
                }
                field("Gross Wgt (LB)";"Gross Wgt (LB)")
                {
                }
                field("Tare Wgt (LB)";"Tare Wgt (LB)")
                {
                }
                field("Net Wgt (LB)";"Net Wgt (LB)")
                {
                }
                field("Moisture Test Result";"Moisture Test Result")
                {
                }
                field("Moisture Discount per UOM";"Moisture Discount per UOM")
                {
                }
                field("Shrink %";"Shrink %")
                {
                }
                field("Splits Test Result";"Splits Test Result")
                {
                }
                field("Splits Premium per UOM";"Splits Premium per UOM")
                {
                }
                field("Test Weight Result";"Test Weight Result")
                {
                }
                field("Test Weight Discount per UOM";"Test Weight Discount per UOM")
                {
                }
                field("Vomitoxin Test Result";"Vomitoxin Test Result")
                {
                }
                field("Vomitoxin Discount per UOM";"Vomitoxin Discount per UOM")
                {
                }
            }
        }
    }

    actions
    {
    }
}

