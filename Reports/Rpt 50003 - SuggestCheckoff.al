report 50003 "Suggest Check-off"
{
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(InvContractLn; "Purchase Contract Line")
        {
            DataItemTableView = WHERE ("Transaction Type" = CONST (Invoice));
            RequestFilterFields = "Transaction Date";

            trigger OnAfterGetRecord()
            begin
                Dlg.Update();
                if "Check-off Payment No." = '' then begin
                    if OkToCheckOff(InvContractLn) then begin
                        gdCheckOffAmt += "Check-off Amount";
                        "Check-off Payment No." := gsCheckoffPmtNo;
                        Modify();
                        giCnt += 1;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if giCnt > 0 then begin
                    if gdCheckOffAmt <> 0 then begin
                        CreateJnlLine(gdCheckOffAmt);
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Dlg.Close();
    end;

    trigger OnPreReport()
    var
        recGenJnlBatch: Record "Gen. Journal Batch";
        NoSerisMgt: Codeunit NoSeriesManagement;
        recGenJnlLn: Record "Gen. Journal Line";
        recVendor: Record Vendor;
    begin
        if InvContractLn.GetFilter("Transaction Date") = '' then
            Error('Please enter a Transaction Date filter');

        if gsTemplateName = '' then
            Error('Template name cannot be blank');

        if gsBatchName = '' then
            Error('Batch Name cannot be blank');

        recGenJnlLn.Reset();
        recGenJnlLn.SetRange("Journal Template Name", gsTemplateName);
        recGenJnlLn.SetRange("Journal Batch Name", gsBatchName);
        if recGenJnlLn.FindFirst() then
            Error('There are lines in the journal. Please clear them and try again');

        recGenJnlBatch.Get(gsTemplateName, gsBatchName);
        recGenJnlBatch.TestField("No. Series");
        gsDocNo := NoSerisMgt.GetNextNo(recGenJnlBatch."No. Series", WorkDate, false);

        giCnt := 0;
        RuppSetup.Get();
        RuppSetup.TestField("Check-off Vendor No.");
        if not recVendor.Get(RuppSetup."Check-off Vendor No.") then
            Error('Vendor %1 is set up for Check-off in Rupp Setup, but does not exist');

        RuppSetup.TestField("Check-off Bal. Account Type");
        RuppSetup.TestField("Check-off Bal. Account No.");
        RuppSetup.TestField("Check-off Bank Payment Type");
        RuppSetup.TestField("Check-off Payment Nos");

        //Dlg.OPEN(Text01, "Vendor Ledger Entry"."Entry No.");
        Dlg.Open(Text01, InvContractLn."Contract No.", InvContractLn."Line No.");
        giLineNo := 10000;

        gsCheckoffPmtNo := NoSerisMgt.GetNextNo(RuppSetup."Check-off Payment Nos", WorkDate, true);//FALSE);
    end;

    var
        gsTemplateName: Code[10];
        gsBatchName: Code[10];
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        gsDocNo: Code[20];
        giCnt: Integer;
        gdCheckOffAmt: Decimal;
        RuppSetup: Record "Rupp Setup";
        Dlg: Dialog;
        Text01: Label 'Processing Contract Line: #1########  #2########';
        giLineNo: Integer;
        gsCheckoffPmtNo: Code[20];

    [Scope('Internal')]
    procedure SetJnlTemplBatch(TemplateName: Code[10]; BatchName: Code[10])
    begin
        gsTemplateName := TemplateName;
        gsBatchName := BatchName;
    end;

    [Scope('Internal')]
    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine := NewGenJnlLine;
    end;

    [Scope('Internal')]
    procedure OkToCheckOff(PurchContractLn: Record "Purchase Contract Line") retOK: Boolean
    begin
        retOK := true;
    end;

    [Scope('Internal')]
    procedure CreateJnlLine(CheckOffAmt: Decimal)
    var
        recGenJnlLn: Record "Gen. Journal Line";
    begin
        recGenJnlLn.Init();
        recGenJnlLn."Journal Template Name" := gsTemplateName;
        recGenJnlLn."Journal Batch Name" := gsBatchName;
        recGenJnlLn."Line No." := giLineNo;
        recGenJnlLn.Validate("Posting Date", WorkDate);
        recGenJnlLn.Validate("Document Type", recGenJnlLn."Document Type"::Payment);
        recGenJnlLn.Validate("Document No.", gsDocNo);
        recGenJnlLn.Validate("Account Type", recGenJnlLn."Account Type"::Vendor);
        recGenJnlLn.Validate("Account No.", RuppSetup."Check-off Vendor No.");
        recGenJnlLn.Validate(Amount, gdCheckOffAmt);
        recGenJnlLn.Validate("Bal. Account Type", RuppSetup."Check-off Bal. Account Type");
        recGenJnlLn.Validate("Bal. Account No.", RuppSetup."Check-off Bal. Account No.");
        recGenJnlLn.Validate("Bank Payment Type", RuppSetup."Check-off Bank Payment Type");
        recGenJnlLn.Validate("Check-off", true);
        recGenJnlLn."Check-off Payment No." := gsCheckoffPmtNo;
        recGenJnlLn.Insert(true);
    end;
}

