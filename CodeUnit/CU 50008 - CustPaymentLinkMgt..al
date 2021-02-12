codeunit 50008 "Cust. Payment Link Mgt."
{
    // //SOC-SC 10-30-14
    //   As per Natalie and Kent, if anything on an order is invoiced (instead of just shipped), then prevent the user form changing Payment Terms
    // 
    // //SOC-SC 09-04-15
    //   Recalculate Discount Pc
    // 
    // //SOC-SC 09-14-15
    //   Fixed error with Line No. when <Customer Link Payments> is clicked on Customer Card
    // 
    // //SOC-SC 01-11-16
    //   Code to prevent penny differences when applying payment with seas. disc. to salse orders before posting
    // 
    // //SOC-SC 01-13-16
    //   COde to prevent errors with multiple payments to order, and being posted
    // 
    // //SOC-SC 01-29-16
    //   Code to show orders shipped not invoiced
    // 
    // //SOC-SC 03-02-16
    //   Code to correct amount applied when an Inv is posted for an order with links
    // 
    // //SOC-SC 03-18-16
    //   Adding setcurrentkeys to speed up
    // //SOC-SC 03-31-16
    // 
    // //SOC-SC 04-12-16
    //   Code to update the customer's Remaining Discount Amount correctly when inoice is posted right after linking

    Permissions = TableData "Cust. Ledger Entry" = rm;

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure UpdateSHSeasDiscCode(var SalesHdr: Record "Sales Header"; LineNo: Integer)
    var
        recSL: Record "Sales Line";
        cSeasDiscCode: Code[20];
        recSH: Record "Sales Header";
    begin
        //Called from Sales Line, OnDelete()
        //NEED TO REVISIT
        if SalesHdr."Document Type" = SalesHdr."Document Type"::Order then begin
            recSH.Get(SalesHdr."Document Type", SalesHdr."No.");
            cSeasDiscCode := RecalculateSHSeasDiscCode(recSH, LineNo);
            if recSH."Seasonal Cash Disc Code" <> cSeasDiscCode then begin
                recSH."Seasonal Cash Disc Code" := cSeasDiscCode;
                recSH.Modify();
            end;
        end;
    end;

    [Scope('Internal')]
    procedure RecalculateSHSeasDiscCode(SalesHdr: Record "Sales Header"; LineNo: Integer) retSeasDiscCode: Code[20]
    var
        recSL: Record "Sales Line";
    begin
        retSeasDiscCode := '';

        if SalesHdr."Document Type" = SalesHdr."Document Type"::Order then begin
            recSL.FindSet();
            recSL.SetRange("Document Type", SalesHdr."Document Type");
            recSL.SetRange("Document No.", SalesHdr."No.");
            if LineNo <> 0 then
                recSL.SetFilter("Line No.", '<>%1', LineNo);

            recSL.SetRange(Type, recSL.Type::Item);
            recSL.SetFilter("Seasonal Cash Disc Code", '<>%1', '');
            if recSL.FindFirst() then begin
                retSeasDiscCode := recSL."Seasonal Cash Disc Code";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure CheckSalesLnSeasDisc(var SalesLn: Record "Sales Line")
    var
        recSH: Record "Sales Header";
        recItem: Record Item;
        recSeason: Record "Season Code";
    begin
        //Called from Sales Line "No." field OnValidate()
        //purpose: to see if an item can be added to an order:
        if (SalesLn.Type = SalesLn.Type::Item) and (SalesLn."No." <> '') then begin
            recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
            recItem.Get(SalesLn."No.");
            recItem.CalcFields("Seasonal Cash Disc Code");
            if recItem."Seasonal Cash Disc Code" <> '' then begin
                //if the item has an SCSD that is diff from the header's, if the order is set up with a SCDC that is set up for all, then allow.
                if recSH."Seasonal Cash Disc Code" <> '' then begin
                    if recItem."Seasonal Cash Disc Code" <> recSH."Seasonal Cash Disc Code" then begin
                        if recSeason.Get(recSH."Seasonal Cash Disc Code") then begin
                            if not recSeason."Applies to All Codes" then begin
                                if recSeason.Get(recItem."Seasonal Cash Disc Code") then begin
                                    if not recSeason."Applies to All Codes" then begin
                                        Error('Sales %1 %2 is setup with Seasonal Cash Discount Code %3, but the item has Seas. Cash Discount Code of %4',
                                            recSH."Document Type", recSH."No.", recSH."Seasonal Cash Disc Code", recItem."Seasonal Cash Disc Code");
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetDiscountPc(SeasDiscCode: Code[20]; GracePeriodDays: Integer; ActualPaymentDate: Date; PaymentTerms: Code[10]) retDiscountPc: Decimal
    var
        recSeasCashDisc: Record "Seasonal Cash Discount";
        iEffectivePmtMonth: Integer;
        recPmtTerms: Record "Payment Terms";
        iPrevMonth: Integer;
    begin
        retDiscountPc := 0;

        if PaymentTerms <> '' then begin
            recPmtTerms.Get(PaymentTerms);
            if not recPmtTerms."Allow Seasonal Cash Discount" then begin
                exit;
            end;
        end;

        //IF recPmtTerms."Allow Seasonal Cash Discount" THEN BEGIN
        iEffectivePmtMonth := Date2DMY(ActualPaymentDate, 2);

        //SOC-SC 09-04-15
        if iEffectivePmtMonth > 1 then
            iPrevMonth := iEffectivePmtMonth - 1
        else
            iPrevMonth := 12;
        //SOC-SC 09-04-15

        recSeasCashDisc.Reset();
        recSeasCashDisc.SetRange(Code, SeasDiscCode);
        recSeasCashDisc.SetFilter("Starting Date", '%1|<=%2', 0D, WorkDate);

        if GracePeriodDays = 0 then begin
            //recSeasCashDisc.SETRANGE("Payment Month", iEffectivePmtMonth); //SOC-SC 09-04-15 commenting
            recSeasCashDisc.SetRange("Payment Month", iPrevMonth); //SOC-SC 09-04-15 new code
            if recSeasCashDisc.FindFirst() then begin
                GracePeriodDays := recSeasCashDisc."Grace Period Days";
            end;
        end;

        if Date2DMY(ActualPaymentDate, 1) <= GracePeriodDays then begin
            if iEffectivePmtMonth = 1 then begin
                iEffectivePmtMonth := 12;
            end else begin
                iEffectivePmtMonth -= 1;
            end;
        end;

        if (SeasDiscCode <> '') then begin
            recSeasCashDisc.SetRange("Payment Month", iEffectivePmtMonth);
            if recSeasCashDisc.FindFirst() then begin
                retDiscountPc := recSeasCashDisc."Discount %";
            end;
        end;
        //END;
    end;

    [Scope('Internal')]
    procedure RefreshCustPmtLinks(CustNo: Code[20])
    var
        recCustPmtLink: Record "Customer Payment Link";
        recSH: Record "Sales Header";
        iLastLineNo: Integer;
        recCLE: Record "Cust. Ledger Entry";
        recSIH: Record "Sales Invoice Header";
        dOrderRemAmt: Decimal;
        cOrderNo: Code[20];
        bModify: Boolean;
        iFirstlineNo: Integer;
        recPCLE: Record "Cust. Ledger Entry";
        dRemOrderInvAmtToLink: Decimal;
        recCustPmtLink2: Record "Customer Payment Link";
        dOutstandingAmt: Decimal;
        dRemAmtToLink: Decimal;
        cSeasonCode: Code[10];
        cPaymentTermsCode: Code[10];
        iGracePeriodDays: Integer;
        dLastAmtToLink: Decimal;
        recCPL: Record "Customer Payment Link";
    begin
        iLastLineNo := GetLastLineNo(CustNo);

        //For open Payment CLE's, insert CPL's of Request as needed
        //recPCLE.RESET();
        //recPCLE.SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive,"Due Date"); //SOC-SC 03-18-16
        recPCLE.SetCurrentKey("Customer No.", "Document Type", Open); //SOC-SC 03-31-16
        recPCLE.SetRange("Customer No.", CustNo); //SOC-SC 01-14-16
        recPCLE.SetRange("Document Type", recPCLE."Document Type"::Payment);
        recPCLE.SetRange(Open, true);
        if recPCLE.FindSet() then begin
            repeat
                InsertUpdateRequest(recPCLE, recPCLE.FieldNo(recPCLE."Requested Fall Amount"));
                InsertUpdateRequest(recPCLE, recPCLE.FieldNo(recPCLE."Requested Spring Amount"));
            until recPCLE.Next = 0;
        end;

        //Delete any orphan lines with Order No. and no Invoice No., with the Order not existing
        recCustPmtLink.Reset();
        //recCustPmtLink.SETCURRENTKEY("Customer No.","Order No.","Invoice No."); //SOC-SC 03-18-16
        recCustPmtLink.SetCurrentKey("Customer No.", Request, "Invoice No."); //SOC-SC 03-31-16
        recCustPmtLink.SetRange("Customer No.", CustNo);
        recCustPmtLink.SetRange(Request, false);
        recCustPmtLink.SetRange("Invoice No.", '');
        recCustPmtLink.SetRange("Order Exists", false);
        if recCustPmtLink.FindSet() then begin
            recCustPmtLink.DeleteAll();
        end;
        recCustPmtLink.SetRange("Order Exists");

        //Delete any orphan lines with Order No. and Invoice No., with the Invoice CLE not open
        //recCustPmtLink.RESET();
        //recCustPmtLink.setcurrentkey("Customer No.","Order No.","Invoice No."); //SOC-SC 03-18-16
        //recCustPmtLink.SETRANGE(Request, FALSE);
        //recCustPmtLink.SETRANGE("Customer No.", CustNo);
        recCustPmtLink.SetFilter("Invoice No.", '<>%1', '');
        recCustPmtLink.SetRange("Invoice CLE Open", false);
        recCustPmtLink.SetRange(Processed, false);
        if recCustPmtLink.FindSet() then begin
            recCustPmtLink.DeleteAll();
        end;
        recCustPmtLink.SetRange("Invoice No.");
        recCustPmtLink.SetRange("Invoice CLE Open");

        //Delete any duplicate lines with Order No. and/or Invoice No., with 0 Amount to Link and 0 Amount Applied
        //recCustPmtLink.RESET();
        //recCustPmtLink.setcurrentkey("Customer No.","Order No.","Invoice No."); //SOC-SC 03-18-16
        //recCustPmtLink.SETRANGE(Request, FALSE);
        //recCustPmtLink.SETRANGE("Customer No.", CustNo);
        recCustPmtLink.SetRange("Amount to Link", 0);
        //recCustPmtLink.SETRANGE(Processed, FALSE);
        recCustPmtLink.SetRange(Cancelled, false);
        recCustPmtLink.SetRange("Amount Applied", 0);
        if recCustPmtLink.FindSet() then begin
            recCustPmtLink2.Reset();
            recCustPmtLink2.SetCurrentKey("Customer No.", "Order No.", "Invoice No."); //SOC-SC 03-18-16
            repeat
                recCustPmtLink2.CopyFilters(recCustPmtLink);
                recCustPmtLink2.SetRange("Order No.", recCustPmtLink."Order No.");
                recCustPmtLink2.SetRange("Invoice No.", recCustPmtLink."Invoice No.");
                recCustPmtLink2.SetFilter("Line No.", '<%1', recCustPmtLink."Line No.");
                if recCustPmtLink2.FindFirst() then begin
                    recCustPmtLink.Delete();
                end;
            until recCustPmtLink.Next = 0;
        end;

        recSH.Reset();
        recSH.SetCurrentKey("Document Type", "Sell-to Customer No."); //SOC-SC 03-18-16
        recSH.SetRange("Document Type", recSH."Document Type"::Order); //SOC-SC 03-18-16
        recSH.SetRange("Sell-to Customer No.", CustNo);

        //Delete those for orders that are not Shipped Not Invoiced
        recSH.SetRange("Cust. Payment Link Exists", true);
        recSH.SetRange("Shipped Not Invoiced", false);
        if recSH.FindSet() then begin
            repeat
                recCustPmtLink.Reset();
                //recCustPmtLink.SETCURRENTKEY("Customer No.","Order No.","Invoice No."); //SOC-SC 03-18-16
                recCustPmtLink.SetCurrentKey("Customer No.", Request, "Invoice No."); //SOC-SC 03-31-16
                recCustPmtLink.SetRange("Customer No.", recSH."Sell-to Customer No."); //SOC-SC 03-18-16
                recCustPmtLink.SetRange(Request, false);
                recCustPmtLink.SetRange("Invoice No.", '');
                recCustPmtLink.SetRange("Order No.", recSH."No.");
                if recCustPmtLink.FindSet() then begin
                    recCustPmtLink.DeleteAll();
                end;
            until recSH.Next = 0;
        end;

        //Ensure that all sales orders for the customer have correct Outstanding Amout in this table; refresh it every time, because there might be changes on the SO
        recSH.SetRange("Shipped Not Invoiced", true);
        recSH.SetFilter("Amount Including VAT", '>%1', 0);
        if recSH.FindSet(true, true) then begin
            repeat
                RefreshCustPmtLinksForOrder(CustNo, recSH);
            until recSH.Next = 0;
        end;

        //Ensure that all sales orders for the customer are represented in this table, if Shipped Not Invoiced
        recSH.SetRange("Cust. Payment Link Exists", false); //SOC-SC 01-29-16 commenting
        //recSH.SETRANGE("Shipped Not Invoiced");  //TEMPORARY
        if recSH.FindSet(true, true) then begin
            iLastLineNo := GetLastLineNo(CustNo);
            repeat
                /* //SOC-SC 01-29-16 commenting
                recSH.CALCFIELDS("Amount Including VAT", recSH."Outstanding Amount ($)", "Shipped Not Invoiced Amount");
                dOrderRemAmt := recSH."Shipped Not Invoiced Amount";
                IF dOrderRemAmt > 0 THEN BEGIN
                  InsertCustPmtLn(CustNo, iLastLineNo, recSH."No.", '', 0, dOrderRemAmt,
                                  dOrderRemAmt,recSH."Seasonal Cash Disc Code",recSH."Grace Period Days", recSH."Payment Terms Code");
                END;
                */ //SOC-SC 01-29-16 commenting

                //SOC-SC 01-29-16
                recCPL.Reset();
                recCPL.SetCurrentKey("Customer No.", "Order No.", "Invoice No."); //SOC-SC 03-18-16
                recCPL.SetRange("Customer No.", CustNo);
                recCPL.SetRange("Order No.", recSH."No.");
                recCPL.SetRange("Invoice No.", '');
                recCPL.SetRange(Processed, false);
                recCPL.SetRange(Cancelled, false);
                recCPL.SetRange("Amount Applied", 0);
                if not recCPL.FindFirst() then begin
                    recSH.CalcFields("Amount Including VAT", recSH."Outstanding Amount ($)", "Shipped Not Invoiced Amount");
                    dOrderRemAmt := recSH."Shipped Not Invoiced Amount";
                    if dOrderRemAmt > 0 then begin
                        InsertCustPmtLn(CustNo, iLastLineNo, recSH."No.", '', 0, dOrderRemAmt,
                                        dOrderRemAmt, recSH."Seasonal Cash Disc Code", recSH."Grace Period Days", recSH."Payment Terms Code");
                    end;
                end; //SOC-SC 01-29-16
            until recSH.Next = 0;
        end;

        //Ensure that all open CLE's of 'Invoice' and 'Refund' for the customer are represented in this table
        recCLE.Reset();
        //recCLE.SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive,"Due Date"); //SOC-SC 03-18-16
        recCLE.SetCurrentKey("Customer No.", "Document Type", Open); //SOC-SC 03-31-16
        recCLE.SetRange("Customer No.", CustNo);
        recCLE.SetFilter("Document Type", '%1|%2', recCLE."Document Type"::Invoice, recCLE."Document Type"::Refund);
        recCLE.SetRange(Open, true);
        if recCLE.FindSet() then begin
            repeat
                RefreshCustPmtLinksForInv(CustNo, recCLE);
            until recCLE.Next = 0;
        end;
        Commit;

    end;

    local procedure InsertCustPmtLn(CustNo: Code[20]; var retLastLineNo: Integer; OrderNo: Code[20]; InvNo: Code[20]; InvCLENo: Integer; Amt: Decimal; OutstAmt: Decimal; SeasonCode: Code[10]; GracePeriodDays: Integer; PmtTermsCode: Code[10])
    var
        recCustPmtLink: Record "Customer Payment Link";
    begin
        recCustPmtLink.Init();
        recCustPmtLink."Customer No." := CustNo;
        retLastLineNo += 1;
        recCustPmtLink."Line No." := retLastLineNo;
        recCustPmtLink."Invoice No." := InvNo;
        recCustPmtLink."Invoice CLE No." := InvCLENo;
        recCustPmtLink."Order No." := OrderNo;
        recCustPmtLink.Amount := Amt;
        recCustPmtLink."Outstanding Amount" := OutstAmt;
        recCustPmtLink."Season Code" := SeasonCode;
        recCustPmtLink.Validate("Grace Period Days", GracePeriodDays);
        recCustPmtLink."Invoice Payment Terms Code" := PmtTermsCode;
        recCustPmtLink.Insert();
    end;

    local procedure GetLastLineNo(CustNo: Code[20]) retLastLineNo: Integer
    var
        recCustPmtLink: Record "Customer Payment Link";
    begin
        retLastLineNo := 0;
        recCustPmtLink.Reset();
        recCustPmtLink.SetRange("Customer No.", CustNo);
        if recCustPmtLink.FindLast() then begin
            retLastLineNo := recCustPmtLink."Line No.";
        end;
    end;

    [Scope('Internal')]
    procedure RefreshCustPmtLinksForOrder(CustNo: Code[20]; recSH: Record "Sales Header")
    var
        recCustPmtLink: Record "Customer Payment Link";
        iLastLineNo: Integer;
        recCLE: Record "Cust. Ledger Entry";
        recSIH: Record "Sales Invoice Header";
        dOrderRemAmt: Decimal;
        cOrderNo: Code[20];
        bModify: Boolean;
        iFirstlineNo: Integer;
        recPCLE: Record "Cust. Ledger Entry";
        dRemOrderInvAmtToLink: Decimal;
        recCustPmtLink2: Record "Customer Payment Link";
        dOutstandingAmt: Decimal;
        cSeasonCode: Code[10];
        cPaymentTermsCode: Code[10];
        iGracePeriodDays: Integer;
        dLastAmtToLink: Decimal;
    begin
        cOrderNo := recSH."No.";
        cSeasonCode := recSH."Seasonal Cash Disc Code";
        cPaymentTermsCode := recSH."Payment Terms Code";
        iGracePeriodDays := recSH."Grace Period Days";

        bModify := false;
        recSH.CalcFields("Amount Including VAT", recSH."Outstanding Amount ($)", "Shipped Not Invoiced Amount", "Cust. Payment Link Exists");

        recSH.TestField("Shipped Not Invoiced Amount");
        if not recSH."Cust. Payment Link Exists" then begin
            iLastLineNo := GetLastLineNo(CustNo);
            InsertCustPmtLn(CustNo, iLastLineNo, cOrderNo, '', 0, recSH."Shipped Not Invoiced Amount",
                            recSH."Shipped Not Invoiced Amount", cSeasonCode, iGracePeriodDays, cPaymentTermsCode);
        end else begin
            recCustPmtLink.Reset();
            recCustPmtLink.SetCurrentKey("Customer No.", "Order No.", "Invoice No."); //SOC-SC 03-18-16
            recCustPmtLink.SetRange("Customer No.", CustNo); //SOC-SC 03-18-16
            recCustPmtLink.SetRange(Request, false);
            recCustPmtLink.SetRange("Order No.", cOrderNo);
            recCustPmtLink.SetRange("Invoice No.", '');
            if recCustPmtLink.FindSet() then begin//FINDFIRST();

                dOutstandingAmt := recSH."Shipped Not Invoiced Amount";

                repeat
                    if recCustPmtLink.Amount <> recSH."Amount Including VAT" then begin
                        recCustPmtLink.Amount := recSH."Amount Including VAT";
                        bModify := true;
                    end;
                    if recCustPmtLink."Outstanding Amount" <> dOutstandingAmt then begin
                        recCustPmtLink.Validate("Outstanding Amount", dOutstandingAmt);
                        bModify := true;
                    end;
                    dRemOrderInvAmtToLink := dOutstandingAmt - recCustPmtLink."Effective Amount to Link"; //recCustPmtLink."Amount to Link";
                    dOutstandingAmt := dRemOrderInvAmtToLink; //For next rec
                    if recCustPmtLink."Remaining Ord-Inv Amt to Link" <> dRemOrderInvAmtToLink then begin
                        recCustPmtLink."Remaining Ord-Inv Amt to Link" := dRemOrderInvAmtToLink;
                        bModify := true;
                    end;
                    if recPCLE.Get(recCustPmtLink."Payment CLE No.") then begin
                        recPCLE.CalcFields("Remaining Amount");
                        if recCustPmtLink."Pmt. Remaining Amount" <> -recPCLE."Remaining Amount" then begin
                            recCustPmtLink."Pmt. Remaining Amount" := -recPCLE."Remaining Amount";
                            bModify := true;
                        end;
                    end;
                    if recCustPmtLink."Amount to Link" = 0 then begin
                        if recCustPmtLink."Invoice Payment Terms Code" <> cPaymentTermsCode then begin
                            recCustPmtLink."Invoice Payment Terms Code" := cPaymentTermsCode;
                            bModify := true;
                        end;
                        if recCustPmtLink."Season Code" <> cSeasonCode then begin
                            recCustPmtLink."Season Code" := cSeasonCode;
                            bModify := true;
                        end;
                        if recCustPmtLink."Grace Period Days" <> iGracePeriodDays then begin
                            recCustPmtLink."Grace Period Days" := iGracePeriodDays;
                            bModify := true;
                        end;
                    end;

                    if bModify then
                        recCustPmtLink.Modify();

                    iLastLineNo := recCustPmtLink."Line No.";
                    dLastAmtToLink := recCustPmtLink."Amount to Link";
                until (recCustPmtLink.Next = 0) or (dOutstandingAmt = 0);
                if (dOutstandingAmt = 0) then begin
                    recCustPmtLink.SetFilter("Line No.", '>%1', iLastLineNo);
                    if recCustPmtLink.FindSet() then begin
                        recCustPmtLink.DeleteAll();
                    end;
                end else begin
                    if dLastAmtToLink <> 0 then begin
                        iLastLineNo := GetLastLineNo(CustNo);
                        InsertCustPmtLn(CustNo, iLastLineNo, cOrderNo, '', 0, recSH."Shipped Not Invoiced Amount",
                                        recSH."Shipped Not Invoiced Amount", cSeasonCode, iGracePeriodDays, cPaymentTermsCode);
                    end;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure RefreshCustPmtLinksForInv(CustNo: Code[20]; recCLE: Record "Cust. Ledger Entry")
    var
        recCustPmtLink: Record "Customer Payment Link";
        iLastLineNo: Integer;
        recSIH: Record "Sales Invoice Header";
        cOrderNo: Code[20];
        bModify: Boolean;
        iFirstlineNo: Integer;
        recPCLE: Record "Cust. Ledger Entry";
        dRemOrderInvAmtToLink: Decimal;
        recCustPmtLink2: Record "Customer Payment Link";
        dOutstandingAmt: Decimal;
        dRemAmtToLink: Decimal;
        cSeasonCode: Code[10];
        cPaymentTermsCode: Code[10];
        iGracePeriodDays: Integer;
        dLastAmtToLink: Decimal;
    begin
        cOrderNo := '';
        cSeasonCode := '';
        cPaymentTermsCode := '';
        iGracePeriodDays := 0;
        recCLE.CalcFields("Original Amount", "Remaining Amount", recCLE."Cust. Payment Link Exists");
        if recCLE."Document Type" = recCLE."Document Type"::Invoice then begin
            if recSIH.Get(recCLE."Document No.") then begin
                cOrderNo := recSIH."Order No.";
                cSeasonCode := recSIH."Seasonal Cash Disc Code";
                cPaymentTermsCode := recSIH."Payment Terms Code";
                iGracePeriodDays := recSIH."Grace Period Days";
            end;
        end;

        if not recCLE."Cust. Payment Link Exists" then begin
            iLastLineNo := GetLastLineNo(CustNo);
            InsertCustPmtLn(CustNo, iLastLineNo, cOrderNo, recCLE."Document No.", recCLE."Entry No.", recCLE."Original Amount",
                            recCLE."Remaining Amount", cSeasonCode, iGracePeriodDays, cPaymentTermsCode);
        end else begin
            recCustPmtLink.Reset();
            recCustPmtLink.SetCurrentKey("Customer No.", "Order No.", "Invoice No."); //SOC-SC 03-18-16
            recCustPmtLink.SetRange("Customer No.", CustNo); //SOC-SC 03-18-16
            recCustPmtLink.SetRange(Request, false);
            recCustPmtLink.SetRange("Order No.", cOrderNo);
            recCustPmtLink.SetRange("Invoice No.", recCLE."Document No.");
            recCustPmtLink.SetRange(Processed, false);
            recCustPmtLink.SetRange(Cancelled, false);
            recCustPmtLink.FindSet();

            dOutstandingAmt := recCLE."Remaining Amount";
            dRemAmtToLink := recCLE."Remaining Amount";

            repeat
                if recCustPmtLink.Amount <> recCLE."Original Amount" then begin
                    recCustPmtLink.Amount := recCLE."Original Amount";
                    bModify := true;
                end;
                if recCustPmtLink."Outstanding Amount" <> dOutstandingAmt then begin
                    recCustPmtLink.Validate("Outstanding Amount", dOutstandingAmt);
                    bModify := true;
                end;
                dRemAmtToLink := dOutstandingAmt - recCustPmtLink."Effective Amount to Link";
                dOutstandingAmt := dRemAmtToLink; //for next CPL
                if recCustPmtLink."Remaining Ord-Inv Amt to Link" <> dRemAmtToLink then begin
                    recCustPmtLink."Remaining Ord-Inv Amt to Link" := dRemAmtToLink;
                    bModify := true;
                end;

                if recPCLE.Get(recCustPmtLink."Payment CLE No.") then begin
                    recPCLE.CalcFields("Remaining Amount");
                    if recCustPmtLink."Pmt. Remaining Amount" <> -recPCLE."Remaining Amount" then begin
                        recCustPmtLink."Pmt. Remaining Amount" := -recPCLE."Remaining Amount";
                        bModify := true;
                    end;
                end;

                if bModify then
                    recCustPmtLink.Modify();

                iLastLineNo := recCustPmtLink."Line No.";
                dLastAmtToLink := recCustPmtLink."Amount to Link";
            until (recCustPmtLink.Next = 0) or (dOutstandingAmt = 0);
            if (dOutstandingAmt = 0) then begin
                recCustPmtLink.SetFilter("Line No.", '>%1', iLastLineNo);
                if recCustPmtLink.FindSet() then begin
                    recCustPmtLink.DeleteAll();
                end;
            end else begin
                if dLastAmtToLink <> 0 then begin
                    iLastLineNo := GetLastLineNo(CustNo); //SOC-SC 09-14-15 new code
                    InsertCustPmtLn(CustNo, iLastLineNo, cOrderNo, recCLE."Document No.", recCLE."Entry No.", recCLE."Original Amount",
                                    dOutstandingAmt, cSeasonCode, iGracePeriodDays, cPaymentTermsCode);
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure ShowCustPmtLinking(Cust: Record Customer)
    var
        recCustTemp: Record Customer temporary;
    begin
        RefreshCustPmtLinks(Cust."No."); //has commit
        recCustTemp.Reset();
        recCustTemp.DeleteAll();

        recCustTemp.Init();
        recCustTemp.TransferFields(Cust);
        recCustTemp.Insert();

        PAGE.RunModal(50064, recCustTemp);
    end;

    [Scope('Internal')]
    procedure ProcessLinks(CustNo: Code[20])
    var
        recCustPmtLink: Record "Customer Payment Link";
    begin
        if not Confirm('Do you want to process the application?', false) then
            exit;

        recCustPmtLink.Reset();
        recCustPmtLink.SetRange(Request, false);
        recCustPmtLink.SetRange("Customer No.", CustNo);
        recCustPmtLink.SetFilter("Amount to Link", '>0');
        recCustPmtLink.SetFilter("Invoice CLE No.", '>0');
        recCustPmtLink.SetRange(Cancelled, false);
        if recCustPmtLink.FindSet() then begin //TRUE, FALSE) THEN BEGIN
            repeat
                ApplyInvCPLAsLinked(recCustPmtLink);
            until recCustPmtLink.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure SetApplForPmtWithDiscount(CustPmtLink: Record "Customer Payment Link"; var recInvCLE: Record "Cust. Ledger Entry"; var recPmtCLE: Record "Cust. Ledger Entry"; PmtDiscountDate: Date)
    begin
        recInvCLE.Validate("Applies-to ID", UserId);
        recInvCLE.Validate("Amount to Apply", CustPmtLink."Amount to Link"); //CustPmtLink."Effective Amount to Link");
        recInvCLE.Validate("Remaining Pmt. Disc. Possible", 0);
        recInvCLE.Modify();

        recPmtCLE."Applies-to ID" := UserId;
        recPmtCLE."Amount to Apply" := -CustPmtLink."Amount to Link"; //-CustPmtLink."Effective Amount to Link";
        recPmtCLE.Validate("Remaining Pmt. Disc. Possible", 0);
        recPmtCLE.Modify();
    end;

    [Scope('Internal')]
    procedure ApplyAndPost(CustPmtLink: Record "Customer Payment Link")
    var
        recInvCLE: Record "Cust. Ledger Entry";
        recPmtCLE: Record "Cust. Ledger Entry";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        tApplicationDate: Date;
    begin
        recInvCLE.Get(CustPmtLink."Invoice CLE No.");
        recPmtCLE.Get(CustPmtLink."Payment CLE No.");

        //Set Application
        /*
        IF recInvCLE."Posting Date" > recPmtCLE."Posting Date" THEN BEGIN
          tApplicationDate := recInvCLE."Posting Date";
        END ELSE BEGIN
          tApplicationDate := recPmtCLE."Posting Date";
        END;
        */
        tApplicationDate := WorkDate;
        SetApplForPmtWithDiscount(CustPmtLink, recInvCLE, recPmtCLE, tApplicationDate);

        //Post application
        CustEntryApplyPostedEntries.Apply(recPmtCLE, recPmtCLE."Document No.", tApplicationDate); //WORKDATE);

        /*
        //Log into Seasonal Cash Discount Entries table
        recPmtCLE.SETRECFILTER();
        REPORT.RUN(50001, FALSE, FALSE, recPmtCLE);
        */

    end;

    local procedure ProcessSeasonalDiscount(CustPmtLink: Record "Customer Payment Link"; recInvCLE: Record "Cust. Ledger Entry")
    var
        recGJLn: Record "Gen. Journal Line";
        recGenJnlBatch: Record "Gen. Journal Batch";
        cJnlTemplateName: Code[10];
        cBatchName: Code[10];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cDocNo: Code[20];
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RuppSetup: Record "Rupp Setup";
    begin
        CustPmtLink.TestField("Invoice CLE No.");
        if CustPmtLink."Effective Discount Amt to Link" <> 0 then begin
            RuppSetup.Get();
            RuppSetup.TestField("Seas. Disc. Jnl Template Name");
            RuppSetup.TestField("Seas. Disc. Jnl Batch Name");
            cJnlTemplateName := RuppSetup."Seas. Disc. Jnl Template Name";
            cBatchName := RuppSetup."Seas. Disc. Jnl Batch Name";

            with recGJLn do begin
                Init;
                "Journal Template Name" := cJnlTemplateName;
                "Journal Batch Name" := cBatchName;
                "Line No." := 10000;
                "Seasonal Cash Disc Code" := CustPmtLink."Season Code";
                Validate("Posting Date", WorkDate);

                Validate("Shortcut Dimension 1 Code", recInvCLE."Global Dimension 1 Code");
                Validate("Shortcut Dimension 2 Code", recInvCLE."Global Dimension 2 Code");
                Validate("Dimension Set ID", recInvCLE."Dimension Set ID");
                Validate("Account Type", "Account Type"::Customer);
                Validate("Account No.", CustPmtLink."Customer No.");
                Validate("Document Type", recGJLn."Document Type"::"Credit Memo");
                Description := 'Seasonal Discount for Invoice ' + CustPmtLink."Invoice No.";  //RSI-KS

                recGenJnlBatch.Get(cJnlTemplateName, cBatchName);
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.GetNextNo(recGenJnlBatch."No. Series", WorkDate, true);
                Clear(NoSeriesMgt);

                Validate(Amount, -CustPmtLink."Effective Discount Amt to Link");
                Validate("Bal. Account Type", recGenJnlBatch."Bal. Account Type");
                Validate("Bal. Account No.", recGenJnlBatch."Bal. Account No.");
                Validate("Applies-to Doc. Type", "Applies-to Doc. Type"::Invoice);
                Validate("Applies-to Doc. No.", CustPmtLink."Invoice No.");

                if recGenJnlBatch."Posting No. Series" <> '' then
                    Validate("Posting No. Series", recGenJnlBatch."Posting No. Series");

                if recGenJnlBatch."Reason Code" <> '' then
                    Validate("Reason Code", recGenJnlBatch."Reason Code");

                //INSERT();
                GenJnlPostLine.RunWithCheck(recGJLn);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure ApplyInvoiceCLEAtPosting(var InvCLE: Record "Cust. Ledger Entry")
    var
        recCustPmtLink_Order: Record "Customer Payment Link";
        recSIH: Record "Sales Invoice Header";
        dAmtToApply: Decimal;
        dPmtAmtLeftToApply: Decimal;
        dInvAmtLeftToApply: Decimal;
        recCustPmtLink2: Record "Customer Payment Link";
        recCustPmtLinkNew: Record "Customer Payment Link";
        iLastLineNo: Integer;
        recPmtCLE: Record "Cust. Ledger Entry";
    begin
        //Called from sales post codeunit
        InvCLE.CalcFields("Remaining Amount", "Original Amount");
        dInvAmtLeftToApply := InvCLE."Remaining Amount";
        if dInvAmtLeftToApply = 0 then begin
            exit;
        end;

        RefreshCustPmtLinksForInv(InvCLE."Customer No.", InvCLE);

        recCustPmtLink2.Reset();
        recCustPmtLink2.SetRange(Request, false);
        recCustPmtLink2.SetRange("Invoice CLE No.", InvCLE."Entry No.");
        recCustPmtLink2.SetRange(Cancelled, false);
        recCustPmtLink2.SetFilter("Amount to Link", '>%1', 0);
        if recCustPmtLink2.FindSet(true) then begin
            repeat
                if not recCustPmtLink2.Processed then begin

                    ProcessSeasonalDiscount(recCustPmtLink2, InvCLE); //Post any discount as credit **

                    ApplyAndPost(recCustPmtLink2);
                    recCustPmtLink2."Amount Applied" += recCustPmtLink2."Amount to Link";
                    if recCustPmtLink2."Amount Applied" >= recCustPmtLink2."Amount to Link" then begin
                        recCustPmtLink2.Processed := true;
                    end;
                    recCustPmtLink2.Modify();
                    dInvAmtLeftToApply -= recCustPmtLink2."Amount to Link"; //recCustPmtLink2."Effective Amount to Link";
                end;
            until recCustPmtLink2.Next = 0;
        end;
        if dInvAmtLeftToApply <= 0 then
            exit;

        //recCustPmtLink2.SETRANGE("Amount to Link", 0); //SOC-SC 01-13-16 commenting
        recCustPmtLink2.SetRange("Amount to Link"); //SOC-SC 01-13-16
        if recCustPmtLink2.FindSet(true) then begin
            repeat
                if recCustPmtLink2."Amount to Link" = 0 then begin //SOC-SC 01-13-16 new if statement
                    if not recCustPmtLink2.Processed then begin
                        if recSIH.Get(InvCLE."Document No.") then begin
                            if recSIH."Order No." <> '' then begin
                                //link line for order
                                recCustPmtLink_Order.SetCurrentKey("Customer No.", "Order No.", "Invoice No.");
                                recCustPmtLink_Order.SetRange(Request, false);
                                recCustPmtLink_Order.SetRange("Customer No.", InvCLE."Customer No.");
                                recCustPmtLink_Order.SetRange("Order No.", recSIH."Order No.");
                                recCustPmtLink_Order.SetRange(Processed, false);
                                recCustPmtLink_Order.SetRange(Cancelled, false);
                                recCustPmtLink_Order.SetFilter("Amount to Link", '>%1', 0);
                                recCustPmtLink_Order.SetRange("Invoice No.", '');
                                if recCustPmtLink_Order.FindSet() then begin
                                    repeat
                                        recPmtCLE.Get(recCustPmtLink_Order."Payment CLE No.");
                                        recCustPmtLink2."Payment CLE No." := recCustPmtLink_Order."Payment CLE No.";
                                        recCustPmtLink2."Pmt. Remaining Amount" := recCustPmtLink_Order."Pmt. Remaining Amount";
                                        recCustPmtLink2.Validate("Payment Date", recPmtCLE."Posting Date");
                                        recCustPmtLink2."Discount %" := recCustPmtLink_Order."Discount %"; //SOC-SC 03-02-16
                                        dPmtAmtLeftToApply := recCustPmtLink_Order."Amount to Link"; //recCustPmtLink2."Max Possible Amount to Apply";

                                        if dPmtAmtLeftToApply >= dInvAmtLeftToApply then begin
                                            dAmtToApply := dInvAmtLeftToApply;
                                        end else begin
                                            dAmtToApply := dPmtAmtLeftToApply;
                                        end;
                                        UpdateAmountToApply(recCustPmtLink_Order, recCustPmtLink_Order."Amount to Link" - dAmtToApply);
                                        recCustPmtLink_Order."Amount Applied" += dAmtToApply;
                                        recCustPmtLink_Order."Pmt. Remaining Amount" -= dAmtToApply;
                                        recCustPmtLink_Order.Modify();

                                        //link line for invoice
                                        recCustPmtLink2."Pmt. Remaining Amount" := recCustPmtLink_Order."Pmt. Remaining Amount";
                                        UpdateAmountToApply(recCustPmtLink2, dAmtToApply);
                                        recCustPmtLink2.Modify();
                                        dInvAmtLeftToApply -= recCustPmtLink2."Effective Amount to Link"; //dAmtToApply;

                                        ProcessSeasonalDiscount(recCustPmtLink2, InvCLE); //Post any discount as credit **

                                        ApplyAndPost(recCustPmtLink2);
                                        recCustPmtLink2."Amount Applied" += dAmtToApply;
                                        if recCustPmtLink2."Amount Applied" >= recCustPmtLink2."Amount to Link" then begin
                                            recCustPmtLink2.Processed := true;
                                        end;
                                        recCustPmtLink2.Modify();

                                        /*//SOC-SC 01-13-16
                                        IF recCustPmtLink_Order."Amount Applied" >= recCustPmtLink_Order."Amount to Link" THEN BEGIN
                                          recCustPmtLink_Order.Processed := TRUE;
                                          recCustPmtLink_Order.MODIFY()
                                        END;
                                        //SOC-SC 01-13-16
                                        */

                                        //SOC-SC 04-12-16
                                        InsertUpdateRequest(recPmtCLE, recPmtCLE.FieldNo("Requested Fall Amount"));
                                        InsertUpdateRequest(recPmtCLE, recPmtCLE.FieldNo("Requested Spring Amount"));
                                        //SOC-SC 04-12-16

                                        if dInvAmtLeftToApply <= 0 then exit;
                                        //UNTIL (recCustPmtLink_Order.NEXT = 0); //SOC-SC 01-13-16 commenting
                                    until (recCustPmtLink_Order.Next = 0) or (recCustPmtLink2.Processed); //SOC-SC 01-13-16  new code

                                    //SOC-SC 01-13-16  new code
                                    if recCustPmtLink2.Processed then begin
                                        InvCLE.CalcFields("Cust. Payment Link Exists", "Remaining Amount", "Original Amount");
                                        if not InvCLE."Cust. Payment Link Exists" then begin
                                            iLastLineNo := GetLastLineNo(InvCLE."Customer No.");
                                            InsertCustPmtLn(InvCLE."Customer No.", iLastLineNo, recSIH."Order No.", InvCLE."Document No.", InvCLE."Entry No.", InvCLE."Original Amount",
                                                            InvCLE."Remaining Amount", recSIH."Seasonal Cash Disc Code", recSIH."Grace Period Days", recSIH."Payment Terms Code");
                                        end;
                                    end;
                                    //SOC-SC 01-13-16  new code
                                end;
                            end;
                        end;
                    end;
                end; //SOC-SC 01-13-16 end IF
            until (recCustPmtLink2.Next = 0);
        end;

    end;

    [Scope('Internal')]
    procedure ApplyInvCPLAsLinked(var recCustPmtLink: Record "Customer Payment Link")
    var
        recCLE: Record "Cust. Ledger Entry";
    begin
        //Called from page 50066

        if not recCustPmtLink.Processed then begin
            recCLE.Get(recCustPmtLink."Invoice CLE No.");
            ProcessSeasonalDiscount(recCustPmtLink, recCLE); //Post any discount as credit

            ApplyAndPost(recCustPmtLink);

            recCustPmtLink."Amount Applied" += recCustPmtLink."Amount to Link";
            if recCustPmtLink."Amount Applied" >= recCustPmtLink."Amount to Link" then begin
                recCustPmtLink.Processed := true;
            end;
            recCustPmtLink.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateAmountToApply(var CustPmtLink: Record "Customer Payment Link"; AmtToLink: Decimal)
    var
        dAmt: Decimal;
    begin
        with CustPmtLink do begin
            "Amount to Link" := AmtToLink;
            //"Effective Amount to Link" := "Amount to Link" * ROUND((100/(100 + "Discount %")), 0.01);
            //dAmt := "Amount to Link" * ROUND(100/(100 - "Discount %"), 0.00001);
            dAmt := "Amount to Link" * Round(100 / (100 - "Discount %"), 0.0000000001); //SOC-SC 01-11-16
            if dAmt > "Outstanding Amount" then
                dAmt := "Outstanding Amount";
            "Effective Amount to Link" := Round(dAmt, 0.01);

            "Effective Discount Amt to Link" := "Effective Amount to Link" - "Amount to Link";
            "Remaining Ord-Inv Amt to Link" := "Outstanding Amount" - "Effective Amount to Link";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateDepLnSeasCashDisc(var GenJnlLn: Record "Gen. Journal Line")
    var
        dDiscPc: Decimal;
    begin
        //Called from Table 81
        with GenJnlLn do begin
            if Amount = 0 then begin
                "Fall Amount" := 0;
                "Spring Amount" := 0;
            end;
            if ("Fall Amount" = 0) and ("Spring Amount" = 0) then begin
                /*"Fall Discount"   := 0;
                "Spring Discount" := 0;
                */
                "Potential Fall Amount" := 0;
                "Potential Spring Amount" := 0;
            end else begin
                /*
                "Fall Discount"   := (GetDiscountPc('Fall',0, "Posting Date",'') * "Fall Amount"/100);
                "Spring Discount" := (GetDiscountPc('Spring',0,"Posting Date",'') * "Spring Amount"/100);
                */
                dDiscPc := GetDiscountPc('Fall', 0, "Posting Date", '');
                "Potential Fall Amount" := (100 / (100 - dDiscPc) * "Fall Amount");
                dDiscPc := GetDiscountPc('spring', 0, "Posting Date", '');
                "Potential Spring Amount" := (100 / (100 - dDiscPc) * "Spring Amount");
            end;
            /*"Seasonal Discount"  := "Fall Discount" + "Spring Discount";
            "Potential Amount"        := -Amount + "Seasonal Discount";
            "Potential Fall Amount"   := "Fall Amount" + "Fall Discount";
            "Potential Spring Amount" := "Spring Amount" + "Spring Discount";
            */
            "Fall Discount" := "Potential Fall Amount" - "Fall Amount";
            "Spring Discount" := "Potential Spring Amount" - "Spring Amount";
            "Seasonal Discount" := "Fall Discount" + "Spring Discount";
            "Potential Amount" := -Amount + "Seasonal Discount";

        end;

    end;

    [Scope('Internal')]
    procedure InsertUpdateRequest(var PmtCLE: Record "Cust. Ledger Entry"; iCurrFieldNo: Integer)
    var
        recCustPmtLink: Record "Customer Payment Link";
        dPrevReqAmt: Decimal;
        dMaxReqAmt: Decimal;
        dRequestedAmt: Decimal;
        cSeasonCode: Code[20];
        dDiscPc: Decimal;
    begin
        //Called by table Cust. Ledger Entry

        //**** Check ****
        if iCurrFieldNo = 0 then
            exit;

        case iCurrFieldNo of
            PmtCLE.FieldNo("Requested Fall Amount"):
                begin
                    cSeasonCode := 'FALL';
                    dRequestedAmt := PmtCLE."Requested Fall Amount";
                end;
            PmtCLE.FieldNo("Requested Spring Amount"):
                begin
                    cSeasonCode := 'SPRING';
                    dRequestedAmt := PmtCLE."Requested Spring Amount";
                end;
        end;
        PmtCLE.CalcFields("Original Amount", "Remaining Amount");
        dPrevReqAmt := 0;
        //recCustPmtLink.RESET();
        recCustPmtLink.SetCurrentKey("Payment CLE No.", Request, Cancelled, "Season Code"); //SOC-SC 03-18-16
        recCustPmtLink.SetRange("Customer No.", PmtCLE."Customer No.");
        recCustPmtLink.SetRange("Payment CLE No.", PmtCLE."Entry No.");
        recCustPmtLink.SetRange(Request, true);
        recCustPmtLink.SetFilter("Season Code", '<>%1', cSeasonCode);
        if recCustPmtLink.FindSet() then begin
            repeat
                dPrevReqAmt += recCustPmtLink."Requested Amount";
            until recCustPmtLink.Next = 0;
        end;
        dMaxReqAmt := -PmtCLE."Original Amount" - dPrevReqAmt;
        if dRequestedAmt > dMaxReqAmt then
            Error('Requested Amount cannot be more than %1', dMaxReqAmt);

        //**** Insert or modify ****
        recCustPmtLink.SetRange("Season Code", cSeasonCode);
        if recCustPmtLink.FindFirst() then begin
            if dRequestedAmt <= 0 then begin
                recCustPmtLink.Delete();
            end else begin
                if recCustPmtLink."Requested Amount" <> dRequestedAmt then begin

                    //SOC-SC 09-04-15
                    dDiscPc := GetDiscountPc(cSeasonCode, 0, PmtCLE."Posting Date", '');
                    if dDiscPc <> recCustPmtLink."Discount %" then
                        recCustPmtLink."Discount %" := dDiscPc;
                    //SOC-SC 09-04-15

                    recCustPmtLink.Validate("Requested Amount", dRequestedAmt);
                    recCustPmtLink.Modify();
                end;
            end;
        end else begin
            if dRequestedAmt > 0 then begin
                recCustPmtLink.Init();
                recCustPmtLink."Customer No." := PmtCLE."Customer No.";
                recCustPmtLink."Line No." := GetLastLineNo(PmtCLE."Customer No.") + 1;
                recCustPmtLink."Payment CLE No." := PmtCLE."Entry No.";
                recCustPmtLink."Discount %" := GetDiscountPc(cSeasonCode, 0, PmtCLE."Posting Date", ''); //WORKDATE,'');
                recCustPmtLink."Season Code" := cSeasonCode;
                recCustPmtLink.Request := true;
                recCustPmtLink.Validate("Requested Amount", dRequestedAmt);
                recCustPmtLink.Insert();
            end;
        end;
        recCustPmtLink.UpdateSeasonalRemainingAmt(PmtCLE."Entry No.", -PmtCLE."Remaining Amount");
    end;

    [Scope('Internal')]
    procedure ShowCustomerBalance(CustomerNo: Code[20])
    var
        recCust: Record Customer;
    begin
        recCust.FilterGroup(2);
        recCust.Get(CustomerNo);
        recCust.FilterGroup(0);
        PAGE.RunModal(50067, recCust);
    end;

    [Scope('Internal')]
    procedure CheckSeasDiscForGJLn(GJLn: Record "Gen. Journal Line")
    var
        dTotalSeasAmt: Decimal;
    begin
        //Called from table 81
        with GJLn do begin
            if "Account Type" = "Account Type"::Customer then begin
                if "Account No." <> '' then begin
                    if "Credit Amount" > 0 then begin
                        dTotalSeasAmt := "Fall Amount" + "Spring Amount";
                        if (dTotalSeasAmt > 0) then begin
                            if "Credit Amount" < dTotalSeasAmt then begin
                                Error('Credit Amount cannot be less than the total seasonal amount %1', dTotalSeasAmt);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetPotentialAmt(DiscountPc: Decimal; ActualAmt: Decimal; var retDiscountAmt: Decimal) retPotentialAmt: Decimal
    var
        dRatio: Decimal;
        dValue: Decimal;
    begin
        //Called from table 50030
        retPotentialAmt := 0;
        retDiscountAmt := 0;

        if DiscountPc <> 100 then begin
            dRatio := 100 / (100 - DiscountPc);
            dValue := dRatio * ActualAmt;
            retDiscountAmt := Round(dValue - ActualAmt, 0.01);
            /*retDiscountAmt := DiscountPc * ActualAmt/100;
            retPotentialAmt := ActualAmt + retDiscountAmt;
            */ //Commenting
        end;

    end;

    [Scope('Internal')]
    procedure UpdateCustRemSeasDis(CustNo: Code[20])
    var
        recPmtCLE: Record "Cust. Ledger Entry";
        recCust: Record Customer;
    begin
        recCust.Get(CustNo);
        recCust.CalcFields("Remaining Seasonal Discount");
        if recCust."Remaining Seasonal Discount" <> 0 then begin
            recPmtCLE.Reset();
            recPmtCLE.SetRange("Customer No.", CustNo);
            recPmtCLE.SetRange("Document Type", recPmtCLE."Document Type"::Payment);
            if recPmtCLE.FindSet() then begin
                repeat
                    InsertUpdateRequest(recPmtCLE, recPmtCLE.FieldNo("Requested Fall Amount"));
                    InsertUpdateRequest(recPmtCLE, recPmtCLE.FieldNo("Requested Spring Amount"));
                until recPmtCLE.Next = 0;
            end;
            Message('Done!');
        end;
    end;
}

