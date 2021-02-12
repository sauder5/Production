pageextension 60026 VendorCardExt extends "Vendor Card"
{
    layout
    {
        moveafter("Creditor No."; "Check Date Format")
        moveafter("Check Date Format"; "Check Date Separator")
        movelast("General"; "Location Code")
        addlast(Invoicing)
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addafter(Attachments)
        {
            action(ComplianceGroups)
            {
                ApplicationArea = all;
                Caption = 'Compliance Groups';
                RunObject = page "Compliance Groups";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
        addlast(History)
        {
            action(PostedReceiptLines)
            {
                ApplicationArea = ALL;
                Caption = 'Posted Receipt Lines';
                RunObject = page "Posted Purchase Receipt Lines";
                RunPageLink = "Buy-from Vendor No." = field("No.");
            }
        }
    }

    var
        myInt: Integer;
}