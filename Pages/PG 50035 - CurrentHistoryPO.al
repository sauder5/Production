page 50035 "Current/History PO"
{
    Caption = 'Purchase Order';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Importance = Promoted;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Buy-from Contact No."; "Buy-from Contact No.")
                {
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                }
                field("Buy-from Address"; "Buy-from Address")
                {
                    Importance = Additional;
                }
                field("Buy-from Address 2"; "Buy-from Address 2")
                {
                    Importance = Additional;
                }
                field("Buy-from City"; "Buy-from City")
                {
                }
                field("Buy-from County"; "Buy-from County")
                {
                    Caption = 'Buy-from State';
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    Importance = Additional;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    Importance = Additional;
                }
                field("No. of Archived Versions"; "No. of Archived Versions")
                {
                    Importance = Additional;
                }
                field("Posting Description"; "Posting Description")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                    Importance = Promoted;
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Quote No."; "Quote No.")
                {
                    Importance = Additional;
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                }
                field("Vendor Shipment No."; "Vendor Shipment No.")
                {
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                }
                field("Order Address Code"; "Order Address Code")
                {
                    Importance = Standard;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    Importance = Additional;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Importance = Additional;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    Importance = Additional;
                }
                field("Job Queue Status"; "Job Queue Status")
                {
                    Importance = Additional;
                }
                field("Location Code"; "Location Code")
                {
                    Importance = Promoted;
                }
                field("Receiving Address Code"; "Receiving Address Code")
                {
                }
                field(Status; Status)
                {
                    Importance = Promoted;
                }
                field("Future PO"; "Future PO")
                {
                }
            }
            part(PurchLines; "Current/History PO SubForm")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    Importance = Promoted;
                }
                field("Pay-to Contact No."; "Pay-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                }
                field("Pay-to Address"; "Pay-to Address")
                {
                    Importance = Standard;
                }
                field("Pay-to Address 2"; "Pay-to Address 2")
                {
                    Importance = Additional;
                }
                field("Pay-to City"; "Pay-to City")
                {
                }
                field("Pay-to County"; "Pay-to County")
                {
                    Caption = 'State';
                }
                field("Pay-to Post Code"; "Pay-to Post Code")
                {
                    Importance = Standard;
                }
                field("Pay-to Contact"; "Pay-to Contact")
                {
                    Importance = Additional;
                }
                field("IRS 1099 Code"; "IRS 1099 Code")
                {
                    Importance = Promoted;
                }
                field("On Hold"; "On Hold")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date"; "Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    Importance = Additional;
                }
                field("Tax Liable"; "Tax Liable")
                {
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                }
                field("Tax Exemption No."; "Tax Exemption No.")
                {
                }
                field("Provincial Tax Area Code"; "Provincial Tax Area Code")
                {
                }
                field("Payment Reference"; "Payment Reference")
                {
                }
                field("Creditor No."; "Creditor No.")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field(ReceivingAddressCode; "Receiving Address Code")
                {
                    Caption = 'Receiving Address Code';
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to City"; "Ship-to City")
                {
                }
                field("Ship-to County"; "Ship-to County")
                {
                    Caption = 'Envío a-Estado / C.P.';
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                }
                field("Ship-to UPS Zone"; "Ship-to UPS Zone")
                {
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
                {
                    Importance = Additional;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("E-Ship Agent Code"; "E-Ship Agent Code")
                {
                }
                field("E-Ship Agent Service"; "E-Ship Agent Service")
                {
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    Importance = Additional;
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    Importance = Promoted;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                }
                field("Transport Method"; "Transport Method")
                {
                }
                field("Entry Point"; "Entry Point")
                {
                }
                field("Area"; Area)
                {
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field("Prepayment %"; "Prepayment %")
                {
                    Importance = Promoted;
                }
                field("Compress Prepayment"; "Compress Prepayment")
                {
                }
                field("Prepmt. Payment Terms Code"; "Prepmt. Payment Terms Code")
                {
                }
                field("Prepayment Due Date"; "Prepayment Due Date")
                {
                    Importance = Promoted;
                }
                field("Prepmt. Payment Discount %"; "Prepmt. Payment Discount %")
                {
                }
                field("Prepmt. Pmt. Discount Date"; "Prepmt. Pmt. Discount Date")
                {
                }
                field("Vendor Cr. Memo No."; "Vendor Cr. Memo No.")
                {
                }
                field("Prepmt. Include Tax"; "Prepmt. Include Tax")
                {
                }
            }
            group(EDI)
            {
                Caption = 'EDI';
                field("EDI Order"; "EDI Order")
                {
                }
                field("EDI Internal Doc. No."; "EDI Internal Doc. No.")
                {
                    Importance = Promoted;
                }
                field("EDI PO Generated"; "EDI PO Generated")
                {
                }
                field("EDI PO Gen. Date"; "EDI PO Gen. Date")
                {
                    Importance = Promoted;
                }
                field("EDI Released"; "EDI Released")
                {
                }
                field("EDI Ship Adv. Gen."; "EDI Ship Adv. Gen.")
                {
                }
                field("EDI Ship Adv. Gen Date"; "EDI Ship Adv. Gen Date")
                {
                }
                field("E-Mail Confirmation Handled"; "E-Mail Confirmation Handled")
                {
                }
                field("EDI Trade Partner"; "EDI Trade Partner")
                {
                }
                field("EDI Buy-from Code"; "EDI Buy-from Code")
                {
                }
            }
            group("Electronic Invoice")
            {
                Caption = 'Electronic Invoice';
                field("Fiscal Invoice Number PAC"; "Fiscal Invoice Number PAC")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1903326807; "Item Replenishment FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                Visible = false;
            }
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                Visible = true;
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                Visible = true;
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                Visible = false;
            }
            part(Control3; "Purchase Line FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        PurchComment.SetFilter("Document Type", '%1', PurchComment."Document Type"::Receipt);
                        PurchComment.SetFilter("No.", CommentNumber);
                        PurchComment.SetFilter("Document Line No.", '%1', 0);
                        CommentPage.SetTableView(PurchComment);
                        CommentPage.Run;
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("&Print")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        HistReport.setPO(Rec."No.");
                        HistReport.Run;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.PurchLines.PAGE.setPONum("No.");

        RecptHead.SetFilter("Order No.", "No.");
        if RecptHead.FindSet then
            CommentNumber := RecptHead."No.";
    end;

    var
        HistReport: Report "History Purchase Order";
        CommentNumber: Code[20];
        PurchHead: Record "Purchase Header";
        RecptHead: Record "Purch. Rcpt. Header";
        CommentPage: Page "Purch. Comment Sheet";
        PurchComment: Record "Purch. Comment Line";
}

