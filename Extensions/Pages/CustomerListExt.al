pageextension 60022 CustomerList extends "Customer List"
{
    layout
    {
        addbefore("Post Code")
        {
            field(Address; Address) { }
            field(City; City) { }
            field(County; County)
            {
                Caption = 'State';
            }
        }
        addafter("Phone No.")
        {
            field("Fax No."; "Fax No.") { }
        }
        addafter("CFDI Relation")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code") { }
            field("Freight Charges Option"; "Freight Charges Option") { }
        }
    }

    actions
    {
        addafter(OnlineMap)
        {
            action(Compliances)
            {
                RunObject = Page "Compliances";
                RunPageLink = "Customer No." = field("No.");
            }
        }
        addafter("Item &Tracking Entries")
        {
            action("Posted Invoice Lines")
            {
                RunObject = Page "Posted Sales Invoice Lines";
                RunPageLink = "Sell-to Customer No." = field("No.");
            }
        }
        addafter(Sales)
        {
            action("Show Balance/Credit Info")
            {
                Image = Balance;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    cuCustPmtMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    cuCustPmtMgt.ShowCustomerBalance("No."); //SOC-SC 06-24-15
                end;
            }
        }
        addafter("&Customer")
        {
            action("Link Payments")
            {
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    CustPmtLinkMgt.ShowCustPmtLinking(Rec);
                end;
            }
            action("Refresh Remaining Seas Disc")
            {
                Image = RefreshDiscount;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    CustPmtLinkMgt.UpdateCustRemSeasDis("No.");
                end;
            }
        }

    }
    trigger OnOpenPage()
    var
        recUserSetup: Record "User Setup";
    begin
        IF NOT recUserSetup.GET(USERID) THEN
            CLEAR(recUserSetup);

        IF recUserSetup."Show Protected Customers" <> TRUE THEN BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Customer", '<>%1', TRUE);
            FILTERGROUP(0);
        END ELSE BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Customer", '');
            FILTERGROUP(0);
        END;

    end;

}