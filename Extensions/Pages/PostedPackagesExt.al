pageextension 80714 PostedPackagesExt extends "Posted Packages"
{
    layout
    {
        addafter("Shipping Charge")
        {
            field("Ship-to Name"; "Ship-to Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Calculation Weight")
        {
            field("COD Amount"; "COD Amount")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}