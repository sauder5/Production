page 50051 "Season Codes"
{
    PageType = List;
    SourceTable = "Season Code";
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
                field("Applies to All Codes"; "Applies to All Codes")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Discounts)
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Seasonal Cash Discounts";
                RunPageLink = Code = FIELD(Code);
            }
        }
    }
}

