page 50053 "Seasonal Disc. Appl. Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = "Seasonal Discount Appl. Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seas Disc. Entry No."; "Seas Disc. Entry No.")
                {
                }
                field("Payment Cust. Ledger Entry"; "Payment Cust. Ledger Entry")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Applied to Cust. Ledger Entry"; "Applied to Cust. Ledger Entry")
                {
                }
                field("Discount %"; "Discount %")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
                field("Applied Amount"; "Applied Amount")
                {
                }
                field("Applied Date"; "Applied Date")
                {
                }
                field(Applied; Applied)
                {
                    Visible = false;
                }
                field("Applied Amount Less Discount"; "Applied Amount Less Discount")
                {
                }
                field("Payment External Doc No."; "Payment External Doc No.")
                {
                }
                field("Discount Amount Not Applied"; "Discount Amount Not Applied")
                {
                }
                field(Unapplied; Unapplied)
                {
                    Visible = false;
                }
                field("Unapplied By"; "Unapplied By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unapplied Date Time"; "Unapplied Date Time")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

