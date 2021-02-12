page 50017 "Purchase Contract"
{
    PageType = Document;
    SourceTable = "Purchase Contract Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                    QuickEntry = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
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
                field("Quality Premium Code"; "Quality Premium Code")
                {
                    Editable = false;
                }
                field("Check-off %"; "Check-off %")
                {
                    Editable = false;
                }
                field("Qty. Received"; "Qty. Received")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Qty. Settled"; "Qty. Settled")
                {
                }
                field("Qty. Pending Settlement"; "Qty. Pending Settlement")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Status Closed Date"; "Status Closed Date")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Deferred Payment"; "Deferred Payment")
                {

                    trigger OnValidate()
                    begin
                        EditDeferDate := "Deferred Payment" = true;
                        DeferCheck();
                    end;
                }
                field("Deferred Date"; "Deferred Date")
                {

                    trigger OnValidate()
                    begin
                        DeferCheck();
                    end;
                }
            }
            part(Lines; "Purchase Contract Subform")
            {
                SubPageLink = "Contract No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Process)
            {
                Ellipsis = true;
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchContractMgt: Codeunit "Purchase Contract Checkoff Mgt";
                    ContractSettMgt: Codeunit "Contract Settlement Management";
                begin
                    //PurchContractMgt.Pay(Rec);
                    ContractSettMgt.ProcessSettlement(Rec);
                end;
            }
            action(Close)
            {
                Ellipsis = true;
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction()
                var
                    ContractSettMgt: Codeunit "Contract Settlement Management";
                begin
                    ContractSettMgt.CloseContract(Rec);
                end;
            }
            action("Re-open ")
            {
                Ellipsis = true;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction()
                var
                    ContractSettMgt: Codeunit "Contract Settlement Management";
                begin
                    ContractSettMgt.ReopenContract(Rec);
                end;
            }
        }
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

    trigger OnAfterGetRecord()
    begin
        CalculateQtyPendingSettl();

        EditDeferDate := "Deferred Payment" = true;
        CalculateQtyPendingSettl();
        DeferCheck();
    end;

    trigger OnInit()
    begin
        EditDeferDate := false;
    end;

    var
        EditDeferDate: Boolean;

    [Scope('Internal')]
    procedure DeferCheck()
    var
        AllowSettlement: Boolean;
    begin
        AllowSettlement := true;
        if ("Deferred Payment" = true) and ("Deferred Date" > Today) then
            AllowSettlement := false;
        CurrPage.Lines.PAGE.AllowSettlement(AllowSettlement);
    end;
}

