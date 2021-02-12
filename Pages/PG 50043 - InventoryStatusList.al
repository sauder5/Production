page 50043 "Inventory Status List"
{
    PageType = List;
    SourceTable = "Rupp Reason Code";
    SourceTableView = WHERE(Type = CONST("Inventory Status"));
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
                }
                field("Inv Status Check POs in a Year"; "Inv Status Check POs in a Year")
                {
                }
            }
        }
    }

    actions
    {
    }
}

