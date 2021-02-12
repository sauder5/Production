page 50069 "Requested Seasonal Discounts"
{
    // //Made screen editable

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
                    Editable = false;
                }
                field("Season Code"; "Season Code")
                {
                }
                field("Requested Amount"; "Requested Amount")
                {
                }
                field("Requested Discount"; "Requested Discount")
                {
                }
                field("Discount %"; "Discount %")
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
                field("Potential Remaining Amount"; "Potential Remaining Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

