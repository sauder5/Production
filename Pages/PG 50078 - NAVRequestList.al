page 50078 "NAV Request List"
{
    CardPageID = "NAV Requests";
    DataCaptionFields = RecordID;
    Editable = false;
    PageType = List;
    SourceTable = "NAV Issues List";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area"; Area)
                {
                }
                field(Description; Description)
                {
                }
                field("Priority (1=High - 10=Low)"; "Priority (1=High - 10=Low)")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Date Entered"; "Date Entered")
                {
                }
                field("Date Resolved"; "Date Resolved")
                {
                }
            }
        }
    }

    actions
    {
    }
}

