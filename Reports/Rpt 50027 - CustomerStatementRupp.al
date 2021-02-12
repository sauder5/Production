report 50027 "Customer Statement -Rupp"
{
    // //Orig: 10072
    // //SOC-SC 07-09-15 Modified
    // //RSI-KS 10-05-16
    //   Add finance charge statement to report
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CustomerStatementRupp.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Customer Statement - Rupp';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Print Statements", "Date Filter";
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem(HeaderFooter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                }
                column(CompanyInfo1_Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2_Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyAddress_1_; CompanyAddress[1])
                {
                }
                column(CompanyAddress_2_; CompanyAddress[2])
                {
                }
                column(CompanyAddress_3_; CompanyAddress[3])
                {
                }
                column(CompanyAddress_4_; CompanyAddress[4])
                {
                }
                column(CompanyAddress_5_; CompanyAddress[5])
                {
                }
                column(ToDate; ToDate)
                {
                }
                column(CompanyAddress_6_; CompanyAddress[6])
                {
                }
                column(Customer__No__; Customer."No.")
                {
                }
                column(CurrReport_PAGENO; CurrReport.PageNo)
                {
                }
                column(CustomerAddress_1_; CustomerAddress[1])
                {
                }
                column(CustomerAddress_2_; CustomerAddress[2])
                {
                }
                column(CustomerAddress_3_; CustomerAddress[3])
                {
                }
                column(CustomerAddress_4_; CustomerAddress[4])
                {
                }
                column(CustomerAddress_5_; CustomerAddress[5])
                {
                }
                column(CustomerAddress_6_; CustomerAddress[6])
                {
                }
                column(CustomerAddress_7_; CustomerAddress[7])
                {
                }
                column(CompanyAddress_7_; CompanyAddress[7])
                {
                }
                column(CompanyAddress_8_; CompanyAddress[8])
                {
                }
                column(CustomerAddress_8_; CustomerAddress[8])
                {
                }
                column(CurrencyDesc; CurrencyDesc)
                {
                }
                column(AgingMethod_Int; AgingMethod_Int)
                {
                }
                column(StatementStyle_Int; StatementStyle_Int)
                {
                }
                column(printfooter3ornot; (AgingMethod <> AgingMethod::None) and StatementComplete)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBalance; -CreditBalance)
                {
                }
                column(BalanceToPrint; BalanceToPrint)
                {
                }
                column(DebitBalance_Control22; DebitBalance)
                {
                }
                column(CreditBalance_Control23; -CreditBalance)
                {
                }
                column(BalanceToPrint_Control24; BalanceToPrint)
                {
                }
                column(AgingDaysText; AgingDaysText)
                {
                }
                column(AgingHead_1_; AgingHead[1])
                {
                }
                column(AgingHead_2_; AgingHead[2])
                {
                }
                column(AgingHead_3_; AgingHead[3])
                {
                }
                column(AgingHead_4_; AgingHead[4])
                {
                }
                column(AmountDue_1_; AmountDue[1])
                {
                }
                column(AmountDue_2_; AmountDue[2])
                {
                }
                column(AmountDue_3_; AmountDue[3])
                {
                }
                column(AmountDue_4_; AmountDue[4])
                {
                }
                column(TempAmountDue_1_; TempAmountDue[1])
                {
                }
                column(TempAmountDue_3_; TempAmountDue[3])
                {
                }
                column(TempAmountDue_2_; TempAmountDue[2])
                {
                }
                column(TempAmountDue_4_; TempAmountDue[4])
                {
                }
                column(HeaderFooter_Number; Number)
                {
                }
                column(STATEMENTCaption; STATEMENTCaptionLbl)
                {
                }
                column(Statement_Date_Caption; Statement_Date_CaptionLbl)
                {
                }
                column(Account_Number_Caption; Account_Number_CaptionLbl)
                {
                }
                column(Page_Caption; Page_CaptionLbl)
                {
                }
                column(RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_Caption; RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl)
                {
                }
                column(Amount_RemittedCaption; Amount_RemittedCaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_No__Caption; TempCustLedgEntry__Document_No__CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Posting_Date_Caption; TempCustLedgEntry__Posting_Date_CaptionLbl)
                {
                }
                column(GetTermsString_TempCustLedgEntry_Caption; GetTermsString_TempCustLedgEntry_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_Type_Caption; TempCustLedgEntry__Document_Type_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount_Caption; TempCustLedgEntry__Remaining_Amount_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount__Control47Caption; TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl)
                {
                }
                column(BalanceToPrint_Control48Caption; BalanceToPrint_Control48CaptionLbl)
                {
                }
                column(Statement_BalanceCaption; Statement_BalanceCaptionLbl)
                {
                }
                column(Statement_BalanceCaption_Control25; Statement_BalanceCaption_Control25Lbl)
                {
                }
                column(Statement_Aging_Caption; Statement_Aging_CaptionLbl)
                {
                }
                column(Aged_amounts_Caption; Aged_amounts_CaptionLbl)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", Open) WHERE(Open = CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        SetRange("Date Filter", 0D, ToDate);
                        CalcFields("Remaining Amount");
                        if "Remaining Amount" <> 0 then
                            InsertTemp("Cust. Ledger Entry");
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (AgingMethod = AgingMethod::None) and (StatementStyle = StatementStyle::Balance) then
                            CurrReport.Break;    // Optimization

                        // Find ledger entries which are open and posted before the statement date.
                        SetRange("Posting Date", 0D, ToDate);
                    end;
                }
                dataitem(AfterStmntDateEntry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        EntryAppMgt.GetAppliedCustEntries(TempAppliedCustLedgEntry, AfterStmntDateEntry, false);
                        TempAppliedCustLedgEntry.SetRange("Posting Date", 0D, ToDate);
                        if TempAppliedCustLedgEntry.Find('-') then
                            repeat
                                InsertTemp(TempAppliedCustLedgEntry);
                            until TempAppliedCustLedgEntry.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (AgingMethod = AgingMethod::None) and (StatementStyle = StatementStyle::Balance) then
                            CurrReport.Break;    // Optimization

                        // Find ledger entries which are posted after the statement date and eliminate
                        // their application to ledger entries posted before the statement date.
                        SetFilter("Posting Date", '%1..', ToDate + 1);
                    end;
                }
                dataitem("Balance Forward"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(FromDate___1; FromDate - 1)
                    {
                    }
                    column(BalanceToPrint_Control39; BalanceToPrint)
                    {
                    }
                    column(Balance_Forward_Number; Number)
                    {
                    }
                    column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                    {
                    }
                    column(Bal_FwdCaption; Bal_FwdCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if StatementStyle <> StatementStyle::Balance then
                            CurrReport.Break;
                    end;

                    trigger OnPreDataItem()
                    begin
                        StatementStyle_Int := StatementStyle;
                    end;
                }
                dataitem(OpenItem; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(TempCustLedgEntry__Document_No__; TempCustLedgEntry."Document No.")
                    {
                    }
                    column(TempCustLedgEntry__Posting_Date_; TempCustLedgEntry."Posting Date")
                    {
                    }
                    column(GetTermsString_TempCustLedgEntry_; GetTermsString(TempCustLedgEntry))
                    {
                    }
                    column(TempCustLedgEntry__Document_Type_; TempCustLedgEntry."Document Type")
                    {
                        OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    }
                    column(TempCustLedgEntry__Remaining_Amount_; TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(TempCustLedgEntry__Remaining_Amount__Control47; -TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(BalanceToPrint_Control48; BalanceToPrint)
                    {
                    }
                    column(OpenItem_Number; Number)
                    {
                    }
                    column(OpenItem_Description; TempCustLedgEntry.Description)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempCustLedgEntry.Find('-')
                        else
                            TempCustLedgEntry.Next;
                        with TempCustLedgEntry do begin
                            CalcFields("Remaining Amount");
                            if "Currency Code" <> Customer."Currency Code" then
                                "Remaining Amount" :=
                                  Round(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      "Posting Date",
                                      "Currency Code",
                                      Customer."Currency Code",
                                      "Remaining Amount"),
                                    Currency."Amount Rounding Precision");

                            if AgingMethod <> AgingMethod::None then begin
                                case AgingMethod of
                                    AgingMethod::"Due Date":
                                        AgingDate := "Due Date";
                                    AgingMethod::"Trans Date":
                                        AgingDate := "Posting Date";
                                    AgingMethod::"Doc Date":
                                        AgingDate := "Document Date";
                                end;
                                i := 0;
                                while AgingDate < PeriodEndingDate[i + 1] do
                                    i := i + 1;
                                if i = 0 then
                                    i := 1;
                                // Force all payments to be in the current aging bucket
                                if "Document Type" = "Document Type"::Payment then
                                    i := 1;
                                AmountDue[i] := "Remaining Amount";
                                TempAmountDue[i] := TempAmountDue[i] + AmountDue[i];
                            end;

                            if StatementStyle = StatementStyle::"Open Item" then begin
                                BalanceToPrint := BalanceToPrint + "Remaining Amount";
                                if "Remaining Amount" >= 0 then
                                    DebitBalance := DebitBalance + "Remaining Amount"
                                else
                                    CreditBalance := CreditBalance + "Remaining Amount";
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (not TempCustLedgEntry.Find('-')) or
                           ((StatementStyle = StatementStyle::Balance) and
                            (AgingMethod = AgingMethod::None))
                        then
                            CurrReport.Break
                            ;
                        SetRange(Number, 1, TempCustLedgEntry.Count);
                        TempCustLedgEntry.SetCurrentKey("Customer No.", "Posting Date");
                        TempCustLedgEntry.SetRange("Date Filter", 0D, ToDate);
                        CurrReport.CreateTotals(AmountDue);
                    end;
                }
                dataitem(CustLedgerEntry4; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");
                    column(CustLedgerEntry4__Document_No__; "Document No.")
                    {
                    }
                    column(CustLedgerEntry4__Posting_Date_; "Posting Date")
                    {
                    }
                    column(GetTermsString_CustLedgerEntry4_; GetTermsString(CustLedgerEntry4))
                    {
                    }
                    column(CustLedgerEntry4__Document_Type_; "Document Type")
                    {
                    }
                    column(CustLedgerEntry4_Amount; Amount)
                    {
                    }
                    column(Amount; -Amount)
                    {
                    }
                    column(BalanceToPrint_Control55; BalanceToPrint)
                    {
                    }
                    column(CustLedgerEntry4_Entry_No_; "Entry No.")
                    {
                    }
                    column(CustLedgerEntry4_Customer_No_; "Customer No.")
                    {
                    }
                    column(CustLedgerEntry4_Description; Description)
                    {
                    }
                    column(SeasonalDiscount; gcDiscount)
                    {
                    }
                    column(BalAfterDiscount; gcCreditAmt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        CalcFields(Amount, "Amount (LCY)");
                        gcDiscount := Amount - "Original Amount";  //RSI-KS
                        if (Customer."Currency Code" = '') and ("Cust. Ledger Entry"."Currency Code" = '') then
                            Amount := "Amount (LCY)"                 //RSI-KS
                        //  Amount := "Original Amt. (LCY)"            //RSI-KS
                        else
                            Amount :=
                              Round(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  "Posting Date",
                                  "Currency Code",
                                  Customer."Currency Code",
                                  Amount),                          //RSI-KS
                                                                    //        "Original Amount"),                 //RSI-KS
                                Currency."Amount Rounding Precision");

                        BalanceToPrint := BalanceToPrint + Amount;
                        gcCreditAmt := BalanceToPrint + gcDiscount;

                        if Amount >= 0 then
                            DebitBalance := DebitBalance + Amount
                        else
                            CreditBalance := CreditBalance + Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if StatementStyle <> StatementStyle::Balance then
                            CurrReport.Break;
                        SetRange("Posting Date", FromDate, ToDate);
                    end;
                }
                dataitem(EndOfCustomer; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(StatementComplete; StatementComplete)
                    {
                    }
                    column(EndOfCustomer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        StatementComplete := true;
                        if UpdateNumbers and (not CurrReport.Preview) then begin
                            Customer.Modify; // just update the Last Statement No
                            Commit;
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    AgingMethod_Int := AgingMethod;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                DebitBalance := 0;
                CreditBalance := 0;
                Clear(AmountDue);
                Clear(TempAmountDue);
                Print := false;
                if AllHavingBalance then begin
                    SetRange("Date Filter", 0D, ToDate);
                    CalcFields("Net Change");
                    Print := "Net Change" <> 0;
                end;
                if (not Print) and AllHavingEntries then begin
                    "Cust. Ledger Entry".Reset;
                    if StatementStyle = StatementStyle::Balance then begin
                        "Cust. Ledger Entry".SetCurrentKey("Customer No.", "Posting Date");
                        "Cust. Ledger Entry".SetRange("Posting Date", FromDate, ToDate);
                    end else begin
                        "Cust. Ledger Entry".SetCurrentKey("Customer No.", Open);
                        "Cust. Ledger Entry".SetRange("Posting Date", 0D, ToDate);
                        "Cust. Ledger Entry".SetRange(Open, true);
                    end;
                    "Cust. Ledger Entry".SetRange("Customer No.", "No.");
                    Print := "Cust. Ledger Entry".Find('-');
                end;
                if not Print then
                    CurrReport.Skip;

                TempCustLedgEntry.DeleteAll;

                AgingDaysText := '';
                if AgingMethod <> AgingMethod::None then begin
                    AgingHead[1] := Text006;
                    PeriodEndingDate[1] := ToDate;
                    if AgingMethod = AgingMethod::"Due Date" then begin
                        PeriodEndingDate[2] := PeriodEndingDate[1];
                        for i := 3 to 4 do
                            PeriodEndingDate[i] := CalcDate(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text007;
                        AgingHead[2] := Text008 + ' '
                          + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    end else begin
                        for i := 2 to 4 do
                            PeriodEndingDate[i] := CalcDate(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text010;
                        AgingHead[2] := Format(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                          + ' - '
                          + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    end;
                    PeriodEndingDate[5] := 0D;
                    AgingHead[3] := Format(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                      + ' - '
                      + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                    AgingHead[4] := Text011 + ' '
                      + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                end;

                if "Currency Code" = '' then begin
                    Clear(Currency);
                    CurrencyDesc := '';
                end else begin
                    Currency.Get("Currency Code");
                    CurrencyDesc := StrSubstNo(Text013, Currency.Description);
                end;

                if StatementStyle = StatementStyle::Balance then begin
                    SetRange("Date Filter", 0D, FromDate - 1);
                    CalcFields("Net Change (LCY)");
                    if "Currency Code" = '' then
                        BalanceToPrint := "Net Change (LCY)"
                    else
                        BalanceToPrint := CurrExchRate.ExchangeAmtFCYToFCY(FromDate - 1, '', "Currency Code", "Net Change (LCY)");
                    SetRange("Date Filter");
                end else
                    BalanceToPrint := 0;

                /* Update Statement Number so it can be printed on the document. However,
                  defer actually updating the customer file until the statement is complete. */
                if "Last Statement No." >= 9999 then
                    "Last Statement No." := 1
                else
                    "Last Statement No." := "Last Statement No." + 1;
                CurrReport.PageNo := 1;

                FormatAddress.Customer(CustomerAddress, Customer);
                StatementComplete := false;

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          7, Format(Customer."Last Statement No."), 0, 0, DATABASE::Customer, "No.", "Salesperson Code",
                          '', Text012 + Format(Customer."Last Statement No."), '');

            end;

            trigger OnPreDataItem()
            begin
                /* remove user-entered date filter; info now in FromDate & ToDate */
                SetRange("Date Filter");

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AllHavingEntries; AllHavingEntries)
                    {
                        Caption = 'Print All with Entries';
                    }
                    field(AllHavingBalance; AllHavingBalance)
                    {
                        Caption = 'Print All with Balance';
                    }
                    field(UpdateNumbers; UpdateNumbers)
                    {
                        Caption = 'Update Statement No.';
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                    }
                    field(StatementStyle; StatementStyle)
                    {
                        Caption = 'Statement Style';
                        OptionCaption = 'Open Item,Balance';
                    }
                    field(AgingMethod; AgingMethod)
                    {
                        Caption = 'Aged By';
                        OptionCaption = 'None,Due Date,Trans Date,Doc Date';
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        Caption = 'Length of Aging Periods';

                        trigger OnValidate()
                        begin
                            if (AgingMethod <> AgingMethod::None) and (Format(PeriodCalculation) = '') then
                                Error(Text014);
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            if (not AllHavingEntries) and (not AllHavingBalance) then
                AllHavingBalance := true;

            LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (not AllHavingEntries) and (not AllHavingBalance) then
            Error(Text000);
        if UpdateNumbers and CurrReport.Preview then
            Error(Text001);
        FromDate := Customer.GetRangeMin("Date Filter");
        ToDate := Customer.GetRangeMax("Date Filter");

        if (StatementStyle = StatementStyle::Balance) and (FromDate = ToDate) then
            Error(Text002 + ' '
              + Text003);

        if (AgingMethod <> AgingMethod::None) and (Format(PeriodCalculation) = '') then
            Error(Text004);

        if Format(PeriodCalculation) <> '' then
            Evaluate(PeriodCalculation, '-' + Format(PeriodCalculation));

        if PrintCompany then begin
            CompanyInformation.Get;
            FormatAddress.Company(CompanyAddress, CompanyInformation);
        end else
            Clear(CompanyAddress);

        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                CompanyInformation.CalcFields(Picture);
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Language: Record Language;
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempAppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        FormatAddress: Codeunit "Format Address";
        EntryAppMgt: Codeunit "Entry Application Management";
        StatementStyle: Option "Open Item",Balance;
        AllHavingEntries: Boolean;
        AllHavingBalance: Boolean;
        UpdateNumbers: Boolean;
        AgingMethod: Option "None","Due Date","Trans Date","Doc Date";
        PrintCompany: Boolean;
        PeriodCalculation: DateFormula;
        Print: Boolean;
        FromDate: Date;
        ToDate: Date;
        AgingDate: Date;
        LogInteraction: Boolean;
        CustomerAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        BalanceToPrint: Decimal;
        DebitBalance: Decimal;
        CreditBalance: Decimal;
        AgingHead: array[4] of Text[20];
        AmountDue: array[4] of Decimal;
        AgingDaysText: Text[20];
        PeriodEndingDate: array[5] of Date;
        StatementComplete: Boolean;
        i: Integer;
        CurrencyDesc: Text[80];
        SegManagement: Codeunit SegManagement;
        Text000: Label 'You must select either All with Entries or All with Balance.';
        Text001: Label 'You must print statements if you want to update statement numbers.';
        Text002: Label 'You must enter a range of dates (not just one date) in the';
        Text003: Label 'Date Filter if you want to print Balance Forward Statements.';
        Text004: Label 'You must enter a Length of Aging Periods if you select aging.';
        Text006: Label 'Current';
        Text007: Label 'Days overdue:';
        Text008: Label 'Up To';
        Text009: Label ' Days';
        Text010: Label 'Days old:';
        Text011: Label 'Over';
        Text012: Label 'Statement ';
        Text013: Label '(All amounts are in %1)';
        TempAmountDue: array[4] of Decimal;
        AgingMethod_Int: Integer;
        StatementStyle_Int: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text014: Label 'You must enter a Length of Aging Periods if you select aging.';
        STATEMENTCaptionLbl: Label 'STATEMENT';
        Statement_Date_CaptionLbl: Label 'Statement Date:';
        Account_Number_CaptionLbl: Label 'Account Number:';
        Page_CaptionLbl: Label 'Page:';
        RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl: Label 'RETURN THIS PORTION OF STATEMENT WITH YOUR PAYMENT.';
        Amount_RemittedCaptionLbl: Label 'Amount Remitted';
        TempCustLedgEntry__Document_No__CaptionLbl: Label 'Document';
        TempCustLedgEntry__Posting_Date_CaptionLbl: Label 'Date';
        GetTermsString_TempCustLedgEntry_CaptionLbl: Label 'Terms';
        TempCustLedgEntry__Document_Type_CaptionLbl: Label 'Code';
        TempCustLedgEntry__Remaining_Amount_CaptionLbl: Label 'Debits';
        TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl: Label 'Credits';
        BalanceToPrint_Control48CaptionLbl: Label 'Balance';
        Statement_BalanceCaptionLbl: Label 'Statement Balance';
        Statement_BalanceCaption_Control25Lbl: Label 'Statement Balance';
        Statement_Aging_CaptionLbl: Label 'Statement Aging:';
        Aged_amounts_CaptionLbl: Label 'Aged amounts:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Bal_FwdCaptionLbl: Label 'Bal Fwd';
        gcCreditAmt: Decimal;
        gcDiscount: Decimal;

    [Scope('Internal')]
    procedure GetTermsString(var CustLedgerEntry: Record "Cust. Ledger Entry"): Text[250]
    var
        InvoiceHeader: Record "Sales Invoice Header";
        PaymentTerms: Record "Payment Terms";
    begin
        with CustLedgerEntry do begin
            if ("Document No." = '') or ("Document Type" <> "Document Type"::Invoice) then
                exit('');

            if InvoiceHeader.ReadPermission then
                if InvoiceHeader.Get("Document No.") then begin
                    if PaymentTerms.Get(InvoiceHeader."Payment Terms Code") then begin
                        if PaymentTerms.Description <> '' then
                            exit(PaymentTerms.Description);

                        exit(InvoiceHeader."Payment Terms Code");
                    end;
                    exit(InvoiceHeader."Payment Terms Code");
                end;
        end;

        if Customer."Payment Terms Code" <> '' then begin
            if PaymentTerms.Get(Customer."Payment Terms Code") then begin
                if PaymentTerms.Description <> '' then
                    exit(PaymentTerms.Description);

                exit(Customer."Payment Terms Code");
            end;
            exit(Customer."Payment Terms Code");
        end;

        exit('');
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        with TempCustLedgEntry do begin
            if Get(CustLedgEntry."Entry No.") then
                exit;
            TempCustLedgEntry := CustLedgEntry;
            Insert;
        end;
    end;
}

