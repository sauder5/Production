codeunit 50009 "Contract Settlement Management"
{
    // //SOC-SC 08-09-15
    //   Populate discount and premium fields
    // 
    // //SOC-SC 10-06-15
    //   Fix premium issue
    // 
    // //SOC-SC 10-09-15
    //   Fixed Vendor Invoice No. issue
    // 
    // //SOC-SC 08-01-16
    //   Check for Allowed Posting Date when trying to process settlement


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure ProcessSettlement(var PurchContract: Record "Purchase Contract Header")
    var
        recPurchContSett: Record "Purchase Contract Line";
        tPostingDate: Date;
        cLastPINo: Code[20];
        recPILn: Record "Purch. Inv. Line";
        dQty: Decimal;
        iCnt: Integer;
        recPIHdr: Record "Purch. Inv. Header";
        RuppSetup: Record "Rupp Setup";
    begin
        tPostingDate := PurchContract."Posting Date";
        CheckForPay(PurchContract);
        recPurchContSett.Reset();
        recPurchContSett.SetRange("Contract No.", PurchContract."No.");
        recPurchContSett.SetRange("Transaction Type", recPurchContSett."Transaction Type"::Settlement);
        recPurchContSett.SetRange("Post Invoice to Pay", true);
        recPurchContSett.SetRange("Settlement Invoiced", false);
        if recPurchContSett.FindSet() then begin
            if not Confirm('Do you want to process %1 Settlements?', false, recPurchContSett.Count()) then
                exit;

            cLastPINo := '';
            recPILn.Reset();
            if recPILn.FindLast() then cLastPINo := recPILn."Document No.";

            repeat
                if Settle(recPurchContSett, dQty, tPostingDate) then begin
                    iCnt += 1;
                    recPurchContSett."Recd/Settled Qty. Invoiced" += dQty;
                    recPurchContSett.UpdateQtyNotInvoiced();
                    recPurchContSett."Post Invoice to Pay" := false;
                    recPurchContSett."Settlement Invoiced" := true;
                    recPurchContSett.Modify();
                    //LogRelationEntry(recPurchContSett);
                end;
            until recPurchContSett.Next = 0;
            PurchContract."Posting Date" := 0D;
        end;

        if iCnt > 0 then begin
            RuppSetup.Get();
            if RuppSetup."Print Purch Inv on Settlement" then begin //print Purchase Invoice report
                Commit;
                recPILn.Reset();
                if cLastPINo <> '' then recPILn.SetFilter("Document No.", '>%1', cLastPINo);
                recPILn.SetRange("Purchase Contract No.", PurchContract."No.");
                recPILn.SetRange("Posting Date", tPostingDate);
                if recPILn.FindSet() then begin
                    repeat
                        recPIHdr.Get(recPILn."Document No.");
                        recPIHdr.Mark(true);
                    until recPILn.Next = 0;
                end;
                recPIHdr.MarkedOnly(true);
                if recPIHdr.FindSet() then begin
                    REPORT.RunModal(10121, true, true, recPIHdr);
                end;
            end;

            Commit;
            Message('Processed %1 Settlement lines', iCnt);
        end else begin
            Message('No Settlements processed');
        end;
    end;

    [Scope('Internal')]
    procedure CheckForPay(PurchContract: Record "Purchase Contract Header")
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        PurchContract.TestField(Status, PurchContract.Status::Open);
        PurchContract.TestField(PurchContract."Vendor No.");
        PurchContract.TestField(PurchContract."Contract Date");
        //PurchContract.TESTFIELD(PurchContract."Delivery Start Date");
        //PurchContract.TESTFIELD(PurchContract."Delivery End Date");
        PurchContract.TestField(PurchContract."Item No.");
        PurchContract.TestField(PurchContract.Quantity);
        PurchContract.TestField("Posting Date");
        PurchContract.TestField("Purch. Unit of Measure Code");

        RuppFun.CheckAllowedPostingDate(PurchContract."Posting Date", UserId); //SOC-SC 08-01-16
    end;

    [Scope('Internal')]
    procedure Settle(var recPurchContSett: Record "Purchase Contract Line"; var retQtySettled: Decimal; PostingDate: Date) retOK: Boolean
    var
        recContractRcptLn: Record "Purchase Contract Line";
        dQtyToInvoice: Decimal;
        dSettQtyLeftToInv: Decimal;
        recPL: Record "Purchase Line";
        bLoopDone: Boolean;
        dQtyLeft: Decimal;
        recPH: Record "Purchase Header";
        dUnitCost: Decimal;
        dQty: Decimal;
        cuReleasePO: Codeunit "Release Purchase Document";
        recPL1: Record "Purchase Line";
        recInvContLn: Record "Purchase Contract Line";
    begin
        retQtySettled := 0;
        retOK := false;

        recContractRcptLn.Reset();
        recContractRcptLn.SetRange("Contract No.", recPurchContSett."Contract No.");
        recContractRcptLn.SetRange("Transaction Type", recContractRcptLn."Transaction Type"::Receipt);

        dSettQtyLeftToInv := recPurchContSett.Quantity; // * (recPurchContSett."Invoice %"/100);
        while dSettQtyLeftToInv > 0 do begin

            if recContractRcptLn.FindSet() then begin
                repeat
                    if recContractRcptLn."Recd/Settled Qty. Not Invoiced" > 0 then begin
                        if recContractRcptLn."Recd/Settled Qty. Not Invoiced" > dSettQtyLeftToInv then begin
                            dQtyToInvoice := dSettQtyLeftToInv;
                        end else begin
                            dQtyToInvoice := recContractRcptLn."Recd/Settled Qty. Not Invoiced";
                        end;

                        CreateInvoiceLine(recPurchContSett, false, recContractRcptLn, dQtyToInvoice, PostingDate, recInvContLn);
                        ProcessInvoiceLine(recInvContLn, PostingDate);
                        recContractRcptLn."Recd/Settled Qty. Invoiced" += dQtyToInvoice;
                        recContractRcptLn.UpdateQtyNotInvoiced();
                        recContractRcptLn.Modify();

                        retQtySettled += dQtyToInvoice;
                        dSettQtyLeftToInv -= dQtyToInvoice;
                        LogRelationEntry(recInvContLn, recContractRcptLn."Line No.", dQtyToInvoice);
                    end;
                until (recContractRcptLn.Next = 0) or (dSettQtyLeftToInv <= 0);
            end;
            if dSettQtyLeftToInv > 0 then begin
                CreateInvoiceLine(recPurchContSett, true, recContractRcptLn, dSettQtyLeftToInv, PostingDate, recInvContLn);
                ProcessInvoiceLine(recInvContLn, PostingDate);
                retQtySettled += dSettQtyLeftToInv;
                dSettQtyLeftToInv := 0;
            end;
        end;

        //retQtySettled := recPurchContSett.Quantity - dSettQtyLeftToInv;
        retOK := true;
    end;

    [Scope('Internal')]
    procedure CreateInvoiceLine(recSettLn: Record "Purchase Contract Line"; CreateNew: Boolean; recContractRcptLn: Record "Purchase Contract Line"; QtyToInvoice: Decimal; PostingDate: Date; var recInvContLn: Record "Purchase Contract Line")
    var
        iLineNo: Integer;
        recPL: Record "Purchase Line";
        dQtyLeftToInvoice: Decimal;
        dQty: Decimal;
        dInvoiceUnitCost: Decimal;
    begin
        recInvContLn.Reset();
        recInvContLn.SetRange("Contract No.", recSettLn."Contract No.");
        recInvContLn.SetRange("Transaction Type", recInvContLn."Transaction Type"::Invoice);
        if recInvContLn.FindLast() then begin
            iLineNo += recInvContLn."Line No." + 10000;
        end else begin
            iLineNo := 10000;
        end;

        recInvContLn.Init();
        recInvContLn."Contract No." := recSettLn."Contract No.";
        recInvContLn."Transaction Type" := recInvContLn."Transaction Type"::Invoice;
        recInvContLn."Line No." := iLineNo;
        recInvContLn.Insert(true);

        recInvContLn."Invoice %" := recSettLn."Invoice %";
        recInvContLn."Settlement Unit Cost" := recSettLn."Settlement Unit Cost";
        recInvContLn."Settled Line No." := recSettLn."Line No.";
        recInvContLn."Posting Date" := recSettLn."Posting Date";
        recInvContLn.Validate(Quantity, QtyToInvoice);
        recInvContLn.UpdateQtyNotRecd();
        if not CreateNew then begin
            recInvContLn."Receipt No." := recContractRcptLn."Receipt No.";
            recInvContLn."Receipt Line No." := recContractRcptLn."Receipt Line No.";
            recInvContLn.Validate("Premium/ Discount Unit Cost", recContractRcptLn."Recd. Unit Premium/Discount");

            //SOC-SC 08-09-15
            recInvContLn."Recd. Splits Unit Premium" := recContractRcptLn."Recd. Splits Unit Premium";
            recInvContLn."Recd. Test Weight Unit Disc" := recContractRcptLn."Recd. Test Weight Unit Disc";
            recInvContLn."Recd. Vomitoxin Unit Discount" := recContractRcptLn."Recd. Vomitoxin Unit Discount";
            recInvContLn."Recd. Seed Unit Premium" := recContractRcptLn."Recd. Seed Unit Premium";
            recInvContLn."Recd. Splits Premium Amount" := recContractRcptLn."Recd. Splits Premium Amount";
            recInvContLn."Recd. Test Weight Disc Amount" := recContractRcptLn."Recd. Test Weight Disc Amount";
            recInvContLn."Recd. Vomitoxin Disc Amount" := recContractRcptLn."Recd. Vomitoxin Disc Amount";
            recInvContLn."Recd. Seed Premium Amount" := recContractRcptLn."Recd. Seed Premium Amount";
            //SOC-SC 08-09-15

        end;
        recInvContLn.Modify();
    end;

    [Scope('Internal')]
    procedure ProcessInvoiceLine(recInvSettLn: Record "Purchase Contract Line"; PostingDate: Date)
    var
        recPurchConLn: Record "Purchase Contract Line";
        iLineNo: Integer;
        recPL: Record "Purchase Line";
        dQtyLeftToInvoice: Decimal;
        dQty: Decimal;
        dInvoiceUnitCost: Decimal;
        sPONo: Code[20];
        iPOLineNo: Integer;
        dQtyToInv: Decimal;
        recPH: Record "Purchase Header";
    begin
        if recInvSettLn."Invoice Line Amount" = 0 then
            Error('Invoice Line Amount is zero on the Invoice line');

        dQtyLeftToInvoice := recInvSettLn.Quantity;
        dInvoiceUnitCost := recInvSettLn."Invoice Unit Cost"; //  * (recInvSettLn."Invoice %"/100);

        if (recInvSettLn."Receipt No." <> '') and (recInvSettLn."Receipt Line No." <> 0) then begin
            recPL.Reset();
            recPL.SetRange("Document Type", recPL."Document Type"::Order);
            recPL.SetRange("Rcpt No.", recInvSettLn."Receipt No.");
            recPL.SetRange("Rcpt Line No.", recInvSettLn."Receipt Line No.");
            recPL.SetRange("Auto-generating Process", recPL."Auto-generating Process"::Receipt);
            //recPL.SETFILTER("Qty. Rcd. Not Invoiced", '>%1', 0);
            if recPL.FindSet() then begin
                repeat
                    if recPL."Qty. Rcd. Not Invoiced" <> 0 then begin
                        if dQtyLeftToInvoice > recPL."Qty. Rcd. Not Invoiced" then begin
                            dQtyToInv := recPL."Qty. Rcd. Not Invoiced";
                        end else begin
                            dQtyToInv := dQtyLeftToInvoice;
                        end;
                        recPL.SuspendStatusCheck(true);
                        recPL.Validate("Qty. to Receive", 0);
                        recPL.Validate("Qty. to Invoice", dQtyToInv); //dQtyLeftToInvoice);
                        recPL.Validate("Direct Unit Cost", dInvoiceUnitCost);
                        recPL."Purchase Contract Inv Line No." := recInvSettLn."Line No."; //Purchase Contract No. must be same already
                        recPL.Modify();

                        UpdateOtherPOLines(recPL); //SOC-SC 10-06-15

                        //        PostInvoicePO(recPL."Document No.", FALSE, recInvSettLn."Posting Date");
                        PostInvoicePO(recPL."Document No.", false, PostingDate);  //RSI-KS

                        sPONo := recPL."Document No.";
                        iPOLineNo := recPL."Line No.";
                        dQtyLeftToInvoice -= dQtyToInv;
                    end;
                until (recPL.Next = 0) or (dQtyLeftToInvoice <= 0);
                //?? ** if dQtyLeftToInvoice > 0 ??
            end;
            recInvSettLn."Invoiced Line Received Qty" += recInvSettLn.Quantity;
        end else begin
            //Create new PL and do Prepayment Invoice for it
            CreatePOAndPrepay(recInvSettLn, dQtyLeftToInvoice, dInvoiceUnitCost, PostingDate, sPONo, iPOLineNo);
        end;
        recInvSettLn.UpdateQtyNotRecd();
        recInvSettLn."Purchase Order No." := sPONo;
        recInvSettLn."Purchase Order Line No." := iPOLineNo;
        recInvSettLn.Modify();
    end;

    [Scope('Internal')]
    procedure CreatePOAndPrepay(recPurchContSett: Record "Purchase Contract Line"; Qty: Decimal; InvoiceUnitCost: Decimal; PostingDate: Date; var retPONo: Code[20]; var retPOLineNo: Integer)
    var
        recPH: Record "Purchase Header";
    begin
        CreateNewPOForPrepmt(recPurchContSett, Qty, InvoiceUnitCost, PostingDate, recPH, retPOLineNo);
        CreatePrepaymentInv(recPH);
        retPONo := recPH."No.";
    end;

    [Scope('Internal')]
    procedure CreateNewPOForPrepmt(PurchContSett: Record "Purchase Contract Line"; Qty: Decimal; InvoiceUnitCost: Decimal; PostingDate: Date; var recPH: Record "Purchase Header"; var retPOLineNo: Integer) retRcvd: Boolean
    var
        recPL: Record "Purchase Line";
        recitem: Record Item;
        recRupPSetup: Record "Rupp Setup";
    begin
        retRcvd := false;

        recPH.Init();
        recPH."Document Type" := recPH."Document Type"::Order;
        recPH."No." := '';
        recPH.Insert(true);
        recPH.Validate("Buy-from Vendor No.", PurchContSett."Vendor No.");
        recRupPSetup.Get();
        recPH.Validate("Location Code", recRupPSetup."Location Code for Contract");
        recPH."Vendor Invoice No." := recPH."No." + '-01';
        recPH.Validate("Posting Date", PostingDate);
        recPH.Modify;

        recPL.Init();
        recPL."Document Type" := recPH."Document Type";
        recPL.Validate("Document No.", recPH."No.");
        recPL.Validate("Line No.", 10000);
        recPL.Validate("Buy-from Vendor No.", PurchContSett."Vendor No.");
        recPL.Validate(Type, recPL.Type::Item);
        recPL.Validate("No.", PurchContSett."Item No.");
        recPL.Validate(Quantity, Qty);
        recitem.Get(PurchContSett."Item No.");
        recPL.SetRange("Unit of Measure Code", PurchContSett."Purch. Unit of Measure Code");//recitem."Purch. Unit of Measure");
        recPL.Validate("Direct Unit Cost", InvoiceUnitCost);
        recPL.Validate("Qty. to Receive", recPL.Quantity);
        recPL.Validate("Prepmt. Line Amount", recPL.Amount);
        recPL.Validate("Purchase Contract No.", PurchContSett."Contract No.");
        recPL.Validate("Purchase Contract Inv Line No.", PurchContSett."Line No.");
        PurchContSett.CalcFields("Quality Premium Code", "Check-off %");
        recPL."Auto-generating Process" := recPL."Auto-generating Process"::"Purchase Contract";
        recPL.Insert(true);
        retPOLineNo := recPL."Line No.";
    end;

    [Scope('Internal')]
    procedure CreatePrepaymentInv(var recPH: Record "Purchase Header")
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        recSH: Record "Sales Header";
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
    begin
        if ApprovalMgt.PrePostApprovalCheckPurch(recPH) then
            PurchPostPrepmt.Invoice(recPH);
    end;

    [Scope('Internal')]
    procedure CloseContract(PurchContract: Record "Purchase Contract Header")
    var
        recPurchContLn: Record "Purchase Contract Line";
        iCnt: Integer;
        dQty: Decimal;
    begin
        PurchContract.TestField(Status, PurchContract.Status::Open);

        recPurchContLn.Reset();
        recPurchContLn.SetRange("Contract No.", PurchContract."No.");
        if recPurchContLn.Count = 0 then
            Error('No lines exist');

        recPurchContLn.SetRange("Transaction Type", recPurchContLn."Transaction Type"::Settlement);
        recPurchContLn.SetRange("Settlement Invoiced", false);
        if recPurchContLn.FindFirst() then
            Error('There are Settlement lines that have not been processsed (invoiced). Please process them and try agin');

        PurchContract.CalcFields("Qty. Received", "Qty. Settled");
        if PurchContract."Qty. Received" <> PurchContract."Qty. Settled" then
            Error('Total received quantity is %1,but total settled quantity is %2', PurchContract."Qty. Received", PurchContract."Qty. Settled");

        recPurchContLn.SetRange("Settlement Invoiced");
        if recPurchContLn.FindFirst() then begin
            if not Confirm('Do you want to Close the Purchase Contract?', false, PurchContract."No.") then
                exit;

            PurchContract.Validate(Status, PurchContract.Status::Closed);
            PurchContract.Modify();
            Commit;
            Message('Closed Purchase Contract %1', PurchContract."No.");
        end;
    end;

    [Scope('Internal')]
    procedure ReopenContract(PurchContract: Record "Purchase Contract Header")
    begin
        PurchContract.TestField(Status, PurchContract.Status::Closed);

        if not Confirm('Do you want to Re-open the Purchase Contract?', false, PurchContract."No.") then
            exit;

        PurchContract.Validate(Status, PurchContract.Status::Open);
        PurchContract.Modify();
        Commit;
        Message('Re-opened Purchase Contract %1. Please ''Close'' it when you are done with it', PurchContract."No.");
    end;

    [Scope('Internal')]
    procedure LogRelationEntry(InvPurchConLn: Record "Purchase Contract Line"; RcptLineNo: Integer; QtyReceived: Decimal)
    var
        recContractRelation: Record "Contract Rcpt-Invoice Link";
        iEntryNo: Integer;
        dtCreatedDateTime: DateTime;
    begin
        recContractRelation.Reset();
        if recContractRelation.FindLast() then begin
            iEntryNo := recContractRelation."Entry No.";
        end;
        dtCreatedDateTime := CurrentDateTime;

        iEntryNo += 1;
        recContractRelation.Init();
        recContractRelation."Entry No." := iEntryNo;
        recContractRelation."Contract No." := InvPurchConLn."Contract No.";
        recContractRelation."Receipt No." := InvPurchConLn."Receipt No.";
        recContractRelation."Receipt Line No." := InvPurchConLn."Receipt Line No.";
        recContractRelation."Contract Receipt Line No." := RcptLineNo;
        recContractRelation."Settlement Line No." := InvPurchConLn."Settled Line No.";
        recContractRelation."Invoice Line No." := InvPurchConLn."Line No.";
        recContractRelation."Created By" := UserId;
        recContractRelation."Created DateTime" := dtCreatedDateTime;
        recContractRelation."Quantity Linked" := QtyReceived;
        recContractRelation.Insert();
    end;

    [Scope('Internal')]
    procedure PostInvoicePO(PONo: Code[20]; Rcv: Boolean; PostingDate: Date)
    var
        recPurchHdr: Record "Purchase Header";
    begin
        recPurchHdr.Get(recPurchHdr."Document Type"::Order, PONo);
        recPurchHdr.Receive := Rcv;
        recPurchHdr.Invoice := true;
        //recPurchHdr."Vendor Invoice No." := INCSTR(recPurchHdr."Vendor Invoice No.");
        //IF recPurchHdr."Vendor Invoice No." = '' THEN recPurchHdr."Vendor Invoice No." := recPurchHdr."No."+'-01';

        //SOC-SC 10-09-15
        if recPurchHdr."Vendor Invoice No." = '' then begin
            recPurchHdr."Vendor Invoice No." := recPurchHdr."No." + '-01';
        end else begin
            recPurchHdr."Vendor Invoice No." := IncStr(recPurchHdr."Vendor Invoice No.");
        end;
        //SOC-SC 10-09-15
        if PostingDate <> 0D then
            recPurchHdr.Validate("Posting Date", PostingDate)
        else
            recPurchHdr.Validate("Posting Date", Today);

        recPurchHdr.Modify();
        CODEUNIT.Run(CODEUNIT::"Purch.-Post", recPurchHdr);
    end;

    local procedure UpdateOtherPOLines(var PurchLn: Record "Purchase Line")
    var
        recPL: Record "Purchase Line";
    begin
        recPL.Reset();
        recPL.SetRange("Document Type", PurchLn."Document Type");
        recPL.SetRange("Document No.", PurchLn."Document No.");
        recPL.SetFilter("Line No.", '<>%1', PurchLn."Line No.");
        recPL.SetFilter("Qty. Rcd. Not Invoiced", '>%1', 0);
        if recPL.FindSet() then begin
            repeat
                recPL.Validate("Qty. to Invoice", 0);
                recPL.Modify();
            until recPL.Next = 0;
        end;

        recPL.SetRange(Type, recPL.Type::"G/L Account");
        if recPL.FindFirst() then begin
            recPL.Validate("Qty. to Invoice", PurchLn."Qty. to Invoice");
            recPL.Modify();
        end;
    end;
}

