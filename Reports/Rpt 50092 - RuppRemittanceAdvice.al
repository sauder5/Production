report 50092 "Rupp Remittance Advice"
{
    // Serenic Human Capital Management - (c)Copyright Serenic Software, Inc. 1999-2014.
    // By opening this object you acknowledge that this object includes confidential information
    // and intellectual property of Serenic Software, Inc., and that this work is protected by US
    // and international copyright laws and agreements.
    // ------------------------------------------------------------------------------------------
    // 
    // //SOC-MD 11-25-15
    //   Set RemittanceAdvicesOnly := TRUE; and editable to FALSE  to print only remittances
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/RuppRemittanceAdvice.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Payroll Check';

    dataset
    {
        dataitem(VoidPayrollJnlLine; "Payroll Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Employee No.", "Document Type", "Document No.", "Bank Payment Type");
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if not CurrReport.Preview then
                    CheckManagement.VoidPayrollCheck(VoidPayrollJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Journal Template Name", PayrollJnlLine."Journal Template Name");
                SetRange("Journal Batch Name", PayrollJnlLine."Journal Batch Name");
                if SingleEmployee then
                    SetRange("Employee No.", PayrollJnlLine."Employee No.");
                if TestPrint then
                    CurrReport.Break;

                if not ReprintChecks then
                    CurrReport.Break;
                SavedFilterGroup := FilterGroup(GetFilterGroup());
                SetFilter("Bank Payment Type", '%1|%2',
                          "Bank Payment Type"::"Computer check",
                          "Bank Payment Type"::"Electronic payment");
                FilterGroup(SavedFilterGroup);
                SetRange("Check Printed", true);
                SetRange("Check Exported", false);
            end;
        }
        dataitem(TestPayrollJnlLine; "Payroll Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");

            trigger OnAfterGetRecord()
            begin
                if not PayrollJournalCycleTemp.Get("Pay Cycle Code") then begin
                    CurrReport.Skip
                end
                else begin
                    if ("Pay Cycle Term" <> PayrollJournalCycleTemp."Pay Cycle Term") then begin
                        "Pay Cycle Term" := PayrollJournalCycleTemp."Pay Cycle Term";
                    end;
                    if ("Pay Cycle Period" <> PayrollJournalCycleTemp."Pay Cycle Period") then begin
                        "Pay Cycle Period" := PayrollJournalCycleTemp."Pay Cycle Period";
                    end;
                end;

                if ("Payroll Amount" <> 0) or
                   ("Taxable Amount" <> 0) or
                   ("Payroll Control Type" = "Payroll Control Type"::"Net Pay")
                then begin
                    TestField("Document Type", "Document Type"::Payment);
                    TestField("Employee No.");
                    TestField("Payroll Control Code");
                    if "Job No." <> '' then
                        TestField("Resource No.");
                    if "G/L Post Type" <> "G/L Post Type"::"Do not post to G/L" then
                        TestField("Payroll Posting Group");

                    if PayrollJnlTemplate.Name <> "Journal Template Name" then
                        PayrollJnlTemplate.Get("Journal Template Name");
                    if PayrollJnlTemplate.Recurring then begin
                        TestField("Recurring Method");
                        TestField("Recurring Frequency");
                    end else begin
                        TestField("Recurring Method", 0);
                        TestField("Recurring Frequency", '');
                    end;

                    Employee.Get("Employee No.");
                    PayrollStatus := PayrollValidation.SetEmployeePayrollStatus(Employee);
                    if PayrollStatus = PayrollStatus::Invalid then begin
                        Error(Text015, "Employee No.");
                    end;
                    if not PayrollValidation.EmployeeTypeSynched(Employee."Employee Type") then begin
                        Error(Text018, Employee."No.", Employee.FieldCaption("Employee Type"), Employee."Employee Type");
                    end;

                    if not PayrollJnlTemplate.Recurring then begin
                        if "Payroll Control Type" = "Payroll Control Type"::"Net Pay" then begin
                            PayrollJnlHeader.Get("Journal Template Name", "Journal Batch Name", "Employee No.");
                            if PayrollJnlHeader."Calculated Status" = PayrollJnlHeader."Calculated Status"::Incomplete then
                                Error(Text016, PayrollJnlHeader.FieldCaption("Calculated Status"),
                                               PayrollJnlHeader."Employee No.",
                                               PayrollJnlHeader.TableCaption);
                            if PayrollValidation.EmployeeHasCalcErrors(PayrollJnlHeader) then
                                Error(Text017, PayrollJnlHeader."Employee No.");
                        end;
                    end;
                end;

                PayCheckPrintManagement.CheckIfPrenoteAndInProcess(TestPayrollJnlLine);

                LinesTested := LinesTested + 1;
                Window.Update(1, Round(LinesTested / LinesToTest * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                if not TestPrint then
                    Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                if TestPrint then
                    CurrReport.Break;

                Copy(VoidPayrollJnlLine);
                SavedFilterGroup := FilterGroup(GetFilterGroup());
                SetFilter("Bank Payment Type", '%1|%2',
                          "Bank Payment Type"::"Computer check",
                          "Bank Payment Type"::"Electronic payment");
                FilterGroup(SavedFilterGroup);
                SetRange("Check Printed", false);
                SetRange("Check Exported", false);
                Window.Open(Text002 + '\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@');
                LinesToTest := Count;
                LinesTested := 0;
            end;
        }
        dataitem(NetPayPayrollJnlLine2; "Payroll Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
            dataitem(CheckPages; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CheckToAddr_1; CheckToAddr[1])
                {
                }
                column(CheckDateText; CheckDateText)
                {
                }
                column(CheckNoText; CheckNoText)
                {
                }
                column(PageNo; PageNo)
                {
                }
                column(SectionNo; SectionNo)
                {
                }
                column(StubLinesPrinted; StubLinesPrinted)
                {
                }
                column(OnTopOfPage; OnTopOfPage)
                {
                }
                column(PayCheckBufferLeftSide_PayrollControlName; PayCheckBuffer[LeftSide]."Payroll Control Name")
                {
                }
                column(PayCheckBufferLeftSide_Hours; PayCheckBuffer[LeftSide].Hours)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Rate; Rate)
                {
                    DecimalPlaces = 2 : 5;
                }
                column(PayCheckBufferLeftSide_Amount; PayCheckBuffer[LeftSide].Amount)
                {
                }
                column(PayCheckBufferLeftSide_YTDAmount; PayCheckBuffer[LeftSide]."YTD Amount")
                {
                }
                column(PayCheckBufferLeftSide_Balance; PayCheckBuffer[LeftSide].Balance)
                {
                    DecimalPlaces = 2 : 5;
                }
                column(PayCheckBufferLeftSide_FilingStatusCode; PayCheckBuffer[LeftSide]."Filing Status Code")
                {
                }
                column(PayCheckBufferLeftSide_Allowances; PayCheckBuffer[LeftSide].Allowances)
                {
                }
                column(PayCheckBufferLeftSide_CreditsOtherDeps; PayCheckBuffer[LeftSide]."Credits/Other Deps.")
                {
                }
                column(PayCheckBufferLeftSide_ExtraWithholding; PayCheckBuffer[LeftSide]."Extra Withholding")
                {
                }
                column(PayCheckBufferLeftSide_TotalCreditsClaimed; PayCheckBuffer[LeftSide]."Total Credits Claimed")
                {
                }
                column(PayCheckBufferRightSide_PayrollControlName; PayCheckBuffer[RightSide]."Payroll Control Name")
                {
                }
                column(PayCheckBufferRightSide_Amount; PayCheckBuffer[RightSide].Amount)
                {
                }
                column(PayCheckBufferRightSide_YTDAmount; PayCheckBuffer[RightSide]."YTD Amount")
                {
                }
                column(PayCheckBufferRightSide_Balance; PayCheckBuffer[RightSide].Balance)
                {
                }
                dataitem(PrintPayStub1and2; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(PrintPayStub1and2H1; PrintPayStub1and2H1)
                    {
                    }
                    column(SectionEarnings; SectionEarnings)
                    {
                    }
                    column(SectionGrossToNetPay; SectionGrossToNetPay)
                    {
                    }
                    column(TotalGross; TotalGross)
                    {
                    }
                    column(TotalYTDGross; TotalYTDGross)
                    {
                    }
                    column(TotalYTDNet; TotalYTDNet)
                    {
                    }
                    column(TotalNet; TotalNet)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ItemsProcessed < 2 then begin
                            ItemsProcessed := ItemsProcessed + 1;
                            if ItemsProcessed > 1 then
                                OnTopOfPage := false;
                        end;
                        SectionEarnings := false;
                        SectionGrossToNetPay := false;
                        PrintPayStub1and2H1 := false;
                        if ResetOnTopOfPage then begin
                            OnTopOfPage := false;
                            ResetOnTopOfPage := false;
                        end;

                        if StubLinesPrinted + 6 > StubLinesPerCheck then begin
                            if (PayCheckBufferStatus[LeftSide::Earnings] = PayCheckBufferStatus[LeftSide::Earnings] ::Printing) or
                               (PayCheckBufferStatus[RightSide::"Gross to Net Pay"] = PayCheckBufferStatus[RightSide::"Gross to Net Pay"] ::Printing)
                            then begin
                                LeftSideWasPrinting := false;
                                RightSideWasPrinting := false;
                                if PayCheckBufferStatus[LeftSide::Earnings] = PayCheckBufferStatus[LeftSide::Earnings] ::Printing then begin
                                    LeftSideWasPrinting := true;
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished
                                    else
                                        PayCheckBuffer[LeftSide].Next(-1);
                                end;
                                if PayCheckBufferStatus[RightSide::"Gross to Net Pay"] = PayCheckBufferStatus[RightSide::"Gross to Net Pay"] ::Printing
                                then begin
                                    RightSideWasPrinting := true;
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished
                                    else
                                        PayCheckBuffer[RightSide].Next(-1);
                                end;
                                if (PayCheckBufferStatus[LeftSide::Earnings] = PayCheckBufferStatus[LeftSide::Earnings] ::Finished) and
                                   (PayCheckBufferStatus[RightSide::"Gross to Net Pay"] = PayCheckBufferStatus[RightSide::"Gross to Net Pay"] ::Finished)
                                then begin
                                    Clear(PayCheckBuffer[LeftSide]);
                                    Clear(PayCheckBuffer[RightSide]);
                                    SectionNo := 0;
                                    CurrReport.Break;
                                end else begin
                                    if LeftSideWasPrinting then
                                        PayCheckBufferStatus[LeftSide::Earnings] := PayCheckBufferStatus[LeftSide::Earnings] ::Printing;
                                    if RightSideWasPrinting then
                                        PayCheckBufferStatus[RightSide::"Gross to Net Pay"] := PayCheckBufferStatus[RightSide::"Gross to Net Pay"] ::Printing;
                                    GoToNextPage := true;
                                end;
                            end else
                                GoToNextPage := true;
                        end;

                        if GoToNextPage then begin
                            CurrReport.Break;
                        end;

                        if LeftSide < LeftSide::Earnings then
                            LeftSide := FindNextCategory(WhichColumn::Left);

                        if LeftSide = LeftSide::Earnings then begin
                            case PayCheckBufferStatus[LeftSide] of
                                PayCheckBufferStatus[LeftSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Starting;
                                        PayCheckBuffer[LeftSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[LeftSide] ::Starting:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished
                                    else
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Printing;
                                PayCheckBufferStatus[LeftSide] ::Printing:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                            end;
                        end else begin
                            LeftSide := LeftSide::Earnings;
                            PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                        end;

                        if RightSide < RightSide::"Gross to Net Pay" then
                            RightSide := FindNextCategory(WhichColumn::Right);

                        if RightSide = RightSide::"Gross to Net Pay" then begin
                            case PayCheckBufferStatus[RightSide] of
                                PayCheckBufferStatus[RightSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Starting;
                                        PayCheckBuffer[RightSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[RightSide] ::Starting:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished
                                    else
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Printing;
                                PayCheckBufferStatus[RightSide] ::Printing:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                            end;
                        end else begin
                            RightSide := RightSide::"Gross to Net Pay";
                            PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                        end;

                        if PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished then
                            Clear(PayCheckBuffer[LeftSide])
                        else
                            if not TestPrint then begin
                                TotalGross := TotalGross + PayCheckBuffer[LeftSide].Amount;
                                TotalYTDGross := TotalYTDGross + PayCheckBuffer[LeftSide]."YTD Amount";
                            end;

                        if PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished then
                            Clear(PayCheckBuffer[RightSide])
                        else
                            if not TestPrint then begin
                                TotalNet := TotalNet + PayCheckBuffer[RightSide].Amount;
                                TotalYTDNet := TotalYTDNet + PayCheckBuffer[RightSide]."YTD Amount";
                            end;

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) and
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished)
                        then begin
                            SectionNo := 0;
                            CurrReport.Break;
                        end;

                        if PayCheckBuffer[LeftSide].Hours <> 0 then
                            Rate := Round(PayCheckBuffer[LeftSide].Amount / PayCheckBuffer[LeftSide].Hours, 0.00001)
                        else
                            Rate := 0;

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                           (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Printing) then
                            SectionEarnings := IsSectionEarnings(PayCheckBuffer[LeftSide]);
                        if (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting) or
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Printing) then
                            SectionGrossToNetPay := IsSectionGrossToNetPay(PayCheckBuffer[RightSide]);

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting) or
                           OnTopOfPage then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub1and2H1 := true;
                        end;

                        StubLinesPrinted := StubLinesPrinted + 1;

                        LineNo := LineNo + 1;
                        SectionNo := 12;
                    end;

                    trigger OnPostDataItem()
                    begin
                        SectionEarnings := false;
                        SectionGrossToNetPay := false;

                        if not GoToNextPage then begin
                            if (Abs(TotalNet + NetPayPayrollJnlLine."Cash Amount") > 0.005) and not TestPrint then
                                Error(Text007 + Text007a,
                                      Employee.TableCaption,
                                      Employee."No.");
                        end;
                        StubLinesPrinted := StubLinesPrinted + 2;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (PayCheckBufferStatus[LeftSide::Earnings] = PayCheckBufferStatus[LeftSide::Earnings] ::Finished) and
                           (PayCheckBufferStatus[RightSide::"Gross to Net Pay"] = PayCheckBufferStatus[RightSide::"Gross to Net Pay"] ::Finished)
                        then
                            CurrReport.Break;
                        ItemsProcessed := 0;

                        ResetOnTopOfPage := false;
                    end;
                }
                dataitem(PrintPayStub3and4; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(PrintPayStub3and4H1; PrintPayStub3and4H1)
                    {
                    }
                    column(PrintPayStub3and4H2; PrintPayStub3and4H2)
                    {
                    }
                    column(PrintPayStub3and4H3; PrintPayStub3and4H3)
                    {
                    }
                    column(PrintPayStub3and4B1; PrintPayStub3and4B1)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        SectionOtherInformation := false;
                        SectionNetPayDistribution := false;
                        PrintPayStub3and4H1 := false;
                        PrintPayStub3and4H2 := false;
                        PrintPayStub3and4H3 := false;
                        PrintPayStub3and4B1 := true;
                        if ResetOnTopOfPage then begin
                            OnTopOfPage := false;
                            ResetOnTopOfPage := false;
                        end;

                        if IncludeTaxInfo or IncludeRateInfo then begin
                            if StubLinesPrinted + 5 > StubLinesPerCheck then
                                GoToNextPage := true;
                        end else begin
                            if StubLinesPrinted + 2 > StubLinesPerCheck then
                                GoToNextPage := true;
                        end;

                        if GoToNextPage then
                            CurrReport.Break;

                        if LeftSide < LeftSide::"Other Information" then
                            LeftSide := FindNextCategory(WhichColumn::Left);

                        if LeftSide = LeftSide::"Other Information" then begin
                            case PayCheckBufferStatus[LeftSide] of
                                PayCheckBufferStatus[LeftSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Starting;
                                        PayCheckBuffer[LeftSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[LeftSide] ::Starting:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished
                                    else
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Printing;
                                PayCheckBufferStatus[LeftSide] ::Printing:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                            end;
                        end else begin
                            LeftSide := LeftSide::"Other Information";
                            PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                        end;

                        if RightSide < RightSide::"Net Pay Distribution" then
                            RightSide := FindNextCategory(WhichColumn::Right);

                        if RightSide = RightSide::"Net Pay Distribution" then begin
                            case PayCheckBufferStatus[RightSide] of
                                PayCheckBufferStatus[RightSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Starting;
                                        PayCheckBuffer[RightSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[RightSide] ::Starting:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished
                                    else
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Printing;
                                PayCheckBufferStatus[RightSide] ::Printing:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                            end;
                        end else begin
                            RightSide := RightSide::"Net Pay Distribution";
                            PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                        end;

                        if PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished then
                            Clear(PayCheckBuffer[LeftSide]);

                        if PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished then
                            Clear(PayCheckBuffer[RightSide]);

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) and
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished)
                        then
                            CurrReport.Break;

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                           (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Printing) then
                            SectionOtherInformation := IsSectionOtherInformation(PayCheckBuffer[LeftSide]);

                        if (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting) or
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Printing) then
                            SectionNetPayDistribution := IsSectionNetPayDistribution(PayCheckBuffer[RightSide]);

                        if (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished) and
                           ((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                           (OnTopOfPage and
                           (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub3and4H1 := true;
                        end;

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) and
                           ((PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting) or
                           (OnTopOfPage and
                           (PayCheckBufferStatus[RightSide] <> PayCheckBufferStatus[RightSide] ::Finished))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub3and4H2 := true;
                        end;

                        if ((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) and
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting)) or
                           (OnTopOfPage and
                           (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished) and
                           (PayCheckBufferStatus[RightSide] <> PayCheckBufferStatus[RightSide] ::Finished)) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub3and4H3 := true;
                        end;

                        StubLinesPrinted := StubLinesPrinted + 1;

                        LineNo := LineNo + 1;
                        SectionNo := 34;
                    end;

                    trigger OnPostDataItem()
                    begin
                        SectionOtherInformation := false;
                        SectionNetPayDistribution := false;

                        if not GoToNextPage then begin
                            StubLinesPrinted := StubLinesPrinted + 1;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (PayCheckBufferStatus[LeftSide::"Other Information"] = PayCheckBufferStatus[LeftSide::"Other Information"] ::Finished) and
                           (PayCheckBufferStatus[RightSide::"Net Pay Distribution"] = PayCheckBufferStatus[RightSide::"Net Pay Distribution"] ::Finished)
                        then
                            CurrReport.Break;

                        ResetOnTopOfPage := false;
                    end;
                }
                dataitem(PrintPayStub5and6; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(PrintPayStub5and6H1; PrintPayStub5and6H1)
                    {
                    }
                    column(PrintPayStub5and6H2; PrintPayStub5and6H2)
                    {
                    }
                    column(PrintPayStub5and6H3; PrintPayStub5and6H3)
                    {
                    }
                    column(PrintPayStub5and6H4; PrintPayStub5and6H4)
                    {
                    }
                    column(PrintPayStub5and6H5; PrintPayStub5and6H5)
                    {
                    }
                    column(PrintPayStub5and6B1; PrintPayStub5and6B1)
                    {
                    }
                    column(PrintPayStub5and6B2; PrintPayStub5and6B2)
                    {
                    }
                    column(PrintPayStub5and6B3; PrintPayStub5and6B3)
                    {
                    }
                    column(PrintPayStub5and6B4; PrintPayStub5and6B4)
                    {
                    }
                    column(TaxExemptText; TaxExemptText)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PrintPayStub5and6H1 := false;
                        PrintPayStub5and6H2 := false;
                        PrintPayStub5and6H3 := false;
                        PrintPayStub5and6H4 := false;
                        PrintPayStub5and6H5 := false;
                        PrintPayStub5and6B1 := false;
                        PrintPayStub5and6B2 := false;
                        PrintPayStub5and6B3 := false;
                        PrintPayStub5and6B4 := false;

                        if ResetOnTopOfPage then begin
                            OnTopOfPage := false;
                            ResetOnTopOfPage := false;
                        end;

                        if StubLinesPrinted + 1 > StubLinesPerCheck then
                            GoToNextPage := true;

                        if GoToNextPage then
                            CurrReport.Break;

                        TaxExemptText := '';

                        if LeftSide < LeftSide::"Tax Information" then
                            LeftSide := FindNextCategory(WhichColumn::Left);

                        if LeftSide = LeftSide::"Tax Information" then begin
                            case PayCheckBufferStatus[LeftSide] of
                                PayCheckBufferStatus[LeftSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Starting;
                                        PayCheckBuffer[LeftSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[LeftSide] ::Starting:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished
                                    else
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Printing;
                                PayCheckBufferStatus[LeftSide] ::Printing:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                            end;
                        end else begin
                            LeftSide := LeftSide::"Tax Information";
                            PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                        end;

                        if RightSide < RightSide::"Rate Information" then
                            RightSide := FindNextCategory(WhichColumn::Right);

                        if RightSide = RightSide::"Rate Information" then begin
                            case PayCheckBufferStatus[RightSide] of
                                PayCheckBufferStatus[RightSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Starting;
                                        PayCheckBuffer[RightSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[RightSide] ::Starting:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished
                                    else
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Printing;
                                PayCheckBufferStatus[RightSide] ::Printing:
                                    if PayCheckBuffer[RightSide].Next = 0 then
                                        PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                            end;
                        end else begin
                            RightSide := RightSide::"Rate Information";
                            PayCheckBufferStatus[RightSide] := PayCheckBufferStatus[RightSide] ::Finished;
                        end;

                        if PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished then
                            Clear(PayCheckBuffer[LeftSide])
                        else begin
                            if PayCheckBuffer[LeftSide]."Income Tax Exempt" then begin
                                PayCheckBuffer[LeftSide].Allowances := 0;
                                PayCheckBuffer[LeftSide]."Credits/Other Deps." := 0;
                                TaxExemptText := 'Tax Exempt';
                            end;
                        end;

                        if PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished then
                            Clear(PayCheckBuffer[RightSide]);

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) and
                           (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished)
                        then
                            CurrReport.Break;


                        if (PRSetup."Payroll Country" = PRSetup."Payroll Country"::US) and
                          ((PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished) and
                          ((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                          (OnTopOfPage and
                          (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished)))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub5and6H1 := true;
                        end;
                        if (PRSetup."Payroll Country" = PRSetup."Payroll Country"::Canada) and
                          ((PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Finished) and
                          ((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                          (OnTopOfPage and
                          (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished)))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub5and6H2 := true;
                        end;
                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) and
                           ((PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting) or
                           (OnTopOfPage and
                           (PayCheckBufferStatus[RightSide] <> PayCheckBufferStatus[RightSide] ::Finished))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub5and6H3 := true;
                        end;
                        if (PRSetup."Payroll Country" = PRSetup."Payroll Country"::US) and
                          (((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) and
                          (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting)) or
                          (OnTopOfPage and
                          (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished) and
                          (PayCheckBufferStatus[RightSide] <> PayCheckBufferStatus[RightSide] ::Finished))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub5and6H4 := true;
                        end;
                        if (PRSetup."Payroll Country" = PRSetup."Payroll Country"::Canada) and
                          (((PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) and
                          (PayCheckBufferStatus[RightSide] = PayCheckBufferStatus[RightSide] ::Starting)) or
                          (OnTopOfPage and
                          (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished) and
                          (PayCheckBufferStatus[RightSide] <> PayCheckBufferStatus[RightSide] ::Finished))) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub5and6H5 := true;
                        end;
                        if PRSetup."Payroll Country" = PRSetup."Payroll Country"::US then begin
                            if TaxExemptText = '' then begin
                                PrintPayStub5and6B1 := true;
                            end else begin
                                PrintPayStub5and6B2 := true;
                            end;
                            StubLinesPrinted := StubLinesPrinted + 1;
                        end;
                        if PRSetup."Payroll Country" = PRSetup."Payroll Country"::Canada then begin
                            if TaxExemptText = '' then begin
                                PrintPayStub5and6B3 := true;
                            end else begin
                                PrintPayStub5and6B4 := true;
                            end;
                            StubLinesPrinted := StubLinesPrinted + 1;
                        end;

                        LineNo := LineNo + 1;
                        SectionNo := 56;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not GoToNextPage then
                            StubLinesPrinted := StubLinesPrinted + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if ((PayCheckBufferStatus[LeftSide::"Tax Information"] = PayCheckBufferStatus[LeftSide::"Tax Information"] ::Finished) and
                            (PayCheckBufferStatus[RightSide::"Rate Information"] = PayCheckBufferStatus[RightSide::"Rate Information"] ::Finished)) or
                           (not IncludeTaxInfo and not IncludeRateInfo)
                        then
                            CurrReport.Break;

                        ResetOnTopOfPage := false;
                    end;
                }
                dataitem(PrintPayStub7; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(PrintPayStub7H1; PrintPayStub7H1)
                    {
                    }
                    column(PrintPayStub7B1; PrintPayStub7B1)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PrintPayStub7H1 := false;
                        PrintPayStub7B1 := false;
                        if ResetOnTopOfPage then begin
                            OnTopOfPage := false;
                            ResetOnTopOfPage := false;
                        end;

                        if StubLinesPrinted + 1 > StubLinesPerCheck then
                            GoToNextPage := true;

                        if GoToNextPage then
                            CurrReport.Break;

                        if LeftSide < LeftSide::"Other Auth. Information" then
                            LeftSide := FindNextCategory(WhichColumn::Left);

                        if LeftSide = LeftSide::"Other Auth. Information" then begin
                            case PayCheckBufferStatus[LeftSide] of
                                PayCheckBufferStatus[LeftSide] ::"Not Started":
                                    begin
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Starting;
                                        PayCheckBuffer[LeftSide].FindFirst();
                                    end;
                                PayCheckBufferStatus[LeftSide] ::Starting:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished
                                    else
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Printing;
                                PayCheckBufferStatus[LeftSide] ::Printing:
                                    if PayCheckBuffer[LeftSide].Next = 0 then
                                        PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                            end;
                        end else begin
                            LeftSide := LeftSide::"Other Auth. Information";
                            PayCheckBufferStatus[LeftSide] := PayCheckBufferStatus[LeftSide] ::Finished;
                        end;

                        if PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished then
                            Clear(PayCheckBuffer[LeftSide]);

                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Finished) then
                            CurrReport.Break;


                        if (PayCheckBufferStatus[LeftSide] = PayCheckBufferStatus[LeftSide] ::Starting) or
                           (OnTopOfPage and
                           (PayCheckBufferStatus[LeftSide] <> PayCheckBufferStatus[LeftSide] ::Finished)) then begin

                            if OnTopOfPage then
                                ResetOnTopOfPage := true;
                            StubLinesPrinted := StubLinesPrinted + 2;
                            PrintPayStub7H1 := true;
                        end;
                        StubLinesPrinted := StubLinesPrinted + 1;
                        PrintPayStub7B1 := true;

                        LineNo := LineNo + 1;
                        SectionNo := 70;
                    end;

                    trigger OnPostDataItem()
                    begin

                        if not GoToNextPage then
                            StubLinesPrinted := StubLinesPrinted + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if ((PayCheckBufferStatus[LeftSide::"Other Auth. Information"]
                            = PayCheckBufferStatus[LeftSide::"Other Auth. Information"] ::Finished)) or
                           (not IncludeTaxInfo)
                        then
                            CurrReport.Break;

                        ResetOnTopOfPage := false;
                    end;
                }
                dataitem(PrintCheck; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyAddr_1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6; CompanyAddr[6])
                    {
                    }
                    column(DescriptionLine_1; DescriptionLine[1])
                    {
                    }
                    column(DescriptionLine_2; DescriptionLine[2])
                    {
                    }
                    column(CheckToAddr_2; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_3; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_4; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_5; CheckToAddr[5])
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(CheckAmountText; CheckAmountText)
                    {
                    }
                    column(MICR; MICR)
                    {
                    }
                    column(SignatureLine1; SignatureLine1)
                    {
                    }
                    column(CheckSignature_Pre_printed_Signature_1; CheckSignature."Pre-printed Signature 1")
                    {
                    }
                    column(SignatureLine2; SignatureLine2)
                    {
                    }
                    column(CheckSignature_Pre_printed_Signature_2; CheckSignature."Pre-printed Signature 2")
                    {
                    }
                    column(PrintCheck_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempComAddr := '';
                        TempChar := 177;
                        TempText := Format(TempChar);
                        for i := 1 to 8 do begin
                            TempComAddr := TempComAddr + CompanyAddr[i];
                            if i <> 8 then
                                TempComAddr := TempComAddr + TempText;
                        end;

                        if GoToNextPage then begin
                            CheckAmountText := '0.00';
                            if not CurrReport.Preview and not RemittanceAdvicesOnly then
                                PayCheckPrintManagement.MakeVoidCheckToUseStub(NetPayPayrollJnlLine, UseCheckNo);
                        end else
                            if not TestPrint then begin
                                CheckAmount := PayCheckPrintManagement.GetPayCheckAmount(NetPayPayrollJnlLine);
                                CheckAmountText := Format(CheckAmount, 0);
                                i := StrPos(CheckAmountText, '.');
                                case true of
                                    i = 0:
                                        CheckAmountText := CheckAmountText + '.00';
                                    i = StrLen(CheckAmountText) - 1:
                                        CheckAmountText := CheckAmountText + '0';
                                    i > StrLen(CheckAmountText) - 2:
                                        CheckAmountText := CopyStr(CheckAmountText, 1, i + 2);
                                end;
                                if CheckAmount <> 0 then begin
                                    FormatNumberText(DescriptionLine, CheckAmount);
                                    VoidText := '';
                                end;
                                if not CurrReport.Preview then begin
                                    PayCheckPrintManagement.InsertCheckInCheckLedger(NetPayPayrollJnlLine);
                                    WritePayCheckJnl();
                                end;
                            end else begin
                                CheckAmountText := 'XXXXX.XX';
                                if not CurrReport.Preview then
                                    PayCheckPrintManagement.MakeVoidCheckForTestPrint(BankAcc2."No.", UseCheckNo);
                            end;

                        ChecksPrinted := ChecksPrinted + 1;
                        FoundLast := not GoToNextPage;
                    end;

                    trigger OnPostDataItem()
                    begin
                        FirstPage := false;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if FoundLast then
                        CurrReport.Break;

                    DescriptionLine[1] := Text004 + Text004 + Text004 + Text004 + Text004 + Text004 + Text004 + Text004 +
                                          Text004 + Text004 + Text004 + Text004 + Text004 + Text004 + Text004 + Text004;
                    DescriptionLine[2] := DescriptionLine[1];
                    if RemittanceAdvicesOnly then
                        VoidText := Text005
                    else
                        VoidText := Text006;

                    MICR := '';
                    if not TestPrint then begin
                        CheckNoText := NetPayPayrollJnlLine."Document No.";
                        if BankAcc2."Print MICR Encoding" then begin
                            if NetPayPayrollJnlLine."Bank Payment Type" = NetPayPayrollJnlLine."Bank Payment Type"::"Computer check" then
                                MICR := BankAcc2.MICRFormat(NetPayPayrollJnlLine."Document No.")
                            else
                                if NetPayPayrollJnlLine."Bank Payment Type" = NetPayPayrollJnlLine."Bank Payment Type"::"Electronic payment" then begin
                                    EmployeePayDistribution.Reset;
                                    EmployeePayDistribution.SetRange("Employee No.", NetPayPayrollJnlLine."Employee No.");
                                    EmployeePayDistribution.SetRange(Type, EmployeePayDistribution.Type::"Pay Check");
                                    if EmployeePayDistribution.FindFirst() then begin
                                        MICR := BankAcc2.MICRFormat(NetPayPayrollJnlLine."Document No.");
                                    end else begin
                                        EmployeePayDistribution.SetFilter(Type, '%1|%2',
                                          EmployeePayDistribution.Type::Checking, EmployeePayDistribution.Type::Savings);
                                        EmployeePayDistribution.SetRange(Prenote, true);
                                        if EmployeePayDistribution.FindFirst() then
                                            MICR := BankAcc2.MICRFormat(NetPayPayrollJnlLine."Document No.");
                                    end;
                                end;
                        end;
                        SetSignatureLines(BankAcc2, -NetPayPayrollJnlLine."Cash Amount");
                    end else begin
                        CheckNoText := 'XXXX';
                    end;

                    OnTopOfPage := true;
                    GoToNextPage := false;
                    StubLinesPrinted := 0;
                    PageNo := PageNo + 1;
                end;

                trigger OnPostDataItem()
                begin
                    if CommitEachCheck and not CurrReport.Preview then
                        PayCheckPrintManagement.CommitCheck();
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := true;
                    FoundLast := false;
                    Clear(PayCheckBuffer);
                    Clear(PayCheckBufferStatus);
                    PayCheckBuffer[1].SetRange("Check Stub Section", LeftSide::Earnings);
                    PayCheckBuffer[2].SetRange("Check Stub Section", LeftSide::"Gross to Net Pay");
                    PayCheckBuffer[3].SetRange("Check Stub Section", LeftSide::"Other Information");
                    PayCheckBuffer[4].SetRange("Check Stub Section", LeftSide::"Net Pay Distribution");
                    PayCheckBuffer[5].SetRange("Check Stub Section", LeftSide::"Tax Information");
                    PayCheckBuffer[6].SetRange("Check Stub Section", LeftSide::"Rate Information");
                    PayCheckBuffer[7].SetRange("Check Stub Section", LeftSide::"Other Auth. Information");
                    LeftSide := 0;
                    RightSide := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PayrollJournalCycleTemp.Get("Pay Cycle Code") then begin
                    CurrReport.Skip
                end
                else begin
                    if ("Pay Cycle Term" <> PayrollJournalCycleTemp."Pay Cycle Term") then begin
                        "Pay Cycle Term" := PayrollJournalCycleTemp."Pay Cycle Term";
                    end;
                    if ("Pay Cycle Period" <> PayrollJournalCycleTemp."Pay Cycle Period") then begin
                        "Pay Cycle Period" := PayrollJournalCycleTemp."Pay Cycle Period";
                    end;
                end;

                CheckEmployerNo();

                if not TestPrint then begin
                    TestField("Payroll Posting Group");
                    if EnteredCheckDate <> 0D then
                        PayrollPostingGroup.GetPostingGroup("Payroll Posting Group", EnteredCheckDate, false)
                    else
                        PayrollPostingGroup.GetPostingGroup("Payroll Posting Group", "Posting Date", false);
                    PayrollPostingGroup.TestField("Bank Account No.");
                    if PayrollPostingGroup."Bank Account No." <> BankAcc2."No." then
                        CurrReport.Skip;

                    if "Cash Amount" > 0 then
                        Error(Text003,
                              FieldCaption("Cash Amount"),
                              FieldCaption("Employee No."),
                              "Employee No.");

                    PayCheckBuffer[1].LockTable;
                    PayCheckBuffer[1].Reset;
                    PayCheckBuffer[1].DeleteAll;
                    DeletePayCheckJnl();
                    NetPayPayrollJnlLine := NetPayPayrollJnlLine2;
                    if RemittanceAdvicesOnly then begin
                        PayCheckPrintManagement.LoadPayDistribution(NetPayPayrollJnlLine);
                        if PayCheckPrintManagement.GetPayCheckAmount(NetPayPayrollJnlLine) <> 0.0 then
                            CurrReport.Skip;
                        PayCheckBuffer[1].DeleteAll;
                    end;
                    if not CurrReport.Preview then
                        PayCheckPrintManagement.TestCheckAndUpdate(NetPayPayrollJnlLine, UseCheckNo, EnteredCheckDate, RemittanceAdvicesOnly,
                                                                    PayrollJournalCycleTemp, EmployerNo);
                    PayCheckPrintManagement.LoadEarnings(NetPayPayrollJnlLine);
                    PayCheckPrintManagement.LoadGrossToNet(NetPayPayrollJnlLine);
                    PayCheckPrintManagement.LoadOtherInfo(NetPayPayrollJnlLine);
                    PayCheckPrintManagement.LoadPayDistribution(NetPayPayrollJnlLine);
                    if IncludeTaxInfo then begin
                        PayCheckPrintManagement.LoadTaxInfo(NetPayPayrollJnlLine);
                        PayCheckPrintManagement.LoadOtherAuthInfo(NetPayPayrollJnlLine);
                    end;
                    if IncludeRateInfo then
                        PayCheckPrintManagement.LoadRateInfo(NetPayPayrollJnlLine);
                    CheckDateText := Format(NetPayPayrollJnlLine."Posting Date", 0, 4);

                    Clear(CheckToAddr);
                    Employee.Get("Employee No.");
                    Employee.TestField(Blocked, false);
                    FormatAddress.Employee(CheckToAddr, Employee);
                    TotalGross := 0;
                    TotalNet := 0;
                    TotalYTDGross := 0;
                    TotalYTDNet := 0;
                end else begin
                    if ChecksPrinted > 0 then
                        CurrReport.Break;

                    PayCheckBuffer[1].LockTable;
                    Employee."No." := 'XXXXXXXXXX';
                    PayCheckPrintManagement.LoadForTestPrint();
                    Clear(CheckToAddr);
                    for i := 1 to 5 do
                        CheckToAddr[i] := 'XXXXXXXXXXXXXXXX';
                    CheckNoText := 'XXXX';
                    CheckDateText := 'Xxxxxxxxx 99, 9999';
                    TotalGross := 999999.99;
                    TotalNet := 999999.99;
                    TotalYTDGross := 9999999.99;
                    TotalYTDNet := 9999999.99;
                end;

                PayCheckPrintManagement.GetStubAnalysisArray(AnyInCategory);
            end;

            trigger OnPreDataItem()
            begin
                Copy(VoidPayrollJnlLine);
                CompanyInfo.Get;
                if not TestPrint then begin
                    FormatAddress.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.Get(BankAcc2."No.");
                    BankAcc2.TestField(Blocked, false);
                    BankAcc2.TestField("Currency Code", '');  // local currency only
                    Copy(VoidPayrollJnlLine);
                    SavedFilterGroup := FilterGroup(GetFilterGroup());
                    SetFilter("Bank Payment Type", '%1|%2',
                              "Bank Payment Type"::"Computer check",
                              "Bank Payment Type"::"Electronic payment");
                    FilterGroup(SavedFilterGroup);
                    SetRange("Check Printed", false);
                    SetRange("Check Exported", false);
                    SetRange("Payroll Control Type", "Payroll Control Type"::"Net Pay");
                    SetFilter("Cash Amount", '..0');
                end else begin
                    Clear(CompanyAddr);
                    for i := 1 to 5 do
                        CompanyAddr[i] := 'XXXXXXXXXXXXXXXX';
                end;
                UseCheckNo := IncStr(UseCheckNo);
                ChecksPrinted := 0;
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
                    field(SeletPayCycles; SelectPayCycles)
                    {
                        Caption = 'Pay Cycles';
                        Editable = false;
                        OptionCaption = 'Select Pay Cycles';

                        trigger OnDrillDown()
                        begin
                            PAGE.RunModal(PAGE::"Payroll Journal Check Cycles", PayrollJournalCycleTemp);
                            if PayrollJournalCycleTemp.FindSet(false) then begin
                                repeat
                                    if PayrollJournalCycleTemp."Pay Cycle Term" = '' then begin
                                        Error(Text009, PayrollJournalCycleTemp."Pay Cycle Code");
                                    end;
                                    if PayrollJournalCycleTemp."Pay Cycle Period" = 0 then begin
                                        Error(Text010, PayrollJournalCycleTemp."Pay Cycle Code")
                                    end;
                                until PayrollJournalCycleTemp.Next = 0;
                            end;
                        end;
                    }
                    field("BankAcc2.""No."""; BankAcc2."No.")
                    {
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            //SOC-MD 12-31-15
                            //BankAcc2NoOnAfterValidate;
                            RemittanceAdvicesOnlyOnAfterVa;
                            //SOC-MD 12-31-15
                        end;
                    }
                    field(RemittanceAdvicesOnly; RemittanceAdvicesOnly)
                    {
                        Caption = 'Remittance Advices Only';
                        Editable = false;

                        trigger OnValidate()
                        begin
                            RemittanceAdvicesOnlyOnAfterVa;
                        end;
                    }
                    field(UseCheckNo; UseCheckNo)
                    {
                        Caption = 'Last Check No.';
                    }
                    field(EnteredCheckDate; EnteredCheckDate)
                    {
                        Caption = 'Check Date';
                    }
                    field(ReprintChecks; ReprintChecks)
                    {
                        Caption = 'Reprint Checks';
                    }
                    field(TestPrint; TestPrint)
                    {
                        Caption = 'Test Print';
                    }
                    field(IncludeTaxInfo; IncludeTaxInfo)
                    {
                        Caption = 'Include Rep. Auth. Information';
                    }
                    field(IncludeRateInfo; IncludeRateInfo)
                    {
                        Caption = 'Include Rate Information';
                    }
                    field(CommitEachCheck; CommitEachCheck)
                    {
                        Caption = 'Commit Each Check';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action("Pay Cycles")
                {
                    Caption = 'Pay Cycles';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Payroll Journal Check Cycles", PayrollJournalCycleTemp);
                        if PayrollJournalCycleTemp.FindSet(false) then begin
                            repeat
                                if PayrollJournalCycleTemp."Pay Cycle Term" = '' then begin
                                    Error(Text009, PayrollJournalCycleTemp."Pay Cycle Code");
                                end;
                                if PayrollJournalCycleTemp."Pay Cycle Period" = 0 then begin
                                    Error(Text010, PayrollJournalCycleTemp."Pay Cycle Code")
                                end;
                            until PayrollJournalCycleTemp.Next = 0;
                        end;
                    end;
                }
            }
        }

        trigger OnInit()
        begin
            VoidPayrollJnlLine.SetRange("Line No.");
        end;

        trigger OnOpenPage()
        begin
            PayrollJnlLine4.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Employee No.",
              "Document Type", "Document No.", "Bank Payment Type");
            PayrollJnlLine4.SetRange("Journal Template Name", PayrollJnlLine."Journal Template Name");
            PayrollJnlLine4.SetRange("Journal Batch Name", PayrollJnlLine."Journal Batch Name");
            if SingleEmployee then
                PayrollJnlLine4.SetRange("Employee No.", PayrollJnlLine."Employee No.");
            if PayrollJnlLine4.FindFirst() then begin
                PayrollJnlLine4.SetFilter("Bank Payment Type", '%1', PayrollJnlLine4."Bank Payment Type"::" ");
                if PayrollJnlLine4.FindFirst() then begin
                    Error(Text011, PayrollJnlLine4."Employee No.", PayrollJnlLine4."Payroll Control Code");
                end;
                PayrollJnlLine4.SetRange("Bank Payment Type");
                PayrollJnlLine4.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                if PayrollJnlTemplate2.Get(PayrollJnlLine4."Journal Template Name") then begin
                    if PayrollJnlTemplate2.Recurring then begin
                        PayrollJnlLine4.SetFilter("Recurring Method", '%1', PayrollJnlLine4."Recurring Method"::"F  Fixed");
                        if PayrollJnlLine4.FindFirst() then begin
                            Error(Text012, PayrollJnlLine4."Employee No.", PayrollJnlLine4."Payroll Control Code");
                        end;
                        PayrollJnlLine4.SetRange("Recurring Method");

                        PayrollJnlLine4.SetFilter("Recurring Frequency", '%1', '');
                        if PayrollJnlLine4.FindFirst() then begin
                            Error(Text013, PayrollJnlLine4."Employee No.", PayrollJnlLine4."Payroll Control Code");
                        end;
                        PayrollJnlLine4.SetRange("Recurring Frequency");
                    end;
                end;
            end;

            if BankAcc2."No." <> '' then begin
                if BankAcc2.Get(BankAcc2."No.") then begin
                    RemittanceAdvicesOnly := false;
                    UseCheckNo := BankAcc2."Last Check No.";
                end
                else begin
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                end;
            end;
            EnteredCheckDate := 0D;

            PayrollJnlLine2 := PayrollJnlLine;
            PayrollJnlLine2.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
            PayrollJnlLine2.SetFilter("Pay Cycle Code", '<>%1', '');
            PayrollJnlLine2.SetFilter("Pay Cycle Term", '<>%1', '');
            PayrollJnlLine2.SetFilter("Pay Cycle Period", '<>%1', 0);
            PayrollJnlLine2.SetRange("Journal Template Name", PayrollJnlLine2."Journal Template Name");
            PayrollJnlLine2.SetRange("Journal Batch Name", PayrollJnlLine2."Journal Batch Name");
            if SingleEmployee then
                PayrollJnlLine2.SetRange("Employee No.", PayrollJnlLine2."Employee No.");

            if PayrollJnlLine2.FindSet(false) then begin
                PayrollJournalCycleTemp.DeleteAll;
                repeat
                    PayrollJnlLine2.SetRange("Pay Cycle Code", PayrollJnlLine2."Pay Cycle Code");
                    repeat
                        Clear(PayrollJnlLine3);
                        PayrollJnlLine2.SetRange("Pay Cycle Term", PayrollJnlLine2."Pay Cycle Term");
                        PayrollJnlLine2.Find('+');
                        PayrollJnlLine2.SetFilter("Pay Cycle Term", '<>%1', '');
                        if PayrollJnlLine2."Pay Period End Date" > PayrollJnlLine3."Pay Period End Date" then begin
                            PayrollJnlLine3 := PayrollJnlLine2;
                        end;
                    until PayrollJnlLine2.Next = 0;
                    PayrollJnlLine2.SetFilter("Pay Cycle Code", '<>%1', '');

                    PayrollJournalCycleTemp.Init;
                    PayrollJournalCycleTemp."Pay Cycle Code" := PayrollJnlLine3."Pay Cycle Code";
                    PayrollJournalCycleTemp."Pay Cycle Term" := PayrollJnlLine3."Pay Cycle Term";
                    PayrollJournalCycleTemp."Pay Cycle Period" := PayrollJnlLine3."Pay Cycle Period";
                    PayrollJournalCycleTemp.Insert;
                until PayrollJnlLine2.Next = 0;
            end;
            PayrollJournalCycleTemp.Reset;

            //SOC-MD 11-25-15
            RemittanceAdvicesOnly := true;
            RemittanceAdvicesOnlyOnAfterVa;
        end;
    }

    labels
    {
        AllowLbl = 'Allow.';
        AmountLbl = 'Amount';
        BalanceLbl = 'Balance';
        CheckNoLbl = 'Check No.';
        CreditLbl = 'Credits';
        DependentsLbl = 'Dependents';
        EarningsLbl = 'Earnings';
        ExtraWHLbl = 'Extra W/H';
        FilingStatusLbl = 'Filing Status';
        GrossToNetPayLbl = 'Gross to Net Pay';
        HoursLbl = 'Hours';
        NetPayLbl = 'Net Pay';
        NetPayDistributionLbl = 'Net Pay Distribution';
        OtherAuthInformationLbl = 'Other Auth. Information';
        OtherInformationLbl = 'Other Information';
        RateLbl = 'Rate';
        RateInformationLbl = 'Rate Information';
        TaxAuthInformationLbl = 'Tax Auth. Information';
        ThisCheckLbl = 'This Check';
        TotalCredLbl = 'Total Cred.';
        TotalEarningsLbl = 'Total Earnings';
        YTDAmountLbl = 'YTD Amount';
    }

    trigger OnPostReport()
    begin
        if (not TestPrint) and (ChecksPrinted = 0) then
            Message(Text014);
    end;

    trigger OnPreReport()
    begin
        if CurrReport.Preview then;

        if PayrollJournalCycleTemp.FindSet(false, false) then begin
            repeat
                if PayrollJournalCycleTemp."Pay Cycle Term" = '' then begin
                    Error(Text009, PayrollJournalCycleTemp."Pay Cycle Code");
                end;
                if PayrollJournalCycleTemp."Pay Cycle Period" = 0 then begin
                    Error(Text010, PayrollJournalCycleTemp."Pay Cycle Code")
                end;
            until PayrollJournalCycleTemp.Next = 0;
        end;

        InitTextVar;
        for i := 1 to 7 do
            CheckStubSection[i] := i;
        if UseCheckNo = '' then
            Error(Text000);
        if IncStr(UseCheckNo) = '' then
            Error(Text001);
        VoidPayrollJnlLine.SetRange("Line No.");
        StubLinesPerCheck := 38;   // RTC 17 for 7" check, or 38 for 11" check
        PRSetup.FindFirst();
    end;

    var
        PayrollJnlTemplate: Record "Payroll Journal Template";
        PayrollJnlTemplate2: Record "Payroll Journal Template";
        NetPayPayrollJnlLine: Record "Payroll Journal Line";
        PayrollJnlLine: Record "Payroll Journal Line";
        PayrollJnlLine2: Record "Payroll Journal Line";
        PayrollJnlLine3: Record "Payroll Journal Line";
        PayrollJnlLine4: Record "Payroll Journal Line";
        PayrollJnlHeader: Record "Payroll Journal Header";
        CompanyInfo: Record "Company Information";
        PRSetup: Record "NVP Payroll Setup";
        Employee: Record Employee;
        PayrollPostingGroup: Record "Payroll Posting Group";
        PayrollJournalCycleTemp: Record "Payroll Journal Cycle" temporary;
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        PayrollJournalCycle: Page "Payroll Journal Cycles";
        FormatAddress: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        PayCheckPrintManagement: Codeunit "Pay Check Print Management";
        ParagraphHandling: Codeunit "Paragraph Handling";
        Window: Dialog;
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        CheckStubSection: array[7] of Option ,Earnings,"Gross to Net Pay","Other Information","Net Pay Distribution","Tax Information","Rate Information","Other Auth. Information";
        PayCheckBuffer: array[7] of Record "Pay Check Print Buffer";
        PayCheckBufferStatus: array[7] of Option "Not Started",Starting,Printing,Finished;
        Rate: Decimal;
        TotalGross: Decimal;
        TotalYTDGross: Decimal;
        TotalNet: Decimal;
        TotalYTDNet: Decimal;
        CheckAmount: Decimal;
        AnyInCategory: array[7, 3] of Boolean;
        LeftSideWasPrinting: Boolean;
        RightSideWasPrinting: Boolean;
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[250];
        VoidText: Text[30];
        TaxExemptText: Text[30];
        UseCheckNo: Code[20];
        EmployerNo: Code[20];
        EnteredCheckDate: Date;
        FirstPage: Boolean;
        FoundLast: Boolean;
        OnTopOfPage: Boolean;
        GoToNextPage: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        IncludeTaxInfo: Boolean;
        IncludeRateInfo: Boolean;
        CommitEachCheck: Boolean;
        RemittanceAdvicesOnly: Boolean;
        ChecksPrinted: Integer;
        i: Integer;
        StubLinesPerCheck: Integer;
        StubLinesPrinted: Integer;
        LinesToTest: Integer;
        LinesTested: Integer;
        LeftSide: Option ,Earnings,"Gross to Net Pay","Other Information","Net Pay Distribution","Tax Information","Rate Information","Other Auth. Information";
        RightSide: Option ,Earnings,"Gross to Net Pay","Other Information","Net Pay Distribution","Tax Information","Rate Information","Other Auth. Information";
        WhichColumn: Option ,Left,Right;
        Text000: Label 'Last Check No. must not be blank';
        Text001: Label 'Last Check No. must include at least one digit, so that it can be incremented.';
        Text002: Label 'Now testing for errors.';
        Text003: Label '%1 cannot be greater than zero. Review pay for %2 %3.';
        Text004: Label 'VOID ';
        Text005: Label 'REMITTANCE ADVICE ONLY';
        Text006: Label 'NON-NEGOTIABLE';
        Text007: Label 'The total of the amounts printed on the check stub for %1 %2 do not match the check amount.';
        Text007a: Label '  Either the Net Pay does not balance the Earnings minus Deductions, or some Earnings or Deductions amount is not printing when it should be.';
        Text008: Label '%1 results in a number text which is to long.';
        Text009: Label 'Pay Cycle Code: %1 - Pay Cycle Term must be selected for processing.';
        Text010: Label 'Pay Cycle Code: %1 - Pay Cycle Period must be selected for processing.';
        Text011: Label 'Bank Payment Type cannot be blank for Employee: %1  Payroll Control Code: %2';
        Text012: Label 'Recurring Method cannot be blank for Employee: %1  Payroll Control Code: %2';
        Text013: Label 'Recurring Frequency cannot be blank for Employee: %1  Payroll Control Code: %2';
        Text014: Label 'No payments were printed based on the Bank Account and other settings selected.';
        Text015: Label 'Employee %1 has a Payroll Status of Invalid.';
        Text016: Label 'The %1 for Employee %2 in the %3\ indicates that the Employee did not successfully complete calculation.\\Please recalculate the Employee and resolve any calculation errors.';
        Text017: Label 'Employee %1 has Calculation Errors that must be resolved before checks can be printed.';
        Text018: Label 'Employee %1 has an %2 of %3 that is not synchronized.';
        Text019: Label '____________________________________';
        LitText0: Label 'ZERO';
        LitText1: Label 'ONE';
        LitText2: Label 'TWO';
        LitText3: Label 'THREE';
        LitText4: Label 'FOUR';
        LitText5: Label 'FIVE';
        LitText6: Label 'SIX';
        LitText7: Label 'SEVEN';
        LitText8: Label 'EIGHT';
        LitText9: Label 'NINE';
        LitText10: Label 'TEN';
        LitText11: Label 'ELEVEN';
        LitText12: Label 'TWELVE';
        LitText13: Label 'THIRTEEN';
        LitText14: Label 'FOURTEEN';
        LitText15: Label 'FIFTEEN';
        LitText16: Label 'SIXTEEN';
        LitText17: Label 'SEVENTEEN';
        LitText18: Label 'EIGHTEEN';
        LitText19: Label 'NINETEEN';
        LitText20: Label 'TWENTY';
        LitText30: Label 'THIRTY';
        LitText40: Label 'FORTY';
        LitText50: Label 'FIFTY';
        LitText60: Label 'SIXTY';
        LitText70: Label 'SEVENTY';
        LitText80: Label 'EIGHTY';
        LitText90: Label 'NINETY';
        LitText100: Label 'HUNDRED';
        LitText1000: Label 'THOUSAND';
        LitText1000000: Label 'MILLION';
        LitText1000000000: Label 'BILLION';
        LitTextAnd: Label 'AND';
        LitTextDollars: Label 'DOLLARS';
        SingleEmployee: Boolean;
        PayrollStatus: Option "N/A",Valid,"Valid-Warnings",Invalid;
        PayrollValidation: Codeunit "Payroll Validation";
        SectionEarnings: Boolean;
        SectionGrossToNetPay: Boolean;
        SectionOtherInformation: Boolean;
        SectionNetPayDistribution: Boolean;
        ItemsProcessed: Integer;
        PageNo: Integer;
        LineNo: Integer;
        SectionNo: Integer;
        SelectPayCycles: Option "Select Pay Cycles";
        SavedFilterGroup: Integer;
        EmployeePayDistribution: Record "Employee Pay Distribution";
        MICR: Code[50];
        SignatureLine1: Text[50];
        SignatureLine2: Text[50];
        CheckSignature: Record "Check Signature";
        ResetOnTopOfPage: Boolean;
        PrintPayStub1and2H1: Boolean;
        PrintPayStub3and4H1: Boolean;
        PrintPayStub3and4H2: Boolean;
        PrintPayStub3and4H3: Boolean;
        PrintPayStub3and4B1: Boolean;
        PrintPayStub5and6H1: Boolean;
        PrintPayStub5and6H2: Boolean;
        PrintPayStub5and6H3: Boolean;
        PrintPayStub5and6H4: Boolean;
        PrintPayStub5and6H5: Boolean;
        PrintPayStub5and6B1: Boolean;
        PrintPayStub5and6B2: Boolean;
        PrintPayStub5and6B3: Boolean;
        PrintPayStub5and6B4: Boolean;
        PrintPayStub7H1: Boolean;
        PrintPayStub7B1: Boolean;
        TempComAddr: Text;
        TempChar: Char;
        TempText: Text;

    [Scope('Internal')]
    procedure FindNextCategory(WhichSide: Option ,Left,Right): Integer
    var
        i: Integer;
    begin
        for i := 1 to 7 do
            if ((i mod 2 = 1) and (WhichSide = WhichSide::Left)) or
               ((i mod 2 = 0) and (WhichSide = WhichSide::Right))
            then
                if PayCheckBufferStatus[i] = PayCheckBufferStatus[i] ::"Not Started" then
                    if AnyInCategory[i, 1] or AnyInCategory[i, 2] or AnyInCategory[i, 3] then
                        if PayCheckBuffer[i].FindFirst() then
                            exit(i);

        exit(99);
    end;

    [Scope('Internal')]
    procedure FormatNumberText(var NumberText: array[2] of Text[250]; Number: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NumberTextIndex: Integer;
    begin
        Clear(NumberText);
        NumberTextIndex := 1;
        NumberText[1] := '****';

        if Number < 1 then
            AddToNumberText(NumberText, NumberTextIndex, PrintExponent, LitText0)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := Number div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNumberText(NumberText, NumberTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNumberText(NumberText, NumberTextIndex, PrintExponent, LitText100);
                end;
                if Tens >= 2 then begin
                    AddToNumberText(NumberText, NumberTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNumberText(NumberText, NumberTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNumberText(NumberText, NumberTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNumberText(NumberText, NumberTextIndex, PrintExponent, ExponentText[Exponent]);
                Number := Number - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        AddToNumberText(NumberText, NumberTextIndex, PrintExponent, LitTextAnd);
        AddToNumberText(NumberText, NumberTextIndex, PrintExponent, Format(Number * 100) + '/100');
        if BankAcc2."Currency Code" = '' then
            AddToNumberText(NumberText, NumberTextIndex, PrintExponent, LitTextDollars) // USD
        else
            AddToNumberText(NumberText, NumberTextIndex, PrintExponent, BankAcc2."Currency Code");
    end;

    [Scope('Internal')]
    procedure AddToNumberText(var NumberText: array[2] of Text[250]; var NumberTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while ParagraphHandling.StringPrintLength(NumberText[NumberTextIndex] + ' ' + AddText, 10) > 172 do begin
            NumberTextIndex := NumberTextIndex + 1;
            if NumberTextIndex > ArrayLen(NumberText) then
                Error(Text008, AddText);
        end;

        NumberText[NumberTextIndex] := DelChr(NumberText[NumberTextIndex] + ' ' + AddText, '<');
    end;

    [Scope('Internal')]
    procedure InitTextVar()
    begin
        OnesText[1] := LitText1;
        OnesText[2] := LitText2;
        OnesText[3] := LitText3;
        OnesText[4] := LitText4;
        OnesText[5] := LitText5;
        OnesText[6] := LitText6;
        OnesText[7] := LitText7;
        OnesText[8] := LitText8;
        OnesText[9] := LitText9;
        OnesText[10] := LitText10;
        OnesText[11] := LitText11;
        OnesText[12] := LitText12;
        OnesText[13] := LitText13;
        OnesText[14] := LitText14;
        OnesText[15] := LitText15;
        OnesText[16] := LitText16;
        OnesText[17] := LitText17;
        OnesText[18] := LitText18;
        OnesText[19] := LitText19;

        TensText[1] := '';
        TensText[2] := LitText20;
        TensText[3] := LitText30;
        TensText[4] := LitText40;
        TensText[5] := LitText50;
        TensText[6] := LitText60;
        TensText[7] := LitText70;
        TensText[8] := LitText80;
        TensText[9] := LitText90;

        ExponentText[1] := '';
        ExponentText[2] := LitText1000;
        ExponentText[3] := LitText1000000;
        ExponentText[4] := LitText1000000000;
    end;

    [Scope('Internal')]
    procedure SetPayrollJnlLine(NewPayrollJnlLine: Record "Payroll Journal Line")
    begin
        PayrollJnlLine := NewPayrollJnlLine;
    end;

    [Scope('Internal')]
    procedure CheckEmployerNo()
    var
        PayrollJournalLine: Record "Payroll Journal Line";
        EmployeeNo: Code[20];
    begin
        if EmployeeNo <> NetPayPayrollJnlLine2."Employee No." then begin
            EmployeeNo := NetPayPayrollJnlLine2."Employee No.";
            PayrollJnlLine.Reset;
            PayrollJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Employee No.");
            PayrollJnlLine.SetRange("Employee No.", EmployeeNo);
            PayrollJnlLine.SetRange("Journal Batch Name", NetPayPayrollJnlLine2."Journal Batch Name");
            PayrollJnlLine.SetRange("Journal Template Name", NetPayPayrollJnlLine2."Journal Template Name");
            if PayrollJnlLine.FindFirst() then begin
                EmployerNo := PayrollJnlLine."Employer No.";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure SetSingleEmployee(SetSingleEmp: Boolean)
    begin
        if SetSingleEmp then
            SingleEmployee := true
        else
            SingleEmployee := false;
    end;

    [Scope('Internal')]
    procedure DeletePayCheckJnl()
    var
        PayCheckJnl: Record "Payroll Check Jnl";
    begin
        with PayCheckJnl do begin
            SetCurrentKey("Journal Template Name", "Journal Batch Name", "Employee No.");
            SetRange("Journal Template Name", NetPayPayrollJnlLine2."Journal Template Name");
            SetRange("Journal Batch Name", NetPayPayrollJnlLine2."Journal Batch Name");
            SetRange("Employee No.", NetPayPayrollJnlLine2."Employee No.");
            if FindFirst then
                Delete(true);
        end;
    end;

    [Scope('Internal')]
    procedure WritePayCheckJnl()
    var
        PayCheckPrintBuffer: Record "Pay Check Print Buffer";
        PayCheckJnl: Record "Payroll Check Jnl";
        PayCheckJnlDetails: Record "Payroll Check Jnl Details";
    begin
        with PayCheckJnl do begin
            "Journal Template Name" := NetPayPayrollJnlLine2."Journal Template Name";
            "Journal Batch Name" := NetPayPayrollJnlLine2."Journal Batch Name";
            "Employee No." := NetPayPayrollJnlLine2."Employee No.";
            "Employer No." := NetPayPayrollJnlLine2."Employer No.";
            "Posting Date" := NetPayPayrollJnlLine."Posting Date";
            "Bank Account" := BankAcc2."No.";
            "Check To" := CheckToAddr[1];
            "Check Amount" := CheckAmount;
            "Check No." := NetPayPayrollJnlLine."Document No.";
            "Remittance Advice Only" := RemittanceAdvicesOnly;
            "Include Rep. Auth Info" := IncludeTaxInfo;
            "Include Rate Info" := IncludeRateInfo;
            Insert;
        end;
        with PayCheckPrintBuffer do begin
            SetCurrentKey("Check Stub Section", "Check Stub Sequence");
            if FindSet then begin
                repeat
                    PayCheckJnlDetails.Init;
                    PayCheckJnlDetails."Journal Template Name" := PayCheckJnl."Journal Template Name";
                    PayCheckJnlDetails."Journal Batch Name" := PayCheckJnl."Journal Batch Name";
                    PayCheckJnlDetails."Employee No." := PayCheckJnl."Employee No.";
                    PayCheckJnlDetails."Check Stub Section" := "Check Stub Section";
                    PayCheckJnlDetails."Check Stub Sequence" := "Check Stub Sequence";
                    PayCheckJnlDetails."Payroll Control Type" := "Payroll Control Type";
                    PayCheckJnlDetails."Payroll Control Name" := "Payroll Control Name";
                    PayCheckJnlDetails."G/L Post Type" := "G/L Post Type";
                    PayCheckJnlDetails."What To Print" := "What To Print";
                    PayCheckJnlDetails.Amount := Amount;
                    PayCheckJnlDetails."YTD Amount" := "YTD Amount";
                    PayCheckJnlDetails.Balance := Balance;
                    PayCheckJnlDetails.Hours := Hours;
                    PayCheckJnlDetails."Filing Status Code" := "Filing Status Code";
                    PayCheckJnlDetails.Allowances := Allowances;
                    PayCheckJnlDetails."Extra Withholding" := "Extra Withholding";
                    PayCheckJnlDetails."Credits/Other Deps." := "Credits/Other Deps.";
                    PayCheckJnlDetails."Income Tax Exempt" := "Income Tax Exempt";
                    PayCheckJnlDetails."Distribution Type" := "Distribution Type";
                    PayCheckJnlDetails."Distribution Bank Account No." := "Distribution Bank Account No.";
                    PayCheckJnlDetails."Total Credits Claimed" := "Total Credits Claimed";
                    PayCheckJnlDetails."Annual Deduction" := "Annual Deduction";
                    PayCheckJnlDetails."Other Annual Credits" := "Other Annual Credits";
                    PayCheckJnlDetails.Insert;
                until Next = 0;
            end;
        end;
    end;

    local procedure BankAcc2NoOnAfterValidate()
    begin
        if BankAcc2."No." <> '' then begin
            BankAcc2.Get(BankAcc2."No.");
            BankAcc2.TestField("Last Check No.");
            RemittanceAdvicesOnly := false;
            UseCheckNo := BankAcc2."Last Check No.";
        end;
    end;

    local procedure RemittanceAdvicesOnlyOnAfterVa()
    begin
        if BankAcc2."No." <> '' then begin
            BankAcc2.Get(BankAcc2."No.");
            if RemittanceAdvicesOnly then begin
                BankAcc2.TestField("Last Remittance Advice No.");
                UseCheckNo := BankAcc2."Last Remittance Advice No.";
            end else begin
                BankAcc2.TestField("Last Check No.");
                UseCheckNo := BankAcc2."Last Check No.";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure IsSectionEarnings(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::Earnings then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionGrossToNetPay(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Gross to Net Pay" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionOtherInformation(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Other Information" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionNetPayDistribution(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Net Pay Distribution" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionTaxInformation(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Tax Information" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionRateInformation(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Rate Information" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure IsSectionOtherAuthInformation(locPayCheckBuffer: Record "Pay Check Print Buffer") InSection: Boolean
    begin
        if locPayCheckBuffer."Check Stub Section" = locPayCheckBuffer."Check Stub Section"::"Other Auth. Information" then
            exit(true)
        else
            exit(false);
    end;

    [Scope('Internal')]
    procedure GetFilterGroup(): Integer
    begin
        exit(100);
    end;

    [Scope('Internal')]
    procedure SetSignatureLines(pBankAcc: Record "Bank Account"; pAmount: Decimal)
    var
        locCheckSignature: Record "Check Signature";
    begin
        Clear(CheckSignature);
        SignatureLine1 := '';
        SignatureLine2 := '';

        with locCheckSignature do begin
            Reset;
            SetRange("Bank Account No.", pBankAcc."No.");
            if FindSet(false, false) then begin
                repeat
                    if (("From Amount" = 0) and ("To Amount" = 0)) or
                       ((pAmount >= "From Amount") and (pAmount <= "To Amount")) then begin

                        SignatureLine1 := '';
                        SignatureLine2 := '';
                        if "Print Signature Line 1" then
                            SignatureLine1 := Text019;
                        if "Print Signature Line 2" then
                            SignatureLine2 := Text019;

                        CalcFields("Pre-printed Signature 1", "Pre-printed Signature 2");
                        if CheckSignature.Get(pBankAcc."No.", "Line No.") then begin
                            if "Pre-printed Signature 1".HasValue then
                                CheckSignature.CalcFields("Pre-printed Signature 1");
                            if "Pre-printed Signature 2".HasValue then
                                CheckSignature.CalcFields("Pre-printed Signature 2");
                        end;
                    end;
                until (Next = 0) or (CheckSignature."Bank Account No." <> '');
            end;
        end;
    end;
}

