report 50033 "Transfer Email To Contacts"
{
    Caption = 'Transfer Email To Contacts';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("E-Mail List Entry"; "E-Mail List Entry")
        {
            DataItemTableView = where("E-Mail" = filter(> ''));
            trigger OnAfterGetRecord()
            var
                recContact: Record Contact;
                recBusContRel: Record "Contact Business Relation";
            begin
                recBusContRel.SETCURRENTKEY("Link to Table", "No.");
                recBusContRel.SETRANGE("Link to Table", recBusContRel."Link to Table"::Customer);
                recBusContRel.SETRANGE("No.", Code);
                if recBusContRel.FindFirst() then begin
                    recContact.get(recBusContRel."Contact No.");
                    recContact.FilterGroup(2);
                    recContact.SetFilter("Company No.", recBusContRel."Contact No.");
                    recContact.SetFilter("E-Mail", "E-Mail");
                    if not recContact.FindFirst() then begin
                        recContact."No." := '';
                        recContact.Name := Name;
                        recContact."E-Mail" := "E-Mail";
                        recContact.Type := recContact.Type::Person;
                        recContact."Company No." := recBusContRel."Contact No.";
                        recContact."Salutation Code" := '';
                        recContact.Insert(true);
                    end;
                    recContact.SetFilter("Company No.", '');
                    recContact.SetFilter("E-Mail", '');
                    recContact.FilterGroup(0);
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
    }
}