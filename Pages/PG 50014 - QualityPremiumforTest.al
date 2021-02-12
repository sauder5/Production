page 50014 "Quality Premium for Test"
{
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Commodity Settings";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
            }
            part(Lines; "Quality Premium Subform")
            {
                SubPageLink = "Quality Premium Code" = FIELD(Code);
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if goTestType <> 0 then begin
            CurrPage.Lines.PAGE.FilterForTestType(goTestType);
        end;
    end;

    var
        goTestType: Option ,Splits,Moisture,"Test Weight";

    [Scope('Internal')]
    procedure SetTestType(TestType: Option ,Splits,Moisture,"Test Weight")
    begin
        goTestType := TestType;
    end;
}

