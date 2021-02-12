page 50094 "Farm Field List"
{
    // version GroProd

    CardPageID = "Farm Field";
    PageType = List;
    SourceTable = "Farm Field";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Farm No."; "Farm No.")
                {
                }
                field("Farm Field No."; "Farm Field No.")
                {
                }
                field("Farm Field Name"; "Farm Field Name")
                {
                }
                field(Acreage; Acreage)
                {
                }
                field(State; State)
                {
                }
                field(Township; Township)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000009; "Farm Field Picture")
            {
                SubPageLink = "Farm Field No." = FIELD("Farm Field No.");
            }
        }
    }

    actions
    {
    }
}

