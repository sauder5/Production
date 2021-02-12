page 50036 "Current/History PO SubForm"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    Visible = false;
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                    Visible = false;
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Nonstock; Nonstock)
                {
                    Visible = false;
                }
                field("GST/HST"; "GST/HST")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    Visible = false;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("PO Qty Change Reason"; "PO Qty Change Reason")
                {
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    BlankZero = true;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Job Remaining Qty."; "Job Remaining Qty.")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    BlankZero = true;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    Visible = false;
                }
                field("Provincial Tax Area Code"; "Provincial Tax Area Code")
                {
                    Visible = false;
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                }
                field("Use Tax"; "Use Tax")
                {
                    Visible = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    Visible = false;
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                    Visible = false;
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                    BlankZero = true;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    BlankZero = true;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                    BlankZero = true;
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                    BlankZero = true;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    Visible = false;
                }
                field("Job Planning Line No."; "Job Planning Line No.")
                {
                    Visible = false;
                }
                field("Job Line Type"; "Job Line Type")
                {
                    Visible = false;
                }
                field("Job Unit Price"; "Job Unit Price")
                {
                    Visible = false;
                }
                field("Job Line Amount"; "Job Line Amount")
                {
                    Visible = false;
                }
                field("Job Line Discount Amount"; "Job Line Discount Amount")
                {
                    Visible = false;
                }
                field("Job Line Discount %"; "Job Line Discount %")
                {
                    Visible = false;
                }
                field("Job Total Price"; "Job Total Price")
                {
                    Visible = false;
                }
                field("Job Unit Price (LCY)"; "Job Unit Price (LCY)")
                {
                    Visible = false;
                }
                field("Job Total Price (LCY)"; "Job Total Price (LCY)")
                {
                    Visible = false;
                }
                field("Job Line Amount (LCY)"; "Job Line Amount (LCY)")
                {
                    Visible = false;
                }
                field("Job Line Disc. Amount (LCY)"; "Job Line Disc. Amount (LCY)")
                {
                    Visible = false;
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                    Visible = false;
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                    Visible = false;
                }
                field("Planned Receipt Date"; "Planned Receipt Date")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = false;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    Visible = false;
                }
                field("Operation No."; "Operation No.")
                {
                    Visible = false;
                }
                field("Work Center No."; "Work Center No.")
                {
                    Visible = false;
                }
                field(Finished; Finished)
                {
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; "Whse. Outstanding Qty. (Base)")
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("IRS 1099 Liable"; "IRS 1099 Liable")
                {
                    Visible = false;
                }
                field("Over Receive"; "Over Receive")
                {
                    Visible = false;
                }
                field("Over Receive Verified"; "Over Receive Verified")
                {
                    Visible = false;
                }
                field("EDI Unit Cost"; "EDI Unit Cost")
                {
                    Visible = false;
                }
                field("EDI Cost Discrepancy"; "EDI Cost Discrepancy")
                {
                    Visible = false;
                }
                field("EDI Segment Group"; "EDI Segment Group")
                {
                    Visible = false;
                }
                field("Original PO Qty"; "Original PO Qty")
                {
                }
                field("Line No."; "Line No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    var
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
    end;

    trigger OnOpenPage()
    begin

        if PurchHeader.Get(1, poNum) then begin
            PurchLine.SetFilter("Document Type", '%1', "Document Type"::Order);
            PurchLine.SetFilter("Document No.", poNum);
            if PurchLine.FindSet then
                repeat
                    TransferFields(PurchLine);
                    Insert;
                until PurchLine.Next = 0;
        end else begin
            ReceiptLine.SetCurrentKey("Order No.", "Order Line No.");
            ReceiptLine.SetFilter("Order No.", poNum);
            if ReceiptLine.FindSet then
                repeat
                    ReceiptLine.SetRange("Order Line No.", ReceiptLine."Order Line No.");
                    ReceiptLine.CalcSums(Quantity, "Quantity Invoiced", "Quantity (Base)", "Qty. Invoiced (Base)");
                    ReceiptLine."Document No." := poNum;
                    TransferFields(ReceiptLine);
                    "Line Amount" := Quantity * "Unit Cost";
                    Insert;
                    ReceiptLine.SetRange("Order Line No.");
                    ReceiptLine."Order Line No." := ReceiptLine."Order Line No." + 1;
                until not ReceiptLine.Find('>');
        end;

        FindFirst;
    end;

    var
        Text000: Label 'Unable to run this function while in View mode.';
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
        poNum: Code[20];
        PurchHeader: Record "Purchase Header";
        ReceiptHeader: Record "Purch. Rcpt. Header";
        PurchLine: Record "Purchase Line";
        ReceiptLine: Record "Purch. Rcpt. Line";

    [Scope('Internal')]
    procedure setPONum(PONumber: Code[20])
    begin
        poNum := PONumber;
    end;
}

