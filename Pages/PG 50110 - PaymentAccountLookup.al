page 50110 "Payment Account Lookup"
{
    PageType = List;
    SourceTable = "Payment Account Lookup";
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
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

