page 50122 "Research Plot Data"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Research Plot Data";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Type)
                {
                }
                field("Key"; Key)
                {
                }
                field(Year; Year)
                {
                    Caption = 'Year';
                }
                field("Plot Name"; "Plot Name")
                {
                }
                field("Plot#"; "Plot#")
                {
                }
            }
            group(Details)
            {
                field("Variety Hybrid"; "Variety Hybrid")
                {
                }
                field(IDSP; IDSP)
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
                field(Height; Height)
                {
                }
                field(Lodge; Lodge)
                {
                }
                field(Maturity; Maturity)
                {
                }
                field(Stalk; Stalk)
                {
                }
                field(Root; Root)
                {
                }
                field("Ear Height"; "Ear Height")
                {
                }
                field("Plot ID"; "Plot ID")
                {
                }
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
                    Modify;

                    gType := Type;
                    RDRec.SetFilter(Type, gType);
                    if RDRec.FindLast then
                        gKey := RDRec.Key + 10
                    else
                        gKey := 10;

                    Clear(Rec);
                    Type := gType;
                    Key := gKey;
                    Insert;
                end;
            }
        }
    }

    var
        bNew: Boolean;
        RDRec: Record "Research Plot Data";
        RDPage: Page "Research Plot Data";
        gKey: Integer;
        gType: Code[20];
}

