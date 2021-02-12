page 50150 "Table Information"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Table Information";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company Name"; "Company Name")
                {
                }
                field("Table No."; "Table No.")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("No. of Records"; "No. of Records")
                {
                }
                field("Record Size"; "Record Size")
                {
                }
                field("Size (KB)"; "Size (KB)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

