page 50013 "Quality Premium Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Commodity Settings Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Result"; "From Result")
                {
                }
                field("To Result"; "To Result")
                {
                }
                field("Unit Amount"; "Unit Amount")
                {
                    Caption = 'Unit Amount';
                }
                field(ShrinkPercent; "Shrink %")
                {
                    Caption = 'Shrink %';
                    Visible = ShrinkIsVisible;
                }
                field("Test Type"; "Test Type")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        if goTestType > 0 then begin
            "Test Type" := goTestType;
        end;
    end;

    trigger OnOpenPage()
    begin
        if goTestType <> 0 then begin
            SetFilter("Test Type", '%1', goTestType);
            ShrinkIsVisible := false;
            if goTestType = 2 then begin //Moisture
                ShrinkIsVisible := true;
            end;
        end;
    end;

    var
        goTestType: Option ,Splits,Moisture,"Test Weight";
        ShrinkIsVisible: Boolean;

    [Scope('Internal')]
    procedure FilterForTestType(TestType: Option ,Splits,Moisture,"Test Weight")
    begin
        //SETRANGE("Test Type", TestType);
        goTestType := TestType;
    end;
}

