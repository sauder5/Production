page 50045 "Geographical Restrictions"
{
    PageType = List;
    SourceTable = "Geographical Restriction";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Restriction Type"; "Restriction Type")
                {
                }
                field("Product Code"; "Product Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Country Code"; "Country Code")
                {
                }
                field(State; State)
                {
                }
                field(City; City)
                {
                }
                field("Zip Code"; "Zip Code")
                {
                }
                field("Allowed Customer No."; "Allowed Customer No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

