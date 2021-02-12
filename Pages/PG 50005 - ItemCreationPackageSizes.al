page 50005 "Item Creation Package Sizes"
{
    PageType = List;
    SourceTable = "Item Creation Pkg Size";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package Size"; "Package Size")
                {
                }
                field("Pkg Size Abbr"; "Pkg Size Abbr")
                {
                    ToolTip = '<BG;BX4;BX5;MT4>';
                }
                field("Lowest UOM"; "Lowest UOM")
                {
                }
                field("Common UOM"; "Common UOM")
                {
                }
                field("Qty. per LUOM"; "Qty. per LUOM")
                {
                }
                field("Qty. per CUOM"; "Qty. per CUOM")
                {
                }
            }
        }
    }

    actions
    {
    }
}

