page 50023 "Posted Receipts"
{
    CardPageID = "Posted Receipt";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Receipt Header";
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
                field(Status; Status)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
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
                field("Gross Quantity in Purchase UOM"; "Gross Quantity in Purchase UOM")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Moisture Test Result"; "Moisture Test Result")
                {
                }
                field("Splits Test Result"; "Splits Test Result")
                {
                }
                field("Test Weight Result"; "Test Weight Result")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field("Shrink Qty."; "Shrink Qty.")
                {
                }
                field("Net Quantity in Purchase UOM"; "Net Quantity in Purchase UOM")
                {
                }
                field("Unit Premium/Discount"; "Unit Premium/Discount")
                {
                }
                field("Check-off %"; "Check-off %")
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
        area(navigation)
        {
            action("Posted Purchase Receipt Lines")
            {

                trigger OnAction()
                var
                    recPurchrcptLn: Record "Purch. Rcpt. Line";
                begin
                    recPurchrcptLn.Reset();
                    recPurchrcptLn.SetRange("Rcpt No.", "No.");
                    if recPurchrcptLn.FindSet() then begin
                        PAGE.RunModal(528, recPurchrcptLn);
                    end;
                end;
            }
        }
    }
}

