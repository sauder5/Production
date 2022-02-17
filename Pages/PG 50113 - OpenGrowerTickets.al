page 50113 "Open Grower Tickets"
{
    // version GroProd

    PageType = List;
    SourceTable = "Open Grower Tickets";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Grower Ticket No."; "Grower Ticket No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; Name)
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Grower Share %"; "Grower Share %")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Bin Code"; "Bin Code")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Item Description"; "Description")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Gross Wgt (LB)"; "Gross Wgt (LB)")
                {
                    Editable = false;
                    HideValue = false;
                }
                field("Tare Wgt (LB)"; "Tare Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Net Wgt (LB)"; "Net Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Gross Qty in Purchase UOM"; "Gross Qty in Purchase UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Purchase UOM"; "Purch. Unit of Measure")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity  Code"""; "Commodity Code")
                {
                    Caption = 'Commodity Code';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity Premium per UOM"""; "Commodity Premium per UOM")
                {
                    Caption = 'Commodity Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("Moisture Test Result"; "Moisture Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Moisture Discount per UOM"; "Moisture Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Shrink %"""; "Shrink %")
                {
                    Caption = 'Shrink %';
                    Editable = false;
                    Enabled = false;
                }
                field("Shrink Qty per UOM"; "Shrink Qty per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Splits Test Result"; "Splits Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Splits Premium per UOM"; "Splits Premium per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Test Weight Result"; "Test Weight Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Test Weight Discount Per UOM"; "Test Weight Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Vomitoxin Test Result"; "Vomitoxin Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Vomitozin Discount Per UOM"; "Vomitoxin Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Cropping Practice Code"""; "Cropping Practice Code")
                {
                    Caption = 'Cropping Practice Code';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Cropping Premium per UOM"""; "Cropping Premium per UOM")
                {
                    Caption = 'Cropping Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("Out of Zone Prem per UOM"; "Out of Zone Premium per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Check Off %"; "Check off %")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Total Premi / Disc per UOM"; "Total Premium Disc per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Net Qty in Purchase UOM"; "Net Qty in Purchase UOM")
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
}

