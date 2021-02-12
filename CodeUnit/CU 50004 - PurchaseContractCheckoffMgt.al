codeunit 50004 "Purchase Contract Checkoff Mgt"
{
    Permissions = TableData "Vendor Ledger Entry" = rm;

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure GetItemWt(ItemNo: Code[20]; var retGrossWt: Decimal; var retNetWt: Decimal)
    var
        recItem: Record Item;
        recRuppSetup: Record "Rupp Setup";
    begin
        retGrossWt := 0;
        retNetWt := 0;

        recItem.Get(ItemNo);
        recRuppSetup.Get();
        if recRuppSetup."Item Wt for Receiving" = recRuppSetup."Item Wt for Receiving"::"Gross Wt" then begin
            recItem.TestField("Gross Weight");
            retGrossWt := recItem."Gross Weight";
        end else begin
            recItem.TestField("Net Weight");
            retNetWt := recItem."Net Weight";
        end;
    end;

    [Scope('Internal')]
    procedure MarkContractLnAsCheckoffUnpaid(GenJnlLn: Record "Gen. Journal Line")
    var
        recVLE: Record "Vendor Ledger Entry";
        recPurchContractLn: Record "Purchase Contract Line";
    begin
        if GenJnlLn."Account Type" = GenJnlLn."Account Type"::Vendor then begin
            if GenJnlLn."Check-off" then begin
                recPurchContractLn.Reset();
                recPurchContractLn.SetRange("Transaction Type", recPurchContractLn."Transaction Type"::Invoice);
                recPurchContractLn.SetRange("Check-off Payment No.", GenJnlLn."Check-off Payment No.");
                if recPurchContractLn.FindSet(true, false) then begin
                    recPurchContractLn.ModifyAll("Check-off Payment No.", '');
                end;
                /*
                recVLE.RESET();
                recVLE.SETRANGE("Check-off", FALSE);
                recVLE.SETRANGE("Check-off Paid", FALSE);
                recVLE.SETRANGE("Check-off Document No.", GenJnlLn."Check-off Document No.");
                IF recVLE.FINDSET(TRUE, FALSE) THEN BEGIN
                  recVLE.MODIFYALL("Check-off Document No.", '');
                END;
                */
            end;
        end;

    end;

    [Scope('Internal')]
    procedure UpdateGenJnlLnCheckOff(var GenJnlLn: Record "Gen. Journal Line"; PurchHdr: Record "Purchase Header")
    var
        recPL: Record "Purchase Line";
        dCheckOffPc: Decimal;
    begin
        //Called from Codeunit 90
        /*
        IF PurchHdr."Document Type" = PurchHdr."Document Type"::Order THEN BEGIN
          dCheckOffPc  := 0;
        
          recPL.RESET();
          recPL.SETRANGE("Document Type", PurchHdr."Document Type");
          recPL.SETRANGE("Document No.", PurchHdr."No.");
          recPL.SETFILTER("Check-off %", '<>%1', 0);
          IF recPL.FINDFIRST() THEN BEGIN
            dCheckOffPc := recPL."Check-off %";
          END;
          IF dCheckOffPc <> 0 THEN BEGIN
            GenJnlLn."Check-off Amount" := (-GenJnlLn.Amount * dCheckOffPc)/100;
          END;
        END;
        */ //Not Needed

    end;

    [Scope('Internal')]
    procedure UpdateCheckoffVLE(GenJnlLn: Record "Gen. Journal Line")
    var
        recVLE: Record "Vendor Ledger Entry";
    begin
        //Called from codeunit 12: Gen. Jnl.-Post Line
        /*
        IF GenJnlLn."Check-off" THEN BEGIN
          recVLE.RESET();
          recVLE.SETRANGE("Check-off Payment No.", GenJnlLn."Check-off Document No.");
          recVLE.SETRANGE("Check-off", FALSE);
          recVLE.SETRANGE("Check-off Paid", FALSE);
          IF recVLE.FINDSET(TRUE,FALSE) THEN BEGIN
            recVLE.MODIFYALL("Check-off Paid", TRUE);
          END;
        END;
        */// NOT NEEDED

    end;
}

