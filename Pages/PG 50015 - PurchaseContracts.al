page 50015 "Purchase Contracts"
{
    CardPageID = "Purchase Contract";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Contract Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Contract Date"; "Contract Date")
                {
                }
                field("Delivery Start Date"; "Delivery Start Date")
                {
                }
                field("Delivery End Date"; "Delivery End Date")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Qty. Received"; "Qty. Received")
                {
                }
                field(Status; Status)
                {
                }
                field("Check-off Amount"; "Check-off Amount")
                {
                }
                field("Qty. Pending Settlement"; "Qty. Pending Settlement")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Contract Lines")
            {
                RunObject = Page "Purchase Contract Lines";
                RunPageLink = "Contract No." = FIELD("No.");
                RunPageView = SORTING("Transaction Date");
            }
            action("Purchase Lines")
            {
                RunObject = Page "Purchase Lines";
                RunPageLink = "Purchase Contract No." = FIELD("No.");
            }
            action("Posted Purchase Receipts")
            {

                trigger OnAction()
                var
                    recPurchRcptHdr: Record "Purch. Rcpt. Header";
                begin
                    recPurchRcptHdr.Reset();
                    recPurchRcptHdr.SetRange("Purchase Contract No.", "No.");
                    if recPurchRcptHdr.FindSet() then begin
                        PAGE.RunModal(145, recPurchRcptHdr);
                    end;
                end;
            }
            action("Posted Purchase Invoices")
            {

                trigger OnAction()
                var
                    recPurchInvHdr: Record "Purch. Inv. Header";
                begin
                    recPurchInvHdr.Reset();
                    recPurchInvHdr.SetRange("Purchase Contract No.", "No.");
                    if recPurchInvHdr.FindSet() then begin
                        PAGE.RunModal(146, recPurchInvHdr);
                    end;
                end;
            }
        }
        area(reporting)
        {
            action("Contract Pricing Schedule")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    recContractHdr: Record "Purchase Contract Header";
                begin
                    recContractHdr.Reset();
                    recContractHdr.SetRange("No.", "No.");
                    recContractHdr.FindSet();
                    REPORT.RunModal(50009, true, true, recContractHdr);
                end;
            }
            action("Settlement Sheet Detail")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    recPurchContractHdr: Record "Purchase Contract Header";
                begin
                    recPurchContractHdr.Reset();
                    recPurchContractHdr.SetRange("No.", "No.");
                    if recPurchContractHdr.FindSet() then begin
                        REPORT.RunModal(50024, true, true, recPurchContractHdr);
                    end else begin
                        Message('No Settlement Lines to print');
                    end;
                end;
            }
        }
    }
}

