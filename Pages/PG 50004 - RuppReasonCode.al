page 50004 "Rupp Reason Code"
{
    PageType = List;
    SourceTable = "Rupp Reason Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    Visible = false;
                }
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Inv. Status Line Cancel Reason"; "Inv. Status Line Cancel Reason")
                {
                    Visible = false;
                }
                field("Inv Status Check POs in a Year"; "Inv Status Check POs in a Year")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

