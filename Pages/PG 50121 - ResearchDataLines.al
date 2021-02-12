page 50121 "Research Data Lines"
{
    CardPageID = "Research Plot Data";
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "Research Plot Data";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Key"; Key)
                {
                    AssistEdit = false;
                    DrillDown = false;
                    Editable = false;
                    Lookup = true;
                    LookupPageID = "Research Plot Data";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RDRec.Get(Type, Key);
                        RDPage.SetRecord(RDRec);
                        RDPage.Run;
                    end;
                }
                field("Variety Hybrid"; "Variety Hybrid")
                {
                }
                field("Plot#"; "Plot#")
                {
                }
                field(IDSP; IDSP)
                {
                }
                field("Plot Name"; "Plot Name")
                {
                }
                field("Plot Size"; "Plot Size")
                {
                }
                field("Row Width"; "Row Width")
                {
                }
                field("Row Length"; "Row Length")
                {
                }
                field(Year; Year)
                {
                }
                field("Rep #"; "Rep #")
                {
                }
                field(Status; Status)
                {
                }
                field(Population; Population)
                {
                }
                field("Date Planted"; "Date Planted")
                {
                }
                field("Date Harvested"; "Date Harvested")
                {
                }
                field(IDP; IDP)
                {
                }
                field("Plant Count"; "Plant Count")
                {
                }
                field("Wet Lbs"; "Wet Lbs")
                {
                }
                field(Yield; Yield)
                {
                }
                field(Moisture; Moisture)
                {
                }
                field(Ratio; Ratio)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Action2)
            {
                Caption = 'Open';
                RunObject = Page "Research Plot Data";
                RunPageOnRec = true;
                ShortCutKey = 'Return';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Message('New Line');
    end;

    trigger OnOpenPage()
    begin
        SetFilter(Type, Type);
    end;

    var
        RDRec: Record "Research Plot Data";
        RDPage: Page "Research Plot Data";

    [Scope('Internal')]
    procedure UpdateForm(lType: Code[20]; lYear: Integer)
    begin
        Reset;
        SetFilter(Type, '%1', lType);
        SetFilter(Year, '%1', lYear);
        CurrPage.Update;
    end;
}

