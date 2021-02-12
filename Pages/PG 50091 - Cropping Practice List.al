page 50091 "Cropping Practice List"
{
    // version GroProd

    PageType = List;
    SourceTable = "Cropping Practice";
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
                field("Cropping Premium per UOM"; "Cropping Premium per UOM")
                {
                }
            }
        }
    }

    actions
    {
    }
}

