page 50068 "Customer Payment Links"
{
    PageType = List;
    SourceTable = "Customer Payment Link";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Order Exists"; "Order Exists")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                }
                field("Payment Date"; "Payment Date")
                {
                }
                field("Season Code"; "Season Code")
                {
                }
                field("Grace Period Days"; "Grace Period Days")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Max Possible Amount to Apply"; "Max Possible Amount to Apply")
                {
                }
                field("Amount to Link"; "Amount to Link")
                {
                }
                field("Discount Factor"; "Discount Factor")
                {
                }
                field("Effective Amount to Link"; "Effective Amount to Link")
                {
                }
                field("Remaining Ord-Inv Amt to Link"; "Remaining Ord-Inv Amt to Link")
                {
                }
                field("Invoice CLE No."; "Invoice CLE No.")
                {
                }
                field("Payment CLE No."; "Payment CLE No.")
                {
                }
                field(Processed; Processed)
                {
                }
                field("Amount Applied"; "Amount Applied")
                {
                }
                field(Cancelled; Cancelled)
                {
                }
                field(Request; Request)
                {
                }
                field("Requested Amount"; "Requested Amount")
                {
                }
                field("Linked Amount"; "Linked Amount")
                {
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                }
                field("Remaining Discount"; "Remaining Discount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

