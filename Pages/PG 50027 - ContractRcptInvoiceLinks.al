page 50027 "Contract Rcpt-Invoice Links"
{
    Editable = false;
    PageType = List;
    SourceTable = "Contract Rcpt-Invoice Link";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Contract No."; "Contract No.")
                {
                    Visible = false;
                }
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Receipt Line No."; "Receipt Line No.")
                {
                }
                field("Contract Receipt Line No."; "Contract Receipt Line No.")
                {
                }
                field("Settlement Line No."; "Settlement Line No.")
                {
                }
                field("Invoice Line No."; "Invoice Line No.")
                {
                }
                field("Created DateTime"; "Created DateTime")
                {
                    Visible = false;
                }
                field("Created By"; "Created By")
                {
                    Visible = false;
                }
                field("Quantity Linked"; "Quantity Linked")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field(Moisture; Moisture)
                {
                }
                field(Splits; Splits)
                {
                }
                field("Test Weight"; "Test Weight")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field("Recd. Gross Qty."; "Recd. Gross Qty.")
                {
                }
                field("Recd. Shrink Qty."; "Recd. Shrink Qty.")
                {
                }
                field("Recd. Net Qty."; "Recd. Net Qty.")
                {
                }
                field("Check-off %"; "Check-off %")
                {
                }
                field("Unit Premium/Discount"; "Unit Premium/Discount")
                {
                }
                field("Premium/Discount Amount"; "Premium/Discount Amount")
                {
                }
                field("Check-off Amount"; "Check-off Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

