pageextension 69305 SalesOrderListExt extends "Sales Order List"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Shipping Status"; "Shipping Status")
            {
                applicationarea = all;
            }
            field("On Hold"; "On Hold")
            {
                applicationarea = all;
            }
        }
        addafter("Posting Date")
        {
            field("Shipped By"; "Shipped By")
            {
                applicationarea = all;
            }
        }
        addafter("Shipping Advice")
        {
            field("Completely Shipped"; "Completely Shipped")
            {
                applicationarea = all;
            }
        }
        addafter("Amt. Ship. Not Inv. (LCY)")
        {
            field(Amount; Amount)
            {
                applicationarea = all;
            }
        }
        addafter("Ship-to Contact")
        {
            field("Created By"; "Created By")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
        addafter("<E-Mail List>")
        {
            action("Compliances Required")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    ComplianceMgt.ShowCompliancesReqd(Rec);
                end;
            }
        }
        addafter("F&unctions")
        {
            action("Show Balance/Credit Info")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    CustPmtLinkMgt.ShowCustomerBalance("Sell-to Customer No.");
                end;
            }
        }
        addafter("Send IC Sales Order Cnfmn.")
        {
            action("Link Payments")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    IF recCust.GET("Sell-to Customer No.") THEN BEGIN
                        CustPmtLinkMgt.ShowCustPmtLinking(recCust);
                    END;
                end;
            }
        }
        addafter("Pick Instruction")
        {
            action("Pick Ticket")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppFun.PrintPickTTicketForSO("No.");
                end;
            }
        }
        addafter("Sales Reservation Avail.")
        {
            action("Report Pallet Label")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    repPalletLabel: Report "Pallet Label";
                begin
                    CLEAR(repPalletLabel);
                    repPalletLabel.SetSO("No.");
                    repPalletLabel.RUN;
                    CLEAR(repPalletLabel);
                end;
            }
            action("Picking List by Order")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    recSH: Record "Sales Header";
                begin
                    recSH.RESET();
                    recSH.SETRANGE("Document Type", "Document Type");
                    recSH.SETRANGE("No.", "No.");
                    recSH.FINDSET();
                    REPORT.RUNMODAL(Report::"Picking List by Order", TRUE, FALSE, recSH);
                end;
            }
            action("Open Orders")
            {
                ApplicationArea = all;
                RunObject = page "Open Order List";
            }
        }
    }
    var
        ComplianceMgt: Codeunit "Compliance Management";
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        recCust: Record Customer;
        RuppFun: Codeunit "Rupp Functions";
}