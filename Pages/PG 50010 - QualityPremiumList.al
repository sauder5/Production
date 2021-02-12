page 50010 "Quality Premium List"
{
    CardPageID = "Commodity Codes";
    Editable = false;
    PageType = List;
    SourceTable = "Commodity Settings";
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
                field("Created By"; "Created By")
                {
                    Visible = false;
                }
                field("Created Date Time"; "Created Date Time")
                {
                    Visible = false;
                }
                field("Modified By"; "Modified By")
                {
                    Visible = false;
                }
                field("Modified Date Time"; "Modified Date Time")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Moisture)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::Moisture;
                    OpenDiscountsForTest(TestType);
                end;
            }
            action(Splits)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::Splits;
                    OpenDiscountsForTest(TestType);
                end;
            }
            action("Test Weight")
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::"Test Weight";
                    OpenDiscountsForTest(TestType);
                end;
            }
            action(Vomitoxin)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight",Vomitoxin;
                begin
                    TestType := TestType::Vomitoxin;
                    OpenDiscountsForTest(TestType);
                end;
            }
        }
    }
}

