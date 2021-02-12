page 50030 "Compliance Groups"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Compliance Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Waiver Code"; "Waiver Code")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                    Visible = false;
                }
                field("License Required"; "License Required")
                {
                }
                field("Liability Waiver Required"; "Liability Waiver Required")
                {
                }
                field("Quality Release Required"; "Quality Release Required")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Group Items")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Compliance Group Items";
                RunPageLink = "Waiver Code" = FIELD("Waiver Code");
            }
            action(Compliances)
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Compliances;
                RunPageLink = "Waiver Code" = FIELD("Waiver Code");
            }
        }
    }
}

