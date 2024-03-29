page 50042 "Item Attributes - SOC"
{
    DataCaptionFields = "Attribute Type";
    PageType = List;
    SourceTable = "Product Attribute";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attribute Type"; "Attribute Type")
                {
                    Visible = false;
                }
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

