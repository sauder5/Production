page 50104 "Rupp Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Rupp Comment Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Comment; Comment)
                {
                }
                field(Date; Date)
                {
                }
                field("Code"; Code)
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
        //SetUpNewLine;
        if Date = 0D then
            Date := WorkDate;
    end;
}

