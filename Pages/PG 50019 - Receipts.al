page 50019 Receipts
{
    Caption = 'Contract Receipts';
    CardPageID = Receipt;
    Editable = false;
    PageType = List;
    SourceTable = "Receipt Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Primary Vendor No."; "Primary Vendor No.")
                {
                }
                field("Primary Vendor Name"; "Primary Vendor Name")
                {
                }
                field(Status; Status)
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field("Gross Wt (LB)"; "Gross Wt (LB)")
                {
                }
                field("Tare Wt (LB)"; "Tare Wt (LB)")
                {
                }
                field("Net Wt (LB)"; "Net Wt (LB)")
                {
                }
                field("Shrink Qty."; "Shrink Qty.")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Check-off %"; "Check-off %")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field(Farm; Farm)
                {
                }
                field("Farm Field"; "Farm Field")
                {
                }
            }
        }
    }

    actions
    {
    }
}

