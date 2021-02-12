page 50002 "Location Address List"
{
    PageType = List;
    SourceTable = "Location Address";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; "Location Code")
                {
                }
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                    Visible = false;
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(County; County)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Phone No. 2"; "Phone No. 2")
                {
                    Visible = false;
                }
                field("Fax No."; "Fax No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

