page 50070 "Shipment Planning Batches"
{
    PageType = List;
    SourceTable = "Shipment Planning Batch";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch Name"; "Batch Name")
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
        area(processing)
        {
            action("Shipment Planning Worksheet")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    recShptPlLine: Record "Shipment Planning Line";
                begin
                    //OpenFromBatch := TRUE;
                    TestField("Batch Name");

                    recShptPlLine."Batch Name" := "Batch Name";
                    PAGE.Run(50071, recShptPlLine);
                end;
            }
        }
    }
}

