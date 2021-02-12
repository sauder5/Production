page 50008 "Seasonal Cash Discounts"
{
    PageType = List;
    SourceTable = "Seasonal Cash Discount";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field("Payment Month"; "Payment Month")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Grace Period Days"; "Grace Period Days")
                {
                }
                field("Month Sequence"; "Month Sequence")
                {
                }
                field("Print Schedule on Ord. Conf"; "Print Schedule on Ord. Conf")
                {
                }
            }
        }
    }

    actions
    {
    }
}

