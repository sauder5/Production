page 50120 "Research Data"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(Type; gType)
            {
                Caption = 'Type';
                Lookup = true;
                LookupPageID = "Research Plot Names";
                TableRelation = "Research Plots";

                trigger OnValidate()
                begin
                    // gType:=Type;
                    CurrPage."<ResearchDataLines>".PAGE.UpdateForm(gType, gYear);
                end;
            }
            field(Year; gYear)
            {
                MaxValue = 2025;
                MinValue = 2016;

                trigger OnValidate()
                begin
                    CurrPage."<ResearchDataLines>".PAGE.UpdateForm(gType, gYear);
                end;
            }
            part("<ResearchDataLines>"; "Research Data Lines")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(New)
            {
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RDRec.SetFilter(Type, '%1', gType);
                    if RDRec.FindLast then
                        gKey := RDRec.Key + 10
                    else
                        gKey := 10;

                    Clear(RDRec);
                    RDRec.Type := gType;
                    RDRec.Key := gKey;
                    RDRec.Insert;
                    RDPage.SetRecord(RDRec);
                    RDPage.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if RDRec.FindFirst then
            gType := RDRec.Type;

        gYear := Date2DMY(Today(), 3);
    end;

    var
        gType: Code[20];
        gYear: Integer;
        gKey: Integer;
        RDPage: Page "Research Plot Data";
        RDRec: Record "Research Plot Data";
}

