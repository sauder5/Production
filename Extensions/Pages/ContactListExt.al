pageextension 65052 ContactListExt extends "Contact List"
{
    layout
    {
        addafter("Search Name")
        {
            field(Address; Address)
            {
                applicationarea = all;
            }
            field(City; City)
            {
                applicationarea = all;
            }
            field(County; County)
            {
                ApplicationArea = all;
                Caption = 'State';
            }
        }
    }

    actions
    {
    }
}