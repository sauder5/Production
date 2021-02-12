page 50044 "Sales Price Worksheet Batches"
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

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange(Type, Type::"Sales Price Worksheet Batch");
        FilterGroup(0);
    end;
}

