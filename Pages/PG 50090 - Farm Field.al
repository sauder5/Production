page 50090 "Farm Field"
{
    // version GroProd

    PageType = Card;
    SourceTable = "Farm Field";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Farm Field No."; "Farm Field No.")
                {
                }
                field("Farm Field Name"; "Farm Field Name")
                {
                }
                field("Farm No."; "Farm No.")
                {
                }
                field(Acreage; Acreage)
                {
                }
                field(Longitude; Longitude)
                {
                }
                field(Latitude; Latitude)
                {
                }
                field(State; State)
                {
                    TableRelation = "Post Code".County;
                }
                field(County; County)
                {
                }
                field(Township; Township)
                {
                }
                part(Control1000000011; "Farm Field Picture")
                {
                    SubPageLink = "Farm Field No." = FIELD("Farm Field No.");
                    Visible = NOT IsOfficeAddin;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        "Farm Field No." := NoSeriesMgt.GetNextNo('FARMFLD', TODAY(), true);
    end;

    trigger OnOpenPage();
    var
        OfficeManagement: Codeunit "Office Management";
        varField: Text[30];
        done: Boolean;
    begin
        IsOfficeAddin := OfficeManagement.IsAvailable;
    end;

    var
        IsOfficeAddin: Boolean;
        recZipCode: Record "Post Code";
}

