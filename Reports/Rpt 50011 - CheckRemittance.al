report 50011 "Check Remittance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CheckRemittance.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(GenJnlLn; "Gen. Journal Line")
        {
            column(CheckNo; GenJnlLn."Document No.")
            {
            }
            column(CheckDate; GenJnlLn."Document Date")
            {
            }
            column(RecipientNo; gsRecipientNo)
            {
            }
            column(CheckAmount; gdCheckAmt)
            {
            }
            dataitem(VLE1; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("Account No.");
                DataItemTableView = SORTING("Document No.", "Document Type", "Vendor No.");
                column(DocNo1; gsDocumentNo)
                {
                }
                column(DocDate1; gtDocumentDate)
                {
                }
                column(PostingDescr1; gsPostingDesc)
                {
                }
                column(AmtLessDisc1; gdLineAmtLessDisc)
                {
                }
                column(Disc1; gdLineDisc)
                {
                }
                column(Amt1; gdLineAmt)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    gdLineDisc := 0;
                    gsDocumentNo := VLE1."Document No.";
                    gtDocumentDate := VLE1."Posting Date";
                    gsPostingDesc := VLE1.Description;

                    CalcFields("Remaining Amount");

                    gdLineAmt := -ABSMin("Remaining Amount" - "Remaining Pmt. Disc. Possible" - "Accepted Payment Tolerance", "Amount to Apply");

                    if (("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                        ("Remaining Pmt. Disc. Possible" <> 0) and (GenJnlLn."Posting Date" <= "Pmt. Discount Date")) or "Accepted Pmt. Disc. Tolerance" then begin
                        gdLineDisc := -"Remaining Pmt. Disc. Possible";
                        if "Accepted Payment Tolerance" <> 0 then gdLineDisc := gdLineDisc - "Accepted Payment Tolerance";
                    end;
                    gdLineAmtLessDisc := gdLineAmt - gdLineDisc;
                end;

                trigger OnPreDataItem()
                begin
                    if GenJnlLn."Account Type" <> GenJnlLn."Account Type"::Vendor then
                        CurrReport.Break;

                    case ApplyMethod of
                        ApplyMethod::OneLineOneEntry:
                            begin
                                VLE1.SetRange("Document Type", GenJnlLn."Applies-to Doc. Type");
                                VLE1.SetRange("Document No.", GenJnlLn."Applies-to Doc. No.");
                            end;
                        ApplyMethod::MoreLinesOneEntry:
                            begin
                                VLE1.SetRange("Applies-to ID", GenJnlLn."Applies-to ID");
                                if VLE1.Count < giMinRemittances then begin
                                    CurrReport.Break;
                                end;
                            end;
                        else
                            CurrReport.Break;
                    end;
                end;
            }
            dataitem(CLE1; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("Account No.");
                DataItemTableView = SORTING("Document No.", "Document Type", "Customer No.");
                column(DocNo2; gsDocumentNo)
                {
                }
                column(DocDate2; gtDocumentDate)
                {
                }
                column(PostingDescr2; gsPostingDesc)
                {
                }
                column(AmtLessDisc2; gdLineAmtLessDisc)
                {
                }
                column(Disc2; gdLineDisc)
                {
                }
                column(Amt2; gdLineAmt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    gdLineDisc := 0;
                    gsDocumentNo := CLE1."Document No.";
                    gtDocumentDate := CLE1."Posting Date";
                    gsPostingDesc := CLE1.Description;

                    CalcFields("Remaining Amount");

                    gdLineAmt := -ABSMin("Remaining Amount" - "Remaining Pmt. Disc. Possible" - "Accepted Payment Tolerance", "Amount to Apply");

                    if (("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                        ("Remaining Pmt. Disc. Possible" <> 0) and (GenJnlLn."Posting Date" <= "Pmt. Discount Date")) or "Accepted Pmt. Disc. Tolerance" then begin
                        gdLineDisc := -"Remaining Pmt. Disc. Possible";
                        if "Accepted Payment Tolerance" <> 0 then gdLineDisc := gdLineDisc - "Accepted Payment Tolerance";
                    end;
                    gdLineAmtLessDisc := gdLineAmt - gdLineDisc;
                end;

                trigger OnPreDataItem()
                begin
                    if GenJnlLn."Account Type" <> GenJnlLn."Account Type"::Customer then
                        CurrReport.Break;

                    case ApplyMethod of
                        ApplyMethod::OneLineOneEntry:
                            begin
                                CLE1.SetRange("Document Type", GenJnlLn."Applies-to Doc. Type");
                                CLE1.SetRange("Document No.", GenJnlLn."Applies-to Doc. No.");
                            end;
                        ApplyMethod::MoreLinesOneEntry:
                            begin
                                CLE1.SetRange("Applies-to ID", GenJnlLn."Applies-to ID");
                                if CLE1.Count < giMinRemittances then begin
                                    CurrReport.Break;
                                end;
                            end;
                        else
                            CurrReport.Break;
                    end;
                end;
            }
            dataitem(GenJnlLn2; "Gen. Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD("Journal Batch Name"), "Posting Date" = FIELD("Posting Date"), "Document No." = FIELD("Document No.");
                DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                dataitem(VLE2; "Vendor Ledger Entry")
                {
                    DataItemLink = "Document Type" = FIELD("Applies-to Doc. Type"), "Document No." = FIELD("Applies-to Doc. No.");
                    DataItemTableView = SORTING("Document No.", "Document Type", "Vendor No.");
                    column(DocNo3; gsDocumentNo)
                    {
                    }
                    column(DocDate3; gtDocumentDate)
                    {
                    }
                    column(PostingDescr3; gsPostingDesc)
                    {
                    }
                    column(AmtLessDisc3; gdLineAmtLessDisc)
                    {
                    }
                    column(Disc3; gdLineDisc)
                    {
                    }
                    column(Amt3; gdLineAmt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        gdLineDisc := 0;
                        gsDocumentNo := "Document No.";
                        gtDocumentDate := "Posting Date";
                        gsPostingDesc := Description;

                        CalcFields("Remaining Amount");

                        gdLineAmt := -ABSMin("Remaining Amount" - "Remaining Pmt. Disc. Possible" - "Accepted Payment Tolerance", "Amount to Apply");

                        if (("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                            ("Remaining Pmt. Disc. Possible" <> 0) and (GenJnlLn2."Posting Date" <= "Pmt. Discount Date")) or "Accepted Pmt. Disc. Tolerance" then begin
                            gdLineDisc := -"Remaining Pmt. Disc. Possible";
                            if "Accepted Payment Tolerance" <> 0 then gdLineDisc := gdLineDisc - "Accepted Payment Tolerance";
                        end;
                        gdLineAmtLessDisc := gdLineAmt - gdLineDisc;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if GenJnlLn2."Account Type" <> GenJnlLn2."Account Type"::Vendor then
                            CurrReport.Break;
                    end;
                }
                dataitem(CLE2; "Cust. Ledger Entry")
                {
                    DataItemLink = "Document Type" = FIELD("Applies-to Doc. Type"), "Document No." = FIELD("Applies-to Doc. No.");
                    DataItemTableView = SORTING("Document No.", "Document Type", "Customer No.");
                    column(DocNo4; gsDocumentNo)
                    {
                    }
                    column(DocDate4; gtDocumentDate)
                    {
                    }
                    column(PostingDescr4; gsPostingDesc)
                    {
                    }
                    column(AmtLessDisc4; gdLineAmtLessDisc)
                    {
                    }
                    column(Disc4; gdLineDisc)
                    {
                    }
                    column(Amt4; gdLineAmt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        gdLineDisc := 0;
                        gsDocumentNo := "Document No.";
                        gtDocumentDate := "Posting Date";
                        gsPostingDesc := Description;

                        CalcFields("Remaining Amount");

                        gdLineAmt := -ABSMin("Remaining Amount" - "Remaining Pmt. Disc. Possible" - "Accepted Payment Tolerance", "Amount to Apply");

                        if (("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                            ("Remaining Pmt. Disc. Possible" <> 0) and (GenJnlLn2."Posting Date" <= "Pmt. Discount Date")) or "Accepted Pmt. Disc. Tolerance" then begin
                            gdLineDisc := -"Remaining Pmt. Disc. Possible";
                            if "Accepted Payment Tolerance" <> 0 then gdLineDisc := gdLineDisc - "Accepted Payment Tolerance";
                        end;
                        gdLineAmtLessDisc := gdLineAmt - gdLineDisc;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if GenJnlLn2."Account Type" <> GenJnlLn2."Account Type"::Customer then
                            CurrReport.Break;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if ApplyMethod <> ApplyMethod::Payment then begin
                        CurrReport.Break();
                    end;
                    SetFilter("Line No.", '<>%1', GenJnlLn."Line No.");
                end;
            }

            trigger OnAfterGetRecord()
            var
                recGJLn: Record "Gen. Journal Line";
                sRecipientName: Text[50];
                recVLE: Record "Vendor Ledger Entry";
                recCLE: Record "Cust. Ledger Entry";
            begin
                sRecipientName := GetRecipientName("Account Type", "Account No.");
                gsRecipientNo := "Account No." + ': ' + sRecipientName;
                gdCheckAmt := Amount;

                if "Applies-to Doc. No." <> '' then begin
                    ApplyMethod := ApplyMethod::OneLineOneEntry
                end else begin
                    if "Applies-to ID" <> '' then begin
                        ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                        case GenJnlLn."Account Type" of
                            GenJnlLn."Account Type"::Vendor:
                                begin
                                    recVLE.Reset();
                                    recVLE.SetRange("Applies-to ID", "Applies-to ID");
                                    if recVLE.Count < giMinRemittances then begin
                                        CurrReport.Skip();
                                    end;
                                end;
                            GenJnlLn."Account Type"::Customer:
                                begin
                                    recCLE.Reset();
                                    recCLE.SetRange("Applies-to ID", "Applies-to ID");
                                    if recCLE.Count < giMinRemittances then begin
                                        CurrReport.Skip();
                                    end;
                                end;
                        end;

                    end else begin
                        ApplyMethod := ApplyMethod::Payment;
                        recGJLn.Reset();
                        recGJLn.SetRange("Journal Template Name", "Journal Template Name");
                        recGJLn.SetRange("Journal Batch Name", "Journal Batch Name");
                        recGJLn.SetRange("Document Type", "Document Type");
                        recGJLn.SetRange("Document No.", "Document No.");
                        recGJLn.SetRange("Posting Date", "Posting Date");
                        recGJLn.SetFilter("Line No.", '<>%1', "Line No.");
                        if recGJLn.Count >= giMinRemittances then begin
                            if recGJLn.FindFirst() then begin
                                sRecipientName := GetRecipientName(recGJLn."Account Type", recGJLn."Account No.");
                                gsRecipientNo := recGJLn."Account No." + ': ' + sRecipientName;
                                gdCheckAmt := -Amount;
                            end;
                        end else begin
                            CurrReport.Break();
                        end;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SetRange("Check Printed", true);

                if giMinRemittances > 1 then
                    SetRange("Applies-to Doc. No.", '');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Min. No. of Remittances"; giMinRemittances)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        //giMinRemittances := 2;
    end;

    var
        giMinRemittances: Integer;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        gsDocumentNo: Code[20];
        gtDocumentDate: Date;
        gsPostingDesc: Text[50];
        gdLineDisc: Decimal;
        gdLineAmt: Decimal;
        gdLineAmtLessDisc: Decimal;
        gsRecipientNo: Text[80];
        gdCheckAmt: Decimal;

    [Scope('Internal')]
    procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) < Abs(Decimal2) then
            exit(Decimal1);
        exit(Decimal2);
    end;

    [Scope('Internal')]
    procedure GetRecipientName(AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccNo: Code[20]) retRecipientName: Text[50]
    var
        recCust: Record Customer;
        recVendor: Record Vendor;
    begin
        retRecipientName := '';

        case AccType of
            //G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner
            AccType::Customer:
                begin
                    recCust.Get(AccNo);
                    retRecipientName := recCust.Name;
                end;
            AccType::Vendor:
                begin
                    recVendor.Get(AccNo);
                    retRecipientName := recVendor.Name;
                end;
        end;
    end;
}

