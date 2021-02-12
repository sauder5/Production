page 50093 "Farm List"
{
    // version GroProd

    PageType = List;
    SourceTable = Farm;
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
                field(Vendor; Vendor)
                {
                }
                field("Farm Name"; "Farm Name")
                {
                }
                field("Land Owner"; "Land Owner")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

