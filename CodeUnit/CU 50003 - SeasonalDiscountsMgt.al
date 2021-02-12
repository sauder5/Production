codeunit 50003 "Seasonal Discounts Mgt."
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CalculateSeasonalDisc_(ApplyingPmtCLE: Record "Cust. Ledger Entry"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        recSeasonalCashDisc: Record "Seasonal Cash Discount";
        dDiscountAmt: Decimal;
        dApplyAmt: Decimal;
        recDocNoForSeasPmt: Record "Research Plots";
        iDocType: Integer;
        cDocNo: Code[20];
        recSIH: Record "Sales Invoice Header";
        bLinkedInvoicesExist: Boolean;
        bCalcDiscount: Boolean;
        iCntApplied: Integer;
        dRemainingAmtToApply: Decimal;
    begin
        /*//Called page 232: Apply Customer Entries
        ApplyingPmtCLE.TESTFIELD("Document Type", ApplyingPmtCLE."Document Type"::Payment);
        
        recDocNoForSeasPmt.RESET();
        recDocNoForSeasPmt.SETRANGE("Payment Document No.", ApplyingPmtCLE."Document No.");
        recDocNoForSeasPmt.SETFILTER(Description, '<>%1', 0);
        bLinkedInvoicesExist := recDocNoForSeasPmt.FINDFIRST();
        
        ApplyingPmtCLE.CALCFIELDS("Remaining Amount");
        dRemainingAmtToApply := ApplyingPmtCLE."Remaining Amount";
        
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        IF bLinkedInvoicesExist THEN BEGIN
          REPEAT
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            IF CustLedgerEntry."Applies-to ID" <> '' THEN BEGIN
              IF CustLedgerEntry."Applies-to ID" <> ApplyingPmtCLE."Applies-to ID" THEN BEGIN
                ERROR('Invoice %1 is already being applied by %2', CustLedgerEntry."Document No.", CustLedgerEntry."Applies-to ID");
              END;
            END;
        
            recDocNoForSeasPmt.SETRANGE(Description, CustLedgerEntry."Entry No.");
            IF recDocNoForSeasPmt.FINDFIRST() THEN BEGIN
              CalculateInvSeasonalDisc(recDocNoForSeasPmt, CustLedgerEntry."Remaining Amount", dDiscountAmt, dApplyAmt);
              IF dApplyAmt > 0 THEN BEGIN
                CustLedgerEntry.VALIDATE("Applies-to ID", ApplyingPmtCLE."Applies-to ID");
                CustLedgerEntry.VALIDATE("Amount to Apply", dApplyAmt);
                CustLedgerEntry.VALIDATE("Remaining Pmt. Disc. Possible", dDiscountAmt);
                CustLedgerEntry.VALIDATE("Pmt. Discount Date", WORKDATE + 1);
                CustLedgerEntry.MODIFY();
                iCntApplied +=1;
        
                dRemainingAmtToApply := dRemainingAmtToApply + dApplyAmt;
              END;
        
            END;
          UNTIL CustLedgerEntry.NEXT = 0;
        END;
        
        COMMIT;
        MESSAGE('Number of entries applied: %1 for applying Entry # %2', iCntApplied, ApplyingPmtCLE."Entry No.");
        */

    end;

    [Scope('Internal')]
    procedure CheckOKToCalculateDisc(ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; SIH: Record "Sales Invoice Header") retOK: Boolean
    var
        recOrdNoForSeasDisc: Record "Research Plots";
    begin
        /*retOK := FALSE;
        recOrdNoForSeasDisc.RESET();
        recOrdNoForSeasDisc.SETRANGE("Payment Document Type", ApplyingCustLedgEntry."Document No.");
        recOrdNoForSeasDisc.SETRANGE("Document Type", SIH."No.");
        retOK := recOrdNoForSeasDisc.FINDFIRST();
        
        IF NOT retOK THEN BEGIN
          recOrdNoForSeasDisc.SETRANGE("Document Type");
          IF SIH."Order No." <> '' THEN BEGIN
            recOrdNoForSeasDisc.SETRANGE("Payment Document No.", 1);
            recOrdNoForSeasDisc.SETRANGE(recOrdNoForSeasDisc."Customer No.", SIH."Order No.");
            retOK := recOrdNoForSeasDisc.FINDFIRST();
          END ELSE BEGIN
            IF SIH."Pre-Assigned No." <> '' THEN BEGIN
              recOrdNoForSeasDisc.SETRANGE("Payment Document No.", 2);
              recOrdNoForSeasDisc.SETRANGE(recOrdNoForSeasDisc."Customer No.", SIH."Pre-Assigned No.");
              retOK := recOrdNoForSeasDisc.FINDFIRST();
            END;
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure CalculateInvSeasonalDisc(DocNoForSeasPmt: Record "Research Plots"; InvRemAmt: Decimal; var retDiscountAmt: Decimal; var retApplyAmt: Decimal)
    var
        recSeasDiscApplEntry: Record "Seasonal Discount Appl. Entry";
    begin
        /*retDiscountAmt  := 0;
        retApplyAmt     := 0;
        
        IF DocNoForSeasPmt."Amount Linked" = InvRemAmt THEN BEGIN
          recSeasDiscApplEntry.SETCURRENTKEY("Applied to Cust. Ledger Entry");
          recSeasDiscApplEntry.SETRANGE("Applied to Cust. Ledger Entry", DocNoForSeasPmt.Description);
          recSeasDiscApplEntry.SETFILTER("Discount Amount Not Applied", '>0');
          recSeasDiscApplEntry.SETRANGE(Unapplied, FALSE);
          IF recSeasDiscApplEntry.FINDSET() THEN BEGIN
            recSeasDiscApplEntry.CALCSUMS("Discount Amount Not Applied");
            retDiscountAmt  := DocNoForSeasPmt."Cash Discount Amount" + recSeasDiscApplEntry."Discount Amount Not Applied";
          END;
        END ELSE BEGIN
          retDiscountAmt  := DocNoForSeasPmt."Cash Discount Amount";
        END;
        retApplyAmt     := DocNoForSeasPmt."Amount Linked";
        */

    end;

    [Scope('Internal')]
    procedure CalculateInvSeasonalDisc_OLD(ApplyingPmtCLE: Record "Cust. Ledger Entry"; InvCLE: Record "Cust. Ledger Entry"; dRemainingAmtToApply: Decimal; var retDiscount: Decimal; var retApplAmt: Decimal)
    var
        recSIL: Record "Sales Invoice Line";
        recSeasonalCashDisc: Record "Seasonal Cash Discount";
        dDiscountPc: Decimal;
        dDiscountAmt: Decimal;
        iPaymentMonth: Integer;
        PaymentDate: Date;
        dAppliedAmt: Decimal;
        dRemainingAmt: Decimal;
    begin
        /*retDiscount := 0;
        retApplAmt  := 0;
        PaymentDate   := ApplyingPmtCLE."Posting Date";
        iPaymentMonth := DATE2DMY(PaymentDate, 2);
        
        recSeasonalCashDisc.RESET();
        recSeasonalCashDisc.SETRANGE("Payment Month", iPaymentMonth);
        recSeasonalCashDisc.SETRANGE("Starting Date",0D, PaymentDate);
        recSeasonalCashDisc.SETFILTER("Ending Date",'%1|>=%2',0D, PaymentDate);
        
        InvCLE.CALCFIELDS("Remaining Amount");
        ApplyingPmtCLE.CALCFIELDS("Remaining Amount");
        
        recSIL.RESET();
        recSIL.SETRANGE("Document No.", InvCLE."Document No.");
        recSIL.SETRANGE(Type, recSIL.Type::Item);
        recSIL.SETFILTER(Quantity, '>0');
        IF recSIL.FINDSET() THEN BEGIN
          REPEAT
            IF recSIL."Product Code" <> '' THEN BEGIN
              //recSeasonalCashDisc.SETRANGE("Planting Season", recSIL."Product Code"); **
              //If there is a Seasonal Cash Discount set up for this Product for this Payment Month..
              IF recSeasonalCashDisc.FINDFIRST() THEN BEGIN
                dDiscountPc  := recSeasonalCashDisc."Discount %";
        
                IF InvCLE."Remaining Amount" > -dRemainingAmtToApply THEN BEGIN
                  dRemainingAmt  := -dRemainingAmtToApply;
                END ELSE BEGIN
                  dRemainingAmt := InvCLE."Remaining Amount";
                END;
        
                dDiscountAmt := ROUND(dRemainingAmt *dDiscountPc/100, 0.01);
                dAppliedAmt  := dRemainingAmt - dDiscountAmt;
                retDiscount  += dDiscountAmt;
                retApplAmt   += dAppliedAmt;
        
                UpdateDocForSeasonalPymt(ApplyingPmtCLE, InvCLE, recSIL, dDiscountPc, dDiscountAmt, dAppliedAmt);
              END;
            END;
          UNTIL recSIL.FINDSET();
        END;
        */

    end;

    [Scope('Internal')]
    procedure UpdateDocForSeasonalPymt_Old(ApplyingPayment: Record "Cust. Ledger Entry"; InvoiceCLE: Record "Cust. Ledger Entry"; SalesInvLn: Record "Sales Invoice Line"; DiscountPc: Decimal; DiscountAmt: Decimal; AppliedAmt: Decimal)
    var
        recDocForSeasonalPmt: Record "Research Plots";
        recSIH: Record "Sales Invoice Header";
        recApplForSeasonalPmt: Record "Seasonal Discount Appl. Entry";
        iLineNo: Integer;
        iDocType: Integer;
        cDocNo: Code[20];
    begin
        /*recSIH.GET(SalesInvLn."Document No.");
        IF recSIH."Order No." <> '' THEN BEGIN
          iDocType := 1;
          cDocNo := recSIH."Order No.";
        END ELSE BEGIN
          iDocType := 2;
          cDocNo := recSIH."Pre-Assigned No.";
        END;
        
        IF NOT recDocForSeasonalPmt.GET(ApplyingPayment."Document No.", ApplyingPayment."Sell-to Customer No.",iDocType, cDocNo, InvoiceCLE."Document No.") THEN BEGIN
          recDocForSeasonalPmt.INIT();
          recDocForSeasonalPmt."Payment Document Type"   := ApplyingPayment."Document No.";
          recDocForSeasonalPmt."Payment Document No."          := iDocType;
          recDocForSeasonalPmt."Customer No."           := cDocNo;
          recDocForSeasonalPmt."Document Type" := SalesInvLn."Document No.";
          recDocForSeasonalPmt."Customer No."        := ApplyingPayment."Sell-to Customer No.";
          recDocForSeasonalPmt."Payment Method"     := ApplyingPayment."Payment Method Code";
          recDocForSeasonalPmt."Payment Amount"     := ApplyingPayment.Amount;
          recDocForSeasonalPmt."Payment Date"       := ApplyingPayment."Posting Date";
          recDocForSeasonalPmt."Cust. Ledger Entry of Payment" := ApplyingPayment."Entry No.";
          recDocForSeasonalPmt."Added at Application" := TRUE;
          recDocForSeasonalPmt.INSERT();
        END;
        
        recApplForSeasonalPmt.RESET();
        recApplForSeasonalPmt.SETRANGE("Payment Cust. Ledger Entry", ApplyingPayment."Document No.");
        recApplForSeasonalPmt.SETRANGE("Payment Document Type", recDocForSeasonalPmt."Customer No.");
        recApplForSeasonalPmt.SETRANGE("Customer No.", recDocForSeasonalPmt."Payment Document No.");
        recApplForSeasonalPmt.SETRANGE("Applied to Cust. Ledger Entry", recDocForSeasonalPmt."Customer No.");
        recApplForSeasonalPmt.SETRANGE("Posted Sales Invoice No.", SalesInvLn."Document No.");
        recApplForSeasonalPmt.SETRANGE("Applied to Doc Type", SalesInvLn."Document No.");
        recApplForSeasonalPmt.SETRANGE("Applied to Doc No.", SalesInvLn."Line No.");
        IF recApplForSeasonalPmt.FINDFIRST() THEN BEGIN
          IF recApplForSeasonalPmt.Applied THEN BEGIN
            ERROR('Invoice %1 has already been applied', SalesInvLn."Document No.");
          END;
        END ELSE BEGIN
          recApplForSeasonalPmt.SETRANGE("Applied to Doc Type");
          recApplForSeasonalPmt.SETRANGE("Applied to Doc No.");
          IF recApplForSeasonalPmt.FINDLAST() THEN
            iLineNo := recApplForSeasonalPmt."Line No.";
        
          recApplForSeasonalPmt.INIT();
          recApplForSeasonalPmt."Payment Cust. Ledger Entry"  := ApplyingPayment."Document No.";
          recApplForSeasonalPmt."Payment Document Type"          := recDocForSeasonalPmt."Customer No.";
          recApplForSeasonalPmt."Customer No."         := recDocForSeasonalPmt."Payment Document No.";
          recApplForSeasonalPmt."Applied to Cust. Ledger Entry"          := recDocForSeasonalPmt."Customer No.";
          recApplForSeasonalPmt."Posted Sales Invoice No." := SalesInvLn."Document No.";
          recApplForSeasonalPmt."Line No."              := iLineNo + 1;
          recApplForSeasonalPmt."Applied to Doc Type"           := SalesInvLn."Document No.";
          recApplForSeasonalPmt."Applied to Doc No."      := SalesInvLn."Line No.";
          recApplForSeasonalPmt."Added at Application"  := TRUE;
          recApplForSeasonalPmt.INSERT();
        END;
        
        recApplForSeasonalPmt."Payment Document No." := InvoiceCLE."Entry No.";
        recApplForSeasonalPmt."Product Code"          := SalesInvLn."Product Code";
        recApplForSeasonalPmt."Applied to Doc Type"           := InvoiceCLE."Document No.";
        recApplForSeasonalPmt."Discount %"            := DiscountPc;
        recApplForSeasonalPmt."Discount Amount"       := DiscountAmt;
        recApplForSeasonalPmt."Applied Amount"        := AppliedAmt;
        recApplForSeasonalPmt."Applied Date"          := TODAY;
        recApplForSeasonalPmt.MODIFY();
        */

    end;

    [Scope('Internal')]
    procedure CalculateSalesInvSeasonalDisc(ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; InvNo: Code[20]; var retDiscount: Decimal; var retApplAmt: Decimal)
    var
        recSIL: Record "Sales Invoice Line";
        recSeasonalCashDisc: Record "Seasonal Cash Discount";
        dDiscountPc: Decimal;
        dDiscountAmt: Decimal;
        iPaymentMonth: Integer;
        PaymentDate: Date;
        dAppliedAmt: Decimal;
        dRemainingAmt: Decimal;
    begin
        //Called from report 50002 (Sales invoice -Rupp)
        retDiscount := 0;
        retApplAmt := 0;
        PaymentDate := ApplyingCustLedgEntry."Posting Date";
        iPaymentMonth := Date2DMY(PaymentDate, 2);

        recSeasonalCashDisc.Reset();
        recSeasonalCashDisc.SetRange("Payment Month", iPaymentMonth);
        recSeasonalCashDisc.SetRange("Starting Date", 0D, PaymentDate);
        recSeasonalCashDisc.SetFilter("Ending Date", '%1|>=%2', 0D, PaymentDate);

        ApplyingCustLedgEntry.CalcFields("Remaining Amount");

        recSIL.Reset();
        recSIL.SetRange("Document No.", InvNo);
        recSIL.SetRange(Type, recSIL.Type::Item);
        recSIL.SetFilter(Quantity, '>0');
        if recSIL.FindSet() then begin
            repeat
                if recSIL."Product Code" <> '' then begin
                    //recSeasonalCashDisc.SETRANGE("Planting Season", recSIL."Product Code");***
                    //If there is a Seasonal Cash Discount set up for this Product for this Payment Month..
                    if recSeasonalCashDisc.FindFirst() then begin
                        dDiscountPc := recSeasonalCashDisc."Discount %";
                        dRemainingAmt := recSIL."Amount Including VAT";
                        dDiscountAmt := Round(dRemainingAmt * dDiscountPc / 100, 0.01);
                        dAppliedAmt := dRemainingAmt - dDiscountAmt;
                        retDiscount += dDiscountAmt;
                        retApplAmt += dAppliedAmt;
                    end;
                end;
            until recSIL.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure GetDiscPercentForInv_Old(InvCLE: Record "Cust. Ledger Entry"; PaymentDate: Date; var retDiscountAmt: Decimal; var retApplAmt: Decimal)
    var
        recProduct: Record Product;
        recSeasonalCashDisc: Record "Seasonal Cash Discount";
        recSIL: Record "Sales Invoice Line";
        dDiscountPc: Decimal;
        dRemainingAmt: Decimal;
        dDiscountAmt: Decimal;
        dAppliedAmt: Decimal;
    begin
        /*InvCLE.TESTFIELD("Document Type", InvCLE."Document Type"::Invoice);
        recSIL.RESET();
        recSIL.SETRANGE("Document No.", InvCLE."Document No.");
        recSIL.SETRANGE(Type, recSIL.Type::Item);
        recSIL.SETFILTER(Quantity, '>0');
        IF recSIL.FINDSET() THEN BEGIN
          REPEAT
            IF recSIL."Product Code" <> '' THEN BEGIN
              recProduct.GET(recSIL."Product Code");
              recSeasonalCashDisc.SETRANGE(Code, recProduct."Planting Season");
              recSeasonalCashDisc.SETRANGE("Payment Month", DATE2DMY(PaymentDate, 2));
              //If there is a Seasonal Cash Discount set up for this Product for this Payment Month..
              IF recSeasonalCashDisc.FINDFIRST() THEN BEGIN
                dDiscountPc  := recSeasonalCashDisc."Discount %";
                dRemainingAmt := InvCLE."Remaining Amount";
                dDiscountAmt := ROUND(dRemainingAmt *dDiscountPc/100, 0.01);
                dAppliedAmt  := dRemainingAmt - dDiscountAmt;
                retDiscountAmt  += dDiscountAmt;
                retApplAmt   += dAppliedAmt;
              END;
            END;
          UNTIL recSIL.NEXT =0;
        END;
        */

    end;

    [Scope('Internal')]
    procedure IsValidAmtToApply(var DocForSeasPmt: Record "Research Plots")
    var
        recDocForSeasPmt: Record "Research Plots";
        dPmtAmtRemaining: Decimal;
        recPymtCLE: Record "Cust. Ledger Entry";
        recGenJnlLn: Record "Gen. Journal Line";
        dAmtApplied: Decimal;
        iDocType: Integer;
        recSH: Record "Sales Header";
        recSIH: Record "Sales Invoice Header";
        dOrder_invAmt: Decimal;
    begin
        /*
        recPymtCLE.RESET();
        recPymtCLE.SETRANGE("Document Type", recPymtCLE."Document Type"::Payment);
        recPymtCLE.SETRANGE("Document No.", DocForSeasPmt."Payment Document No.");
        recPymtCLE.SETRANGE("Customer No.", DocForSeasPmt."Customer No.");
        IF recPymtCLE.FINDFIRST() THEN BEGIN
          recPymtCLE.CALCFIELDS("Remaining Amount");
          dPmtAmtRemaining := recPymtCLE."Remaining Amount";
        END ELSE BEGIN
          recGenJnlLn.RESET();
          recGenJnlLn.SETRANGE("Document Type", recGenJnlLn."Document Type"::Payment);
          recGenJnlLn.SETRANGE("Document No.", DocForSeasPmt."Payment Document No.");
          recGenJnlLn.SETRANGE("Account Type", recGenJnlLn."Account Type"::Customer);
          recGenJnlLn.SETRANGE("Account No.", DocForSeasPmt."Customer No.");
          IF recGenJnlLn.FINDFIRST() THEN BEGIN
            dPmtAmtRemaining := recGenJnlLn.Amount;
          END;
        END;
        
        CASE DocForSeasPmt."Document Type" OF
          DocForSeasPmt."Document Type"::Order:
            iDocType := 1;
          DocForSeasPmt."Document Type"::Invoice:
            iDocType := 2;
          DocForSeasPmt."Document Type"::"Posted Invoice":
            iDocType := 0;
        END;
        IF iDocType = 0 THEN BEGIN
          recSIH.GET(DocForSeasPmt."Document No.");
          recSIH.CALCFIELDS(Amount, recSIH."Amount Including VAT");
          dOrder_invAmt := recSIH.Amount;
        END ELSE BEGIN
          recSH.GET(iDocType, DocForSeasPmt."Document No.");
          recSH.CALCFIELDS(Amount, recSH."Amount Including VAT");
          dOrder_invAmt := recSH.Amount;
        END;
        
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Payment External Doc No.", DocForSeasPmt."Payment External Doc No.");
        recDocForSeasPmt.SETRANGE("Payment Type", DocForSeasPmt."Payment Type");
        recDocForSeasPmt.SETRANGE("Payment Document No.", DocForSeasPmt."Payment Document No.");
        recDocForSeasPmt.SETRANGE("Customer No.", DocForSeasPmt."Customer No.");
        recDocForSeasPmt.SETFILTER("Document No.", '<>%1', DocForSeasPmt."Document No.");
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          REPEAT
            dAmtApplied += recDocForSeasPmt."Amount to Apply";
          UNTIL recDocForSeasPmt.NEXT = 0;
        END;
        IF dAmtApplied > dOrder_invAmt THEN //recSH.Amount THEN
          ERROR('Amount cannot be greater than the order amount %1', dOrder_invAmt); //recSH.Amount);
        
        dAmtApplied += DocForSeasPmt."Amount to Apply";
        
        IF dAmtApplied > -dPmtAmtRemaining THEN
          ERROR('Amount to Apply cannot be greater than the Payment Amount %1', -dPmtAmtRemaining);
        
        dAmtApplied := 0;
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Payment External Doc No.", DocForSeasPmt."Payment External Doc No.");
        recDocForSeasPmt.SETRANGE("Document No.", DocForSeasPmt."Document No.");
        recDocForSeasPmt.SETFILTER("Payment Document No.", '<>%1', DocForSeasPmt."Payment Document No.");
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          REPEAT
            dAmtApplied += recDocForSeasPmt."Amount to Apply";
          UNTIL recDocForSeasPmt.NEXT = 0;
        END;
        dAmtApplied += DocForSeasPmt."Amount to Apply";
        
        IF dAmtApplied > dOrder_invAmt THEN //recSH.Amount THEN
          ERROR('Total amount applied for this %1 cannot be greater than %2', DocForSeasPmt."Document Type", dOrder_invAmt); //recSH.Amount);
        */

    end;

    [Scope('Internal')]
    procedure CalculateQtyToBuy(Amount: Decimal; ItemNo: Code[20]; UOM: Code[10]; CustNo: Code[20]; VariantCode: Code[20]; var retMinQtyToBuy: Decimal)
    var
        recItem: Record Item;
        recSalesPrice: Record "Sales Price";
        recCust: Record Customer;
        cuSalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        bDoneLoop: Boolean;
        dMinQtyToBuy: Decimal;
        dMinAmt: Decimal;
    begin
        retMinQtyToBuy := 0;

        recCust.Get(CustNo);
        recSalesPrice.Reset();
        recSalesPrice.SetRange("Item No.", ItemNo);
        recSalesPrice.SetRange("Unit of Measure Code", UOM);
        if VariantCode <> '' then begin
            recSalesPrice.SetRange("Variant Code", VariantCode);
        end;
        recSalesPrice.SetRange("Starting Date", 0D, WorkDate);
        recSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, WorkDate);
        if recCust."Customer Price Group" <> '' then begin
            recSalesPrice.SetRange("Sales Type", recSalesPrice."Sales Type"::"Customer Price Group");
            recSalesPrice.SetRange("Sales Code", recCust."Customer Price Group");
            if recSalesPrice.FindSet() then begin
                repeat
                    dMinAmt := recSalesPrice."Minimum Quantity" * recSalesPrice."Unit Price";
                    //retMinQtyToBuy := recSalesPrice."Minimum Quantity";
                    if dMinAmt <= Amount then begin
                        retMinQtyToBuy := recSalesPrice."Minimum Quantity";
                    end else begin
                        bDoneLoop := true;
                    end;
                until recSalesPrice.Next = 0;
            end;
        end;// ELSE BEGIN
        //recSalesPrice.SETFILTER("Sales Type", '%1|%2', recSalesPrice."Sales Type"::"All Customers", recSalesPrice."Sales Type"::Customer);
        //recSalesPrice.SETFILTER("Sales Code", '%1|%2', '', CustNo);
        recSalesPrice.SetRange("Sales Type", recSalesPrice."Sales Type"::Customer);
        recSalesPrice.SetRange("Sales Code", recCust."No.");
        if recSalesPrice.FindSet() then begin
            bDoneLoop := false;
            repeat
                dMinAmt := recSalesPrice."Minimum Quantity" * recSalesPrice."Unit Price";
                if dMinAmt <= Amount then begin
                    dMinQtyToBuy := recSalesPrice."Minimum Quantity";
                    if dMinQtyToBuy > retMinQtyToBuy then begin
                        retMinQtyToBuy := dMinQtyToBuy;
                    end;
                end else begin
                    bDoneLoop := true;
                end;
            until recSalesPrice.Next = 0;
        end;

        recItem.Get(ItemNo);
        if recItem."Unit Price" <> 0 then begin
            dMinQtyToBuy := Round(Amount / recItem."Unit Price", 0.01);
            if dMinQtyToBuy > retMinQtyToBuy then begin
                retMinQtyToBuy := dMinQtyToBuy;
            end;
        end;

        retMinQtyToBuy := Round(retMinQtyToBuy, 1.0);
    end;

    [Scope('Internal')]
    procedure GetDiscountPc(SeasDiscCode: Code[20]; GracePeriodDays: Integer; ActualPaymentDate: Date; var retDiscoutnPc: Decimal)
    var
        recSeasCashDisc: Record "Seasonal Cash Discount";
        iEffectivePmtMonth: Integer;
    begin
        retDiscoutnPc := 0;

        iEffectivePmtMonth := Date2DMY(ActualPaymentDate, 2);
        if Date2DMY(ActualPaymentDate, 1) <= GracePeriodDays then begin
            if iEffectivePmtMonth = 1 then begin
                iEffectivePmtMonth := 12;
            end else begin
                iEffectivePmtMonth -= 1;
            end;
        end;

        if (SeasDiscCode <> '') then begin
            recSeasCashDisc.Reset(); //get("Code","Payment Month","Starting Date");
            recSeasCashDisc.SetRange(Code, SeasDiscCode);
            recSeasCashDisc.SetRange("Payment Month", iEffectivePmtMonth);
            recSeasCashDisc.SetFilter("Starting Date", '%1|<=%2', 0D, WorkDate);
            if recSeasCashDisc.FindFirst() then begin
                retDiscoutnPc := recSeasCashDisc."Discount %";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetSLSeasCashDiscQty(var SalesLn: Record "Sales Line")
    var
        recSCDInquiryTemp: Record "Research Plot Data" temporary;
        recCLE: Record "Cust. Ledger Entry";
        iEntryNo: Integer;
        recSH: Record "Sales Header";
        dAmtLinkedToDocs: Decimal;
    begin
        /*SalesLn.TESTFIELD(Type, SalesLn.Type::Item);
        recSCDInquiryTemp.RESET();
        recSCDInquiryTemp.DELETEALL();
        
        recSH.GET(SalesLn."Document Type", SalesLn."Document No.");
        
        recCLE.RESET();
        recCLE.SETRANGE("Document Type", recCLE."Document Type"::Payment);
        recCLE.SETFILTER("Remaining Amount", '<>0');
        recCLE.SETRANGE(Open, TRUE);
        IF recCLE.FINDSET() THEN BEGIN
          recCLE.CALCFIELDS("Remaining Amount");
          iEntryNo := 0;
          REPEAT
            IF recCLE."Remaining Amount" <> 0 THEN BEGIN
              iEntryNo +=1;
              recSCDInquiryTemp.INIT();
              recSCDInquiryTemp."Entry No."           := iEntryNo;
              //recSCDInquiryTemp."Payment Doc Type"  := recSCDInquiryTemp."Payment Doc Type"::
              recSCDInquiryTemp."Payment Doc No."     := recCLE."Document No.";
              recSCDInquiryTemp."Payment Ext Doc No." := recCLE."External Document No.";
              recSCDInquiryTemp."Payment Ledger Entry No." := recCLE."Entry No.";
              recSCDInquiryTemp.VALIDATE(Key, recSH."Sell-to Customer No.");
              recSCDInquiryTemp.VALIDATE("Item No.", SalesLn."No.");
              recSCDInquiryTemp.VALIDATE("Variant Code", SalesLn."Variant Code");
              recSCDInquiryTemp.VALIDATE("Unit of Measure Code", SalesLn."Unit of Measure Code");
              recSCDInquiryTemp.VALIDATE("Payment Date", recCLE."Posting Date");
              recSCDInquiryTemp.VALIDATE("Grace Period Days", recSH."Grace Period Days");
              recSCDInquiryTemp.VALIDATE("Seasonal Cash Discount Code", recSH."Seasonal Cash Disc Code");
              dAmtLinkedToDocs := GetPmtAmtLinkedToDocs(recCLE);
              dAmtLinkedToDocs -= (-recCLE."Remaining Amount");
              recSCDInquiryTemp.VALIDATE("Payment Outstanding Amount", -recCLE."Remaining Amount");
              recSCDInquiryTemp.INSERT();
            END;
          UNTIL recCLE.NEXT =0;
          recSCDInquiryTemp.RESET();
          PAGE.RUNMODAL(0, recSCDInquiryTemp);
        END;
        
        recSCDInquiryTemp.RESET();
        recSCDInquiryTemp.DELETEALL();
        */

    end;

    [Scope('Internal')]
    procedure CheckItemSeasDisc(var SalesLn: Record "Sales Line")
    var
        recSH: Record "Sales Header";
        recItem: Record Item;
        recProduct: Record Product;
        recSeason: Record "Season Code";
        recSL: Record "Sales Line";
    begin
        //Called from Sales Line "No." field OnValidate()
        //purpose: to see if an item can be added to an order:
        if SalesLn.Type = SalesLn.Type::Item then begin
            recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
            recItem.Get(SalesLn."No.");
            if recItem."Product Code" <> '' then begin
                recProduct.Get(recItem."Product Code");
                if recProduct."Seasonal Cash Disc Code" <> '' then begin
                    //if the item has an SCSD that is diff from the header's, if the cust is set up with a SCDC that is set up for all, then allow.
                    if recProduct."Seasonal Cash Disc Code" <> recSH."Seasonal Cash Disc Code" then begin
                        if recSeason.Get(recSH."Seasonal Cash Disc Code") then begin
                            if not recSeason."Applies to All Codes" then begin
                                Error('Sales order %1 is setup with Seasonal Cash Discount Code %2, but the item has Product Code set up with %3', recSH."No.", recSH."Seasonal Cash Disc Code", recProduct."Seasonal Cash Disc Code");
                            end;
                        end;
                    end;

                    //if the item has an SCSD that is diff from another line's then error out
                    recSL.Reset();
                    recSL.SetRange("Document Type", SalesLn."Document Type");
                    recSL.SetRange("Document No.", SalesLn."Document No.");
                    recSL.SetFilter("Line No.", '<>%1', SalesLn."Line No.");
                    recSL.SetRange(Type, SalesLn.Type);
                    recSL.SetFilter("Seasonal Cash Disc Code", '<>%1', recProduct."Seasonal Cash Disc Code");
                    if recSL.FindFirst() then begin
                        Error('Sales Line has a different Seasonal Cash Discount Code %1 from that of another item on this order has, %2', recProduct."Seasonal Cash Disc Code", recSL."No.");
                    end;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetPmtAmtLinkedToDocs(CLE: Record "Cust. Ledger Entry") retAmtLinked: Decimal
    begin
        retAmtLinked := 0;
    end;

    [Scope('Internal')]
    procedure DeleteSeasDiscLinks(GenJnlLn: Record "Gen. Journal Line")
    var
        recDocForSeasPmt: Record "Research Plots";
    begin
        /*//Called from table 81 (Gen. Journal Line) OnDelete()
        IF GenJnlLn."Document Type" = GenJnlLn."Document Type"::Payment THEN BEGIN
          IF GenJnlLn."Account Type" = GenJnlLn."Account Type"::Customer THEN BEGIN
            recDocForSeasPmt.RESET();
            recDocForSeasPmt.SETRANGE("Payment Document No.", GenJnlLn."Document No.");
            recDocForSeasPmt.SETRANGE(Type, GenJnlLn."Account No.");
            recDocForSeasPmt.SETRANGE("Payment External Doc No.", GenJnlLn."External Document No.");
            IF recDocForSeasPmt.FINDSET() THEN BEGIN
              recDocForSeasPmt.DELETEALL();
            END;
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure PostDepositSeasDisc(GenJnlLine: Record "Gen. Journal Line"; CLENo: Integer)
    var
        recDocForSeasPmt: Record "Research Plots";
    begin
        /*//Called from codeunit 12: Gen. Jnl.-Post Line
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Payment Type", recDocForSeasPmt."Payment Type"::"0");
        recDocForSeasPmt.SETRANGE("Payment External Doc No.", GenJnlLine."External Document No.");
        recDocForSeasPmt.SETRANGE("Payment Document No.", GenJnlLine."Document No.");
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          recDocForSeasPmt.MODIFYALL("Payment Posted", TRUE);
          recDocForSeasPmt.MODIFYALL("Cust. Ledger Entry No. of Pmt.", CLENo);
        END;
        
        
        recGenJnlLine.RESET;
        recGenJnlLine.SETRANGE("Journal Template Name",JnlTemplateName);
        recGenJnlLine.SETRANGE("Journal Batch Name", JnlBatchName);
        recGenJnlLine.SETRANGE("Document Type", recGenJnlLine."Document Type"::Payment);
        recGenJnlLine.SETRANGE("Account Type", recGenJnlLine."Account Type"::Customer);
        recGenJnlLine.SETRANGE("External Document No.", DepositNo);
        IF recGenJnlLine.FINDSET() THEN BEGIN
          recDocForSeasPmt.RESET();
          recDocForSeasPmt.SETRANGE("Payment Document Type", recDocForSeasPmt."Payment Document Type"::Deposit);
          recDocForSeasPmt.SETRANGE("Payment External Doc No.", DepositNo);
        
          REPEAT
            recDocForSeasPmt.SETRANGE("Payment Document No.", recGenJnlLine."Document No.");
            IF recDocForSeasPmt.FINDSET() THEN BEGIN
              recDocForSeasPmt.MODIFYALL("Payment Posted", TRUE);
              recDocForSeasPmt.MODIFYALL("Cust. Ledger Entry of Payment", CLENo);
            END;
          UNTIL recGenJnlLine.NEXT =0;
        END;
        */

    end;

    [Scope('Internal')]
    procedure OpenLinkScreenForPmt(GenJnlLn: Record "Gen. Journal Line"; CLE: Record "Cust. Ledger Entry"; PostedDoc: Boolean)
    var
        recCLE: Record "Cust. Ledger Entry";
        recDocForSeasPmtTMP: Record "Research Plots" temporary;
        recDocForSeasPmt: Record "Research Plots";
        recDocForSeasPmt2: Record "Research Plots";
        recSH: Record "Sales Header";
        dAmtLinked: Decimal;
        dPmtAmtRemaining: Decimal;
        iDocType: Integer;
        dOrdAmtRem: Decimal;
        cDocNo: Code[20];
        cExtDocNo: Code[20];
        cCustNo: Code[20];
        dDocRemAmt: Decimal;
        tDocPostingDate: Date;
        iPmtCLENo: Integer;
        iJnlLnNo: Integer;
    begin
        /*IF PostedDoc THEN BEGIN
          CLE.TESTFIELD("Document Type", CLE."Document Type"::Payment);
          CLE.CALCFIELDS("Remaining Amount");
          cDocNo      := CLE."Document No.";
          cExtDocNo   := CLE."External Document No.";
          cCustNo     := CLE."Customer No.";
          CLE.CALCFIELDS("Remaining Amount");
          dDocRemAmt  := CLE."Remaining Amount";
          tDocPostingDate := CLE."Posting Date";
          iPmtCLENo   := CLE."Entry No.";
          iJnlLnNo    := 0;
        END ELSE BEGIN
          GenJnlLn.TESTFIELD("Document Type", GenJnlLn."Document Type"::Payment);
          GenJnlLn.TESTFIELD("Account Type", GenJnlLn."Account Type"::Customer);
          GenJnlLn.TESTFIELD("Account No.");
          GenJnlLn.TESTFIELD("Credit Amount");
          cDocNo      := GenJnlLn."Document No.";
          cExtDocNo   := GenJnlLn."External Document No.";
          cCustNo     := GenJnlLn."Account No.";
          dDocRemAmt  := GenJnlLn.Amount;
          tDocPostingDate := GenJnlLn."Posting Date";
          iJnlLnNo    := GenJnlLn."Line No.";
        END;
        
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Payment Type", recDocForSeasPmt."Payment Type"::"0");
        recDocForSeasPmt.SETRANGE("Payment Document No.", cDocNo);
        recDocForSeasPmt.SETRANGE("Payment External Doc No.",cExtDocNo);
        recDocForSeasPmt.SETRANGE("Cust. Ledger Entry No. of Pmt.", iPmtCLENo);
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          REPEAT
             recDocForSeasPmtTMP.INIT();
             recDocForSeasPmtTMP.TRANSFERFIELDS(recDocForSeasPmt);
             GetPmtAmtRemaining(1, cDocNo, cExtDocNo, recDocForSeasPmt."Journal Line No.",cCustNo, dDocRemAmt, dPmtAmtRemaining);
             recDocForSeasPmtTMP."Remaining Payment Amount" := dPmtAmtRemaining;
             recDocForSeasPmtTMP."Remaining Original Payment Amt" := dPmtAmtRemaining;
             recDocForSeasPmtTMP."Remaining Original Inv/Ord Amt" :=  GetInvOrderAmtRemaining(recDocForSeasPmtTMP."Document Type", recDocForSeasPmtTMP."Document No.",
                        recDocForSeasPmtTMP.Description, dAmtLinked);
             recDocForSeasPmtTMP."Remaining Invoice/Order Amount" := recDocForSeasPmtTMP."Remaining Original Inv/Ord Amt";
             recDocForSeasPmtTMP."Amount to Link" := recDocForSeasPmt."Amount Linked";
             recDocForSeasPmtTMP."Amount Linked"  := dAmtLinked;
             recDocForSeasPmtTMP.INSERT();
          UNTIL recDocForSeasPmt.NEXT = 0;
        END;
        
        //Check posted sales invoices (CLE)
        recCLE.RESET();
        recCLE.SETRANGE("Customer No.", cCustNo);
        recCLE.SETRANGE("Document Type", recCLE."Document Type"::Invoice);
        recCLE.SETRANGE(Open, TRUE);
        IF recCLE.FINDSET() THEN BEGIN
          REPEAT
              //if total amount linked for any payments is less than remaining amount, then show
              dOrdAmtRem := GetInvOrderAmtRemaining(3, recCLE."Document No.", recCLE."Entry No.", dAmtLinked);
              IF dOrdAmtRem >0 THEN BEGIN
                IF NOT recDocForSeasPmt.GET(recDocForSeasPmt."Payment Type"::"0", cExtDocNo,  iJnlLnNo, recDocForSeasPmt."Document Type"::"3", recCLE."Document No.") THEN BEGIN
                  recDocForSeasPmtTMP.INIT();
                  recDocForSeasPmtTMP."Journal Line No." := iJnlLnNo;
                  CopyDocForSeasDisc(recDocForSeasPmtTMP, cDocNo, cExtDocNo, iJnlLnNo, cCustNo, dDocRemAmt, tDocPostingDate);
                  recDocForSeasPmtTMP."Document Type"    := recDocForSeasPmtTMP."Document Type"::"3";
                  recDocForSeasPmtTMP.VALIDATE("Document No.", recCLE."Document No.");
                  recDocForSeasPmtTMP."Remaining Invoice/Order Amount" := dOrdAmtRem;
                  recDocForSeasPmtTMP."Remaining Original Inv/Ord Amt" := dOrdAmtRem;
                  recDocForSeasPmtTMP.Description := recCLE."Entry No.";
                  recDocForSeasPmtTMP."Amount Linked"    := dAmtLinked;
                  IF iPmtCLENo > 0 THEN BEGIN
                    recDocForSeasPmtTMP."Cust. Ledger Entry No. of Pmt." := iPmtCLENo;
                    recDocForSeasPmtTMP."Payment Posted" := TRUE;
                  END;
                  //recDocForSeasPmtTMP.CalcCashDiscPc();
                  recDocForSeasPmtTMP.INSERT();
                END;
              END;
          UNTIL recCLE.NEXT = 0;
          recDocForSeasPmt.SETRANGE(Description);
        END;
        
        //Check sales orders or sales invoices (unposted)
        recSH.RESET();
        recSH.SETFILTER("Document Type", '%1|%2', recSH."Document Type"::Order, recSH."Document Type"::Invoice);
        recSH.SETRANGE("Sell-to Customer No.", cCustNo);
        recSH.SETFILTER("Outstanding Amount ($)", '>0');
        IF recSH.FINDSET() THEN BEGIN
          REPEAT
            dOrdAmtRem := GetInvOrderAmtRemaining(recSH."Document Type", recSH."No.", 0, dAmtLinked);
            IF recSH."Document Type" = recSH."Document Type"::Order THEN BEGIN
              iDocType := recDocForSeasPmtTMP."Document Type"::"1";
            END ELSE BEGIN
              IF recSH."Document Type" = recSH."Document Type"::Invoice THEN BEGIN
                iDocType := recDocForSeasPmtTMP."Document Type"::"2";
              END;
            END;
        
            recDocForSeasPmtTMP.INIT();
            recDocForSeasPmtTMP."Journal Line No." := iJnlLnNo;
            CopyDocForSeasDisc(recDocForSeasPmtTMP, cDocNo, cExtDocNo, iJnlLnNo, cCustNo, dDocRemAmt, tDocPostingDate);
            recDocForSeasPmtTMP."Document Type"    := iDocType;
            recDocForSeasPmtTMP.VALIDATE("Document No.", recSH."No.");
            recDocForSeasPmtTMP."Remaining Invoice/Order Amount" := dOrdAmtRem;
            recDocForSeasPmtTMP."Remaining Original Inv/Ord Amt" := dOrdAmtRem;
            recDocForSeasPmtTMP."Amount Linked"    := dAmtLinked;
            IF iPmtCLENo > 0 THEN BEGIN
              recDocForSeasPmtTMP."Cust. Ledger Entry No. of Pmt." := iPmtCLENo;
              recDocForSeasPmtTMP."Payment Posted" := TRUE;
            END;
            //recDocForSeasPmtTMP.CalcCashDiscPc();
            IF recDocForSeasPmtTMP.INSERT() THEN;
          UNTIL recSH.NEXT = 0;
        END;
        
        recDocForSeasPmtTMP.RESET();
        IF recDocForSeasPmtTMP.FINDSET() THEN BEGIN
          IF PAGE.RUNMODAL(50052, recDocForSeasPmtTMP) = ACTION::LookupOK THEN BEGIN
            recDocForSeasPmt.RESET();
            recDocForSeasPmt.SETRANGE("Payment Type", recDocForSeasPmt."Payment Type"::"0");
            recDocForSeasPmt.SETRANGE("Payment Document No.", cDocNo);
            recDocForSeasPmt.SETRANGE("Payment External Doc No.", cExtDocNo);
            recDocForSeasPmt.SETRANGE(Type, cCustNo);
            IF recDocForSeasPmt.FINDSET() THEN
              recDocForSeasPmt.DELETEALL();
        
            recDocForSeasPmtTMP.SETFILTER("Amount to Link", '>0');
            IF recDocForSeasPmtTMP.FINDSET() THEN BEGIN
              //MESSAGE('No.of records is %1', recDocForSeasPmtTMP.COUNT());
              REPEAT
                recDocForSeasPmt.INIT();
                recDocForSeasPmt:= recDocForSeasPmtTMP;
                recDocForSeasPmt."Amount Linked" := recDocForSeasPmtTMP."Amount to Link";
                recDocForSeasPmt."Amount to Link" := 0;
                recDocForSeasPmt."Link No. for Pmt" := recDocForSeasPmtTMP."Link No. for Pmt";
                recDocForSeasPmt.INSERT();
              UNTIL recDocForSeasPmtTMP.NEXT =0;
            END;
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure CopyDocForSeasDisc(var ToDocForSeasPmt: Record "Research Plots"; DocNo: Code[20]; ExtDocNo: Code[20]; JnlLnNo: Integer; CustNo: Code[20]; Amt: Decimal; PostingDate: Date)
    var
        dPmtAmtRemaining: Decimal;
    begin
        /*ToDocForSeasPmt."Payment Type"     := ToDocForSeasPmt."Payment Type"::"0";
        ToDocForSeasPmt."Payment Document No."      := DocNo;
        ToDocForSeasPmt."Payment External Doc No."  := ExtDocNo;
        ToDocForSeasPmt.Type              := CustNo;
        ToDocForSeasPmt."Payment Amount"            := Amt;
        ToDocForSeasPmt.VALIDATE("Payment Date", PostingDate);
        GetPmtAmtRemaining(1, DocNo, ExtDocNo, JnlLnNo, CustNo, Amt, dPmtAmtRemaining);
        //ToDocForSeasPmt."Remaining Payment Amount" := dPmtAmtRemaining;
        ToDocForSeasPmt."Remaining Original Payment Amt" := dPmtAmtRemaining;
        ToDocForSeasPmt."Remaining Payment Amount"  := dPmtAmtRemaining;
        */

    end;

    [Scope('Internal')]
    procedure GetPmtAmtRemaining(PmtDocType: Integer; PmtDocNo: Code[20]; PmtExtDocNo: Code[20]; PmtJnlLnNo: Integer; CustNo: Code[20]; dPmtAmt: Decimal; var retPmtAmtRemaining: Decimal)
    var
        recDocForSeasPmt: Record "Research Plots";
    begin
        /*retPmtAmtRemaining := -dPmtAmt;
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Payment Type", PmtDocType);
        recDocForSeasPmt.SETRANGE("Payment Document No.", PmtDocNo);
        recDocForSeasPmt.SETRANGE("Payment External Doc No.", PmtExtDocNo);
        recDocForSeasPmt.SETRANGE("Journal Line No.", PmtJnlLnNo);
        recDocForSeasPmt.SETRANGE(Type, CustNo);
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          recDocForSeasPmt.CALCSUMS("Amount Linked");
          retPmtAmtRemaining := -dPmtAmt - recDocForSeasPmt."Amount Linked";
        END;
        */

    end;

    [Scope('Internal')]
    procedure GetInvOrderAmtRemaining(DocType: Integer; DocNo: Code[20]; InvCLENo: Integer; var retAmtLinked: Decimal) retInvOrderAmtRemaining: Decimal
    var
        recSH: Record "Sales Header";
        recCLE: Record "Cust. Ledger Entry";
        dOrdInvAmt: Decimal;
        recDocForSeasPmt: Record "Research Plots";
    begin
        /*dOrdInvAmt := 0;
        retAmtLinked := 0;
        
        IF InvCLENo <> 0 THEN BEGIN
          recCLE.GET(InvCLENo);
          recCLE.CALCFIELDS("Remaining Amount");
          dOrdInvAmt := recCLE."Remaining Amount";
        END ELSE BEGIN
          recSH.GET(DocType, DocNo);
          recSH.CALCFIELDS(Amount, "Outstanding Amount ($)");
          dOrdInvAmt := recSH.Amount; //"Outstanding Amount ($)";
        END;
        retInvOrderAmtRemaining :=dOrdInvAmt;
        
        recDocForSeasPmt.RESET();
        recDocForSeasPmt.SETRANGE("Document Type", DocType);
        recDocForSeasPmt.SETRANGE("Document No.", DocNo);
        //recDocForSeasPmt.SETRANGE("OK to Link", TRUE);
        IF recDocForSeasPmt.FINDSET() THEN BEGIN
          recDocForSeasPmt.CALCSUMS("Amount Linked");
          retInvOrderAmtRemaining := dOrdInvAmt - recDocForSeasPmt."Amount Linked"; //recDocForSeasPmt."Amount to Link";
          retAmtLinked := recDocForSeasPmt."Amount Linked";
        END;
        */

    end;

    [Scope('Internal')]
    procedure GetNextSeasDiscEntryNo() retNextSeasDiscEntryNo: Integer
    var
        recRuppSetup: Record "Rupp Setup";
    begin
        //Called from page 232: Apply Customer Entries
        recRuppSetup.Get();
        recRuppSetup."Seasonal Disc. Entry No." += 1;
        retNextSeasDiscEntryNo := recRuppSetup."Seasonal Disc. Entry No.";
        recRuppSetup.Modify();
    end;

    [Scope('Internal')]
    procedure UnapplySeasDiscApplnEntry(DtldCLE: Record "Detailed Cust. Ledg. Entry")
    var
        recSeasDiscApplEntry: Record "Seasonal Discount Appl. Entry";
    begin
        //Called from codeunit 12: Gen. Jnl.-Post Line
        if DtldCLE."Seasonal Disc. Entry No." <> 0 then begin
            recSeasDiscApplEntry.Reset();
            recSeasDiscApplEntry.SetRange("Payment Cust. Ledger Entry", DtldCLE."Cust. Ledger Entry No.");
            recSeasDiscApplEntry.SetRange("Seas Disc. Entry No.", DtldCLE."Seasonal Disc. Entry No.");
            if recSeasDiscApplEntry.FindSet() then begin
                recSeasDiscApplEntry.ModifyAll(Unapplied, true);
                recSeasDiscApplEntry.ModifyAll("Unapplied By", UserId);
                recSeasDiscApplEntry.ModifyAll("Unapplied Date Time", CurrentDateTime);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetAmtToApplyForInv(DiscountPc: Decimal; RemPmtAmt: Decimal; AppliesToID: Code[20]; var InvCLE: Record "Cust. Ledger Entry") retRemainingPmtAmt: Decimal
    var
        dRemInvAmt: Decimal;
        dDiscAmtForInv: Decimal;
        dApplicableAmt: Decimal;
        dBestInvAmt: Decimal;
    begin
        //Called by

        InvCLE.TestField("Document Type", InvCLE."Document Type"::Invoice);
        retRemainingPmtAmt := 0;

        if RemPmtAmt <> 0 then begin
            InvCLE.CalcFields("Remaining Amount");
            dRemInvAmt := InvCLE."Remaining Amount";
            dDiscAmtForInv := Round(dRemInvAmt * DiscountPc / 100, 0.01);
            dApplicableAmt := dRemInvAmt - dDiscAmtForInv;

            if RemPmtAmt < dApplicableAmt then begin
                GetBestInvAmtForPmt(RemPmtAmt, DiscountPc, dRemInvAmt, dBestInvAmt, dDiscAmtForInv);
                dApplicableAmt := dBestInvAmt - dDiscAmtForInv;
            end;
            InvCLE.Validate("Applies-to ID", AppliesToID);
            InvCLE.Validate("Amount to Apply", dApplicableAmt);
            InvCLE.Validate("Remaining Pmt. Disc. Possible", dDiscAmtForInv);
            InvCLE.Validate("Pmt. Discount Date", WorkDate + 1);
            InvCLE.Modify();

            retRemainingPmtAmt := RemPmtAmt - dApplicableAmt - dDiscAmtForInv;

        end;
    end;

    [Scope('Internal')]
    procedure GetBestInvAmtForPmt(RemPmtAmt: Integer; DiscountPC: Integer; RemInvAmt: Decimal; var retBestInvAmt: Decimal; var retDiscAmtForInv: Decimal)
    var
        dApplicableAmt: Decimal;
        dDiscAmtForInv: Decimal;
    begin
        retBestInvAmt := 0;
        retDiscAmtForInv := 0;

        dDiscAmtForInv := Round(RemInvAmt * DiscountPC / 100, 0.00001); //to close the inv
        dApplicableAmt := RemInvAmt + dDiscAmtForInv;
        if RemPmtAmt < dApplicableAmt then begin //recalculate
            if DiscountPC = 100 then begin
                dApplicableAmt := RemPmtAmt;
                dDiscAmtForInv := RemPmtAmt;
            end else begin
                dApplicableAmt := (1 / (1 - DiscountPC / 100)) * RemPmtAmt;
                dDiscAmtForInv := dApplicableAmt - RemPmtAmt;
            end;
        end;
        retBestInvAmt := dApplicableAmt;
        retDiscAmtForInv := dDiscAmtForInv;
    end;

    [Scope('Internal')]
    procedure SuggestAmtToLink(var DocForSeasDisc: Record "Research Plots"; TotalAmtToLinkForPmtAfterDisc: Decimal)
    var
        dAmtToLink: Decimal;
        dCashDiscAmt: Decimal;
    begin
        /*//Called from page 50052
        WITH DocForSeasDisc DO BEGIN
          //REPEAT
            IF DocForSeasDisc."Amount to Link" = 0 THEN BEGIN
              GetBestInvAmtForPmt(DocForSeasDisc."Remaining Payment Amount"-TotalAmtToLinkForPmtAfterDisc, DocForSeasDisc."Cash Discount %",
                    DocForSeasDisc."Remaining Invoice/Order Amount", dAmtToLink, dCashDiscAmt);
              DocForSeasDisc.VALIDATE("Amount to Link", dAmtToLink);
              DocForSeasDisc.VALIDATE("Cash Discount Amount", dCashDiscAmt);
              DocForSeasDisc."Auto-Calculated" := TRUE;
            END;
          //UNTIL DocForSeasDisc.NEXT = 0;
        END;
        */

    end;
}

