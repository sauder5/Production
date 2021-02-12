page 50108 "Customer Payment Accounts"
{
    // //SOC_SC 09-23-14
    //   Added button <John Deere Account Website>

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Payment Account";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Customer No."; "Customer No.")
                {
                    Visible = false;
                }
                field("Account No."; "Account No.")
                {
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Account Name"; "Account Name")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account Use"; "Account Use")
                {
                }
                field("Regular Limit"; "Regular Limit")
                {
                }
                field("Special Terms Limit"; "Special Terms Limit")
                {
                }
                field("Status 1"; "Status 1")
                {
                }
                field("Status 2"; "Status 2")
                {
                }
                field(Closed; Closed)
                {
                }
                field("Last Updated"; "Last Updated")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000016; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Customer No.");
                Visible = false;
            }
            part(Control1000000017; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Customer No.");
            }
            part(Control1000000018; "Customer Ledger Entry FactBox")
            {
                SubPageLink = "No. Series" = FIELD("Customer No.");
                Visible = false;
            }
            part(Control1000000019; "Customer Credit FactBox")
            {
                SubPageLink = "No." = FIELD("Customer No.");
                Visible = false;
            }
            part(Control1000000020; "Customer Credit Information")
            {
                SubPageLink = "No." = FIELD("Customer No.");
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("John Deere Account Website")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    HyperLink('https://merchantservice.deere.com/sl/Login.do');
                end;
            }
        }
    }
}

