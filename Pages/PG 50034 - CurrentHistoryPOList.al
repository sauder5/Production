page 50034 "Current/History PO List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.Status = Rec.Status::History then
                            PAGE.Run(50035, Rec)
                        else
                            PAGE.Run(50, Rec);
                    end;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        PurchHead.FindFirst;
        repeat
            TransferFields(PurchHead);
            Insert;
        until PurchHead.Next = 0;

        ReceiptHead.FindFirst;
        repeat
            if not Get("Document Type"::Order, ReceiptHead."Order No.") then begin
                TransferFields(ReceiptHead);
                "No." := ReceiptHead."Order No.";
                "Document Type" := "Document Type"::Order;
                Status := Status::History;
                Insert;
            end;
        until ReceiptHead.Next = 0;

        FindFirst;
    end;

    var
        PurchHead: Record "Purchase Header";
        ReceiptHead: Record "Purch. Rcpt. Header";
}

