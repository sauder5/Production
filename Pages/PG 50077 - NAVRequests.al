page 50077 "NAV Requests"
{
    SourceTable = "NAV Issues List";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(RecordID; RecordID)
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Area"; Area)
                {
                }
                field(Description; Description)
                {
                }
                field(ExtDesc; ExtendedDescription)
                {
                    Caption = 'Extended Description';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        SetText(ExtendedDescription, 1);
                    end;
                }
                field("Required Date"; "Required Date")
                {
                }
                field("Priority (1=High - 10=Low)"; "Priority (1=High - 10=Low)")
                {
                }
                field(ResolutionTxt; ResolutionText)
                {
                    Caption = 'Resolution';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        SetText(ResolutionText, 2);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000009; Links)
            {
            }
            systempart(Control1000000010; Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Extended Description", Resolution);

        ExtendedDescription := GetText(1);
        ResolutionText := GetText(2);
    end;

    var
        ExtendedDescription: Text[1024];
        UserName: Text[64];
        TextReader: InStream;
        TextWriter: OutStream;
        ResolutionText: Text[1024];
}

