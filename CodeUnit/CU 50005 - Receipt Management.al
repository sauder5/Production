//SOC-SC 08-06-15
//  Added code to populate Contract Line's Vomotoxin Test Result from Receipt Header

//SOC-SC 08-09-15
//  Populate Unit Discount fields

//RSI-KS 05-31-19 
//  Add routines to support Production Lots / Scales Tickets / Settlements

codeunit 50005 "Receipt Management"
{
    trigger OnRun()
    begin

    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        recVendor: Record Vendor;
        recRuppSetup: Record "Rupp Setup";
        dUnitPremiumDisc: Decimal;

    procedure ProcessReceipt(VAR Receipt: Record "Receipt Header")
    var
        recPL: Record "Purchase Line";
        recRcptLn: Record "Receipt Line";
        recContractLn: Record "Purchase Contract Line";

    begin
        CheckReceipt(Receipt, recRuppSetup);

        recRcptLn.RESET();
        recRcptLn.SETRANGE("Receipt No.", Receipt."No.");
        IF recRcptLn.FINDSET() THEN BEGIN
            IF NOT CONFIRM('Do you want to process %1 Receipts?', FALSE, recRcptLn.COUNT()) THEN
                EXIT;
        END;

        dUnitPremiumDisc := GetUnitPremiumDisc(Receipt);
        Receipt."Unit Premium/Discount" := dUnitPremiumDisc;
        Receipt.MODIFY();
        COMMIT;

        InsertContractLine(Receipt);

        recContractLn.RESET();
        //recContractLn.SETRANGE("Contract No.", Receipt."Contract No.");
        recContractLn.SETRANGE("Transaction Type", recContractLn."Transaction Type"::Receipt);
        recContractLn.SETRANGE("Receipt No.", Receipt."No.");
        IF recContractLn.FINDSET() THEN BEGIN
            REPEAT
                PostContractLine(recContractLn);
            UNTIL recContractLn.NEXT = 0;  //Could be multiple lines for different Vendors, in case of a 'split' receipt
        END;

        //LogRelationEntry(Receipt);
        Receipt.Status := Receipt.Status::Processed;
        Receipt.MODIFY();
        PostReceipt(Receipt);
    END;

    Procedure CheckReceipt(Receipt: Record "Receipt Header"; VAR recRuppSetup: Record "Rupp Setup")
    var
        recRcptLn: Record "Receipt Line";
        recItem: Record Item;
        recItemTracking: Record "Item Tracking Code";
        recLoc: Record Location;
        recContract: record "Purchase Contract Header";

    begin
        IF Receipt.Status = Receipt.Status::Processed THEN
            ERROR('Status is already Processed');

        recRcptLn.RESET();
        recRcptLn.SETRANGE("Receipt No.", Receipt."No.");
        recRcptLn.SETRANGE(Received, FALSE);
        IF NOT recRcptLn.FINDFIRST() THEN
            ERROR('No lines to process');
        recRcptLn.SETRANGE(Received);

        recRcptLn.SETRANGE("Item No.", '');
        IF recRcptLn.FINDFIRST() THEN
            ERROR('Please enter Item No. on all lines and try again');
        recRcptLn.SETRANGE("Item No.");

        recRcptLn.SETRANGE(Quantity, 0);
        IF recRcptLn.FINDFIRST() THEN
            ERROR('Quantity cannot be zero on the lines');
        recRcptLn.SETRANGE(Quantity);

        recRcptLn.SETRANGE("Vendor No.", '');
        IF recRcptLn.FINDFIRST() THEN
            ERROR('Please enter Vendor No. on all lines and try again');
        recRcptLn.SETRANGE("Vendor No.");

        recRcptLn.SETRANGE("Receipt Date", 0D);
        IF recRcptLn.FINDFIRST() THEN
            ERROR('Please enter Receipt Date on all lines and try again');
        recRcptLn.SETRANGE("Receipt Date");

        recRcptLn.SETRANGE("Contract No.", '');
        IF recRcptLn.FINDFIRST() THEN
            ERROR('Please enter Contract No. on all lines and try again');
        recRcptLn.SETRANGE("Contract No.");

        recRcptLn.FINDFIRST();
        recRcptLn.CALCSUMS("Ratio %");
        IF recRcptLn."Ratio %" <> 100 THEN
            ERROR('The Ratio % on all the lines does not add up to 100');

        recRuppSetup.GET();
        recRuppSetup.TESTFIELD("Premium/ Discount Type");
        recRuppSetup.TESTFIELD("Premium/ Discount No.");
        recRuppSetup.TESTFIELD("Premium/ Discount UOM Code");

        recItem.GET(Receipt."Item No.");
        IF recItem."Item Tracking Code" <> '' THEN BEGIN
            recItemTracking.GET(recItem."Item Tracking Code");
            IF recItemTracking."Lot Purchase Inbound Tracking" THEN BEGIN
                Receipt.TESTFIELD("Lot No.");
                recRcptLn.SETRANGE("Lot No.", '');
                IF recRcptLn.FINDFIRST() THEN
                    ERROR('Lot No. is missing on Receipt Lines');

            END;
        END;

        recLoc.GET(Receipt."Location Code");
        IF recLoc."Bin Mandatory" THEN BEGIN
            IF Receipt."Bin Code" = '' THEN BEGIN
                ERROR('Location %1 requires Bin Code. Please enter Bin Code and try again', recLoc.Code);
            END;
        END ELSE BEGIN
            Receipt.TESTFIELD("Bin Code", '');
        END;

        REPEAT
            recContract.GET(Receipt."Contract No.");
            IF (recContract."Delivery Start Date" <> 0D) THEN BEGIN
                IF (recRcptLn."Receipt Date" < recContract."Delivery Start Date") THEN
                    ERROR('Receipt Date should not be before the Delivery Start Date of the Contract');
            END;

            IF (recContract."Delivery End Date" <> 0D) THEN BEGIN
                IF (recRcptLn."Receipt Date" > recContract."Delivery End Date") THEN
                    ERROR('Receipt Date should not be after the Delivery End Date of the Contract');
            END;
        UNTIL recRcptLn.NEXT = 0;
    End;

    Procedure InsertContractLine(ReceiptHdr: Record "Receipt Header")
    var
        recRcptLn: Record "Receipt Line";
        recContractLn: Record "Purchase Contract Line";
        iLineNo: Integer;

    begin
        recRcptLn.RESET();
        recRcptLn.SETRANGE("Receipt No.", ReceiptHdr."No.");
        IF recRcptLn.FINDSET() THEN BEGIN
            REPEAT
                recRcptLn.CALCFIELDS("Unit Premium/Discount");
                recContractLn.RESET();
                recContractLn.SETRANGE("Contract No.", recRcptLn."Contract No.");
                recContractLn.SETRANGE("Transaction Type", recContractLn."Transaction Type"::Receipt);
                IF recContractLn.FINDLAST() THEN BEGIN
                    iLineNo := recContractLn."Line No." + 10000;
                END ELSE BEGIN
                    iLineNo := 10000;
                END;
                recContractLn.INIT();
                recContractLn."Contract No." := recRcptLn."Contract No.";
                recContractLn."Transaction Type" := recContractLn."Transaction Type"::Receipt;
                recContractLn."Transaction Date" := TODAY;
                recContractLn."Line No." := iLineNo;
                recContractLn.Quantity := recRcptLn.Quantity;
                recContractLn."Receipt No." := recRcptLn."Receipt No.";
                recContractLn."Receipt Line No." := recRcptLn."Line No.";
                recContractLn."Scale Ticket No." := recRcptLn."Ticket No.";
                recContractLn."Receipt Date" := recRcptLn."Receipt Date";
                recContractLn.Moisture := ReceiptHdr."Moisture Test Result";
                recContractLn.Splits := ReceiptHdr."Splits Test Result";
                recContractLn."Test Weight" := ReceiptHdr."Test Weight Result";
                recContractLn."Vomitoxin Test Result" := ReceiptHdr."Vomitoxin Test Result"; //SOC-SC 08-06-15
                recContractLn."Shrink %" := ReceiptHdr."Shrink %";
                recContractLn."Recd. Gross Qty." := recRcptLn."Gross Qty.";
                recContractLn."Recd. Shrink Qty." := recRcptLn."Shrink Qty.";
                recContractLn."Recd. Net Qty." := recRcptLn.Quantity;
                recContractLn."Recd. Lot No." := recRcptLn."Lot No.";
                recContractLn."Recd. Location Code" := recRcptLn."Location Code";
                recContractLn."Recd. Bin Code" := recRcptLn."Bin Code";
                recContractLn."Recd. Unit Premium/Discount" := recRcptLn."Unit Premium/Discount";
                recContractLn."Posting Date" := ReceiptHdr."Receipt Date";
                recContractLn.VALIDATE("Recd/Settled Qty. Invoiced", 0);

                //SOC-SC 08-09-15
                recContractLn."Recd. Splits Unit Premium" := ReceiptHdr."Splits Unit Premium";
                recContractLn."Recd. Test Weight Unit Disc" := ReceiptHdr."Test Weight Unit Discount";
                recContractLn."Recd. Vomitoxin Unit Discount" := ReceiptHdr."Vomitoxin Unit Discount";
                recContractLn."Recd. Seed Unit Premium" := ReceiptHdr."Seed Unit Premium";
                recContractLn."Recd. Splits Premium Amount" := ReceiptHdr."Splits Unit Premium" * recRcptLn.Quantity;
                recContractLn."Recd. Test Weight Disc Amount" := ReceiptHdr."Test Weight Unit Discount" * recRcptLn.Quantity;
                recContractLn."Recd. Vomitoxin Disc Amount" := ReceiptHdr."Vomitoxin Unit Discount" * recRcptLn.Quantity;
                recContractLn."Recd. Seed Premium Amount" := ReceiptHdr."Seed Unit Premium" * recRcptLn.Quantity;
                //SOC-SC 08-09-15

                recContractLn.INSERT(TRUE);
            UNTIL recRcptLn.NEXT = 0;
        END;
    End;

    Procedure PostContractLine(recRcvContractLn: Record "Purchase Contract Line")
    var
        recRcvContractLn2: Record "Purchase Contract Line";
        recInvContractLn2: Record "Purchase Contract Line";

        dQtyinv: Decimal;
        dQtyToRcv: Decimal;
        dQtyRecd: Decimal;

    Begin
        recRcvContractLn.TESTFIELD("Transaction Type", recRcvContractLn."Transaction Type"::Receipt);
        recRcvContractLn.TESTFIELD("Purch. Receipt Posted", FALSE);
        dQtyToRcv := recRcvContractLn.Quantity;

        //If there are any invoiced settlement lines that have not been fully received, receive them first
        recInvContractLn2.RESET();
        recInvContractLn2.SETRANGE("Contract No.", recRcvContractLn."Contract No.");
        recInvContractLn2.SETRANGE("Transaction Type", recInvContractLn2."Transaction Type"::Invoice);
        IF recInvContractLn2.FINDSET() THEN BEGIN
            dQtyInv := 0;
            REPEAT
                IF recInvContractLn2."Invoiced Line Qty Yet To Rcv" > 0 THEN BEGIN
                    ReceiveInvoicedLn(recInvContractLn2, dQtyToRcv, dQtyRecd, recRcvContractLn);

                    recInvContractLn2."Invoiced Line Received Qty" += dQtyRecd;
                    recInvContractLn2.UpdateQtyNotRecd();
                    recInvContractLn2."Receipt No." := recRcvContractLn."Receipt No.";
                    recInvContractLn2."Receipt Line No." := recRcvContractLn."Receipt Line No.";
                    recInvContractLn2.MODIFY();
                    dQtyToRcv -= dQtyRecd;
                    dQtyInv += dQtyRecd;
                    LogRelationEntry(recInvContractLn2, recRcvContractLn."Line No.", dQtyRecd);
                END;
            UNTIL (recInvContractLn2.NEXT = 0) OR (dQtyToRcv <= 0);
            recRcvContractLn."Recd/Settled Qty. Invoiced" += dQtyInv;
            recRcvContractLn.UpdateQtyNotInvoiced();
            recRcvContractLn.MODIFY();
        END;

        IF dQtyToRcv > 0 THEN BEGIN
            ReceiveNewLine(recRcvContractLn, dQtyToRcv, recRcvContractLn."Recd. Unit Premium/Discount");
        END;
    END;

    Procedure GetUnitPremiumDisc(VAR Rcpt: Record "Receipt Header") retUnitPremDisc: Decimal
    var
        dUnitCost: Decimal;
        recQualPrem: Record "Commodity Settings";
        opTestType: Option ,Splits,Moisture,"Test Weight",Vomitoxin;

    Begin
        retUnitPremDisc := 0;

        IF Rcpt."Splits Test Result" <> 0 THEN BEGIN
            dUnitCost := GetPremDiscAmtFromTest(Rcpt."Quality Premium Code", opTestType::Splits, Rcpt."Splits Test Result");
            retUnitPremDisc += dUnitCost;
            Rcpt."Splits Unit Premium" := dUnitCost; //SOC-SC 08-09-15
        END;

        IF Rcpt."Test Weight Result" <> 0 THEN BEGIN
            dUnitCost := GetPremDiscAmtFromTest(Rcpt."Quality Premium Code", opTestType::"Test Weight", Rcpt."Test Weight Result");
            retUnitPremDisc -= dUnitCost;
            Rcpt."Test Weight Unit Discount" := -dUnitCost; //SOC-SC 08-09-15
        END;

        IF Rcpt."Vomitoxin Test Result" <> 0 THEN BEGIN
            dUnitCost := GetPremDiscAmtFromTest(Rcpt."Quality Premium Code", opTestType::Vomitoxin, Rcpt."Vomitoxin Test Result");
            retUnitPremDisc -= dUnitCost;
            Rcpt."Vomitoxin Unit Discount" := -dUnitCost; //SOC-SC 08-09-15
        END;

        //SOC-SC 08-09-15
        IF recQualPrem.GET(Rcpt."Quality Premium Code") THEN BEGIN
            Rcpt."Seed Unit Premium" := recQualPrem."Seed Unit Premium";
            retUnitPremDisc += Rcpt."Seed Unit Premium";
        END;
        //SOC-SC 08-09-15
    END;

    Procedure GetPremDiscAmtFromTest(QualityPremiumCode: Code[20]; opTestType: Option ,Splits,Moisture,"Test Weight",Vomitoxin; TestResult: Decimal) retPremDisc: Decimal
    var
        recQualPremLn: Record "Commodity Settings Line";

    Begin
        retPremDisc := 0;
        recQualPremLn.RESET();
        recQualPremLn.SETRANGE("Quality Premium Code", QualityPremiumCode);
        recQualPremLn.SETRANGE("Test Type", opTestType);
        CASE opTestType OF
            opTestType::Splits:
                BEGIN
                    recQualPremLn.SETFILTER("From Result", '<=%1', TestResult);
                    recQualPremLn.SETFILTER("To Result", '>=%1', TestResult);
                    IF recQualPremLn.FINDFIRST() THEN BEGIN
                        retPremDisc := recQualPremLn."Unit Amount";
                    END ELSE BEGIN
                        recQualPremLn.SETRANGE("To Result");
                        IF recQualPremLn.FINDLAST() THEN BEGIN
                            retPremDisc := recQualPremLn."Unit Amount";
                        END;
                    END;
                END;
            opTestType::Moisture:
                BEGIN
                    recQualPremLn.SETFILTER("From Result", '<=%1', TestResult);
                    recQualPremLn.SETFILTER("To Result", '>=%1', TestResult);
                    IF recQualPremLn.FINDFIRST() THEN BEGIN
                        retPremDisc := recQualPremLn."Shrink %";
                    END ELSE BEGIN
                        recQualPremLn.SETRANGE("To Result");
                        IF recQualPremLn.FINDLAST() THEN BEGIN
                            retPremDisc := recQualPremLn."Shrink %";
                        END;
                    END;
                END;
            opTestType::"Test Weight":
                BEGIN
                    recQualPremLn.SETFILTER("To Result", '<=%1', TestResult);
                    recQualPremLn.SETFILTER("From Result", '>=%1', TestResult);
                    IF recQualPremLn.FINDFIRST() THEN BEGIN
                        retPremDisc := recQualPremLn."Unit Amount";
                    END;
                END;
            opTestType::Vomitoxin:
                BEGIN
                    recQualPremLn.SETFILTER("To Result", '>=%1', TestResult);
                    recQualPremLn.SETFILTER("From Result", '<=%1', TestResult);
                    IF recQualPremLn.FINDFIRST() THEN BEGIN
                        retPremDisc := recQualPremLn."Unit Amount";
                    END;
                END;
        END;
    END;

    Procedure ReceiveInvoicedLn(InvContractLn: Record "Purchase Contract Line"; QtyToRecv: Decimal; VAR retQtyRecd: Decimal; RcvContractLn: Record "Purchase Contract Line")
    var
        recPL: Record "Purchase Line";
        recPH: Record "Purchase Header";

    Begin
        recPL.GET(recPL."Document Type"::Order, InvContractLn."Purchase Order No.", InvContractLn."Purchase Order Line No.");
        recPL.TESTFIELD("Unit of Measure Code", InvContractLn."Purch. Unit of Measure Code");

        IF QtyToRecv > InvContractLn."Invoiced Line Qty Yet To Rcv" THEN BEGIN
            QtyToRecv := InvContractLn."Invoiced Line Qty Yet To Rcv";
        END;
        IF QtyToRecv > recPL."Outstanding Quantity" THEN BEGIN
            QtyToRecv := recPL."Outstanding Quantity";
        END;

        recPL."Location Code" := RcvContractLn."Recd. Location Code";
        recPL."Bin Code" := RcvContractLn."Recd. Bin Code";
        recPL."Rcpt No." := RcvContractLn."Receipt No.";
        recPL."Rcpt Line No." := RcvContractLn."Receipt Line No.";
        recPL.VALIDATE("Qty. to Receive", QtyToRecv);
        recPL."Purchase Contract Rct Line No." := RcvContractLn."Line No.";
        recPL.MODIFY();

        recPH.GET(recPH."Document Type"::Order, InvContractLn."Purchase Order No.");
        PostReceivePO(recPH, TRUE, InvContractLn."Posting Date");
        retQtyRecd := QtyToRecv;
    END;

    Procedure ReceiveNewLine(RcvContractLn: Record "Purchase Contract Line"; QtyToRcv: Decimal; UnitPremiumDisc: Decimal)
    var
        recPH: Record "Purchase Header";

    Begin
        CreateNewPO(RcvContractLn, QtyToRcv, RcvContractLn."Posting Date", recPH);
        IF UnitPremiumDisc <> 0 THEN BEGIN
            recRuppSetup.GET();
            CreatePremiumDiscLine(recPH, QtyToRcv, UnitPremiumDisc, recRuppSetup, RcvContractLn, FALSE); //0
        END;
        PostReceivePO(recPH, FALSE, RcvContractLn."Posting Date");
    END;

    Procedure PostReceipt(VAR recReceiptHdr: Record "Receipt Header")
    var
        recPostedRcptHdr: Record "Posted Receipt Header";
        recRcptLn: Record "Receipt Line";
        recPostedRcptLn: Record "Posted Receipt Line";

    begin
        recPostedRcptHdr.INIT();
        recPostedRcptHdr.TRANSFERFIELDS(recReceiptHdr);
        recPostedRcptHdr.INSERT();

        recRcptLn.RESET();
        recRcptLn.SETRANGE("Receipt No.", recReceiptHdr."No.");
        IF recRcptLn.FINDSET() THEN BEGIN
            REPEAT
                recPostedRcptLn.INIT();
                recPostedRcptLn.TRANSFERFIELDS(recRcptLn);
                recPostedRcptLn.INSERT();
            UNTIL recRcptLn.NEXT = 0;
            recRcptLn.DELETEALL();
        END;
        recReceiptHdr.DELETE();
    END;

    Procedure PostReceivePO(VAR PurchHdr: Record "Purchase Header"; Invoice: Boolean; PostingDate: Date)
    Begin
        PurchHdr.Receive := TRUE;
        PurchHdr.Invoice := Invoice;
        IF Invoice THEN BEGIN
            PurchHdr."Vendor Invoice No." := INCSTR(PurchHdr."Vendor Invoice No.");
        END;
        IF PostingDate <> 0D THEN
            PurchHdr.VALIDATE("Posting Date", PostingDate);
        PurchHdr.MODIFY();
        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PurchHdr);
    END;

    Procedure CreatePremiumDiscLine(VAR recPH: Record "Purchase Header"; Qty: Decimal; UnitCost: Decimal; recRuppSetup: Record "Rupp Setup"; ContractLn: Record "Purchase Contract Line"; bInvoice: Boolean)
    var
        cuReleasePurchaseDoc: Codeunit "Release Purchase Document";
        recPL: record "Purchase Line";
        dLineNo: Decimal;

    Begin
        IF (Qty > 0) THEN BEGIN

            IF recPH.Status <> recPH.Status::Open THEN BEGIN
                cuReleasePurchaseDoc.PerformManualReopen(recPH);
            END;

            recPL.RESET();
            recPL.SETRANGE("Document Type", recPH."Document Type");
            recPL.SETRANGE("Document No.", recPH."No.");
            IF recPL.FINDLAST() THEN
                dLineNo := recPL."Line No.";

            recPL.INIT();
            recPL."Document Type" := recPH."Document Type";
            recPL."Document No." := recPH."No.";
            recPL."Line No." := dLineNo + 10000;
            recPL."Buy-from Vendor No." := recPH."Buy-from Vendor No.";
            recPL.VALIDATE(Type, recRuppSetup."Premium/ Discount Type");
            recPL.VALIDATE("No.", recRuppSetup."Premium/ Discount No.");
            IF recPL.Type = recPL.Type::Item THEN
                recPL.VALIDATE("Unit of Measure Code", recRuppSetup."Premium/ Discount UOM Code");

            IF recRuppSetup."Premium/ Discount Description" <> '' THEN
                recPL.Description := recRuppSetup."Premium/ Discount Description";

            recPL.VALIDATE("Location Code", recPH."Location Code");
            recPL.VALIDATE(Quantity, Qty);
            recPL.VALIDATE("Qty. to Receive", Qty);
            IF UnitCost <> 0 THEN BEGIN
                recPL.VALIDATE("Direct Unit Cost", UnitCost);
            END;

            IF bInvoice THEN BEGIN
                recPL.VALIDATE("Qty. to Invoice", Qty);
            END ELSE BEGIN
                recPL.VALIDATE("Qty. to Invoice", 0);
            END;

            recPL."Rcpt No." := ContractLn."Receipt No.";
            recPL."Rcpt Line No." := ContractLn."Receipt Line No.";
            recPL."Purchase Contract No." := ContractLn."Contract No.";
            recPL."Purchase Contract Rct Line No." := ContractLn."Line No.";
            recPL.INSERT(TRUE);
        END;
    END;

    Procedure CreateNewPO(VAR ContractLn: Record "Purchase Contract Line"; Qty: Decimal; PostingDate: Date; VAR recPH: Record "Purchase Header") retRcvd: Boolean
    var
        recPL: Record "Purchase Line";

    Begin
        retRcvd := FALSE;

        recPH.INIT();
        recPH."Document Type" := recPH."Document Type"::Order;
        recPH."No." := '';
        recPH.INSERT(TRUE);
        recPH.VALIDATE("Buy-from Vendor No.", ContractLn."Vendor No.");
        recPH.VALIDATE("Location Code", ContractLn."Recd. Location Code");
        recPH.VALIDATE("Order Date", PostingDate);
        recPH.VALIDATE("Expected Receipt Date", PostingDate);
        recPH.VALIDATE("Posting Date", PostingDate);
        recPH.MODIFY;

        ContractLn.CALCFIELDS("Quality Premium Code", "Check-off %");
        recPL.INIT();
        recPL."Document Type" := recPH."Document Type";
        recPL.VALIDATE("Document No.", recPH."No.");
        recPL.VALIDATE("Line No.", 10000);
        recPL.VALIDATE("Buy-from Vendor No.", ContractLn."Vendor No.");
        recPL.VALIDATE(Type, recPL.Type::Item);
        recPL.VALIDATE("No.", ContractLn."Item No.");
        recPL.VALIDATE("Location Code", ContractLn."Recd. Location Code");
        recPL.VALIDATE("Bin Code", ContractLn."Recd. Bin Code");
        recPL.VALIDATE(Quantity, Qty);
        recPL.VALIDATE("Unit of Measure Code", ContractLn."Purch. Unit of Measure Code");
        recPL.VALIDATE("Qty. to Receive", recPL.Quantity); //recPL.VALIDATE("Direct Unit Cost",
        recPL.VALIDATE("Rcpt No.", ContractLn."Receipt No.");
        recPL."Auto-generating Process" := recPL."Auto-generating Process"::Receipt;
        recPL."Rcpt No." := ContractLn."Receipt No.";
        recPL."Rcpt Line No." := ContractLn."Receipt Line No.";
        recPL."Purchase Contract No." := ContractLn."Contract No.";
        recPL."Purchase Contract Rct Line No." := ContractLn."Line No.";
        recPL.INSERT(TRUE);

        IF ContractLn."Recd. Lot No." <> '' THEN BEGIN
            InsertLotEntry(recPL, ContractLn."Recd. Lot No.", Qty);
        END;

        ContractLn."Purchase Order No." := recPL."Document No.";
        ContractLn."Purchase Order Line No." := recPL."Line No.";
        ContractLn.MODIFY();
    END;

    Procedure InsertLotEntry(PurchLn: Record "Purchase Line"; LotNo: Code[20]; Qty: Decimal)
    var
        recRE: Record "Reservation Entry";
        iEntryNo: Integer;

    Begin
        recRE.RESET();
        recRE.SETRANGE("Source Type", 39);
        recRE.SETRANGE("Source ID", PurchLn."Document No.");
        recRE.SETRANGE("Source Ref. No.", PurchLn."Line No.");
        IF recRE.FINDSET() THEN BEGIN
            IF (recRE.COUNT <> 1) OR (recRE."Lot No." <> LotNo) OR (recRE.Quantity <> Qty) THEN BEGIN
                recRE.DELETEALL();
            END ELSE BEGIN
                EXIT;
            END;
        END;

        recRE.RESET();
        IF recRE.FINDLAST() THEN BEGIN
            iEntryNo := recRE."Entry No." + 1;
        END ELSE BEGIN
            iEntryNo := 1;
        END;
        recRE.INIT();
        recRE."Entry No." := iEntryNo;
        recRE."Item No." := PurchLn."No.";
        recRE."Location Code" := PurchLn."Location Code";
        recRE."Quantity (Base)" := PurchLn."Qty. to Receive (Base)";
        recRE."Reservation Status" := recRE."Reservation Status"::Surplus;
        recRE."Creation Date" := WORKDATE;
        recRE."Source Type" := 39;
        recRE."Source Subtype" := PurchLn."Document Type";
        recRE."Source ID" := PurchLn."Document No.";
        recRE."Source Ref. No." := PurchLn."Line No.";
        recRE."Expected Receipt Date" := WORKDATE;
        recRE."Created By" := USERID;
        recRE.Positive := TRUE;
        recRE."Qty. per Unit of Measure" := PurchLn."Qty. per Unit of Measure";
        recRE.Quantity := PurchLn."Outstanding Quantity";
        recRE."Qty. to Handle (Base)" := recRE."Quantity (Base)";
        recRE."Qty. to Invoice (Base)" := recRE."Quantity (Base)";
        recRE."Lot No." := LotNo;
        recRE."Item Tracking" := recRE."Item Tracking"::"Lot No.";
        recRE.INSERT();
    END;

    Procedure DeletePremiumDiscLineIfExists_(PH: Record "Purchase Header"; RcptLn: Record "Receipt Line"; RuppSetup: Record "Rupp Setup")
    var
        recPL: Record "Purchase Line";

    Begin
        recPL.RESET();
        recPL.SETRANGE("Document Type", PH."Document Type");
        recPL.SETRANGE("Document No.", PH."No.");
        recPL.SETRANGE(Type, RuppSetup."Premium/ Discount Type");
        recPL.SETRANGE("No.", RuppSetup."Premium/ Discount No.");
        recPL.SETRANGE("Rcpt No.", RcptLn."Receipt No.");
        recPL.SETRANGE("Rcpt Line No.", RcptLn."Line No.");
        IF recPL.FINDFIRST() THEN BEGIN
            recPL.DELETE(TRUE);
        END;
    END;

    Procedure LogRelationEntry(InvPurchConLn: Record "Purchase Contract Line"; RcptLineNo: Integer; QtyRecd: Decimal)
    var
        recContractRelation: Record "Contract Rcpt-Invoice Link";
        iEntryNo: Integer;
        dtCreatedDateTime: datetime;

    Begin
        recContractRelation.RESET();
        IF recContractRelation.FINDLAST() THEN BEGIN
            iEntryNo := recContractRelation."Entry No.";
        END;
        dtCreatedDateTime := CURRENTDATETIME;

        iEntryNo += 1;
        recContractRelation.INIT();
        recContractRelation."Entry No." := iEntryNo;
        recContractRelation."Contract No." := InvPurchConLn."Contract No.";
        recContractRelation."Receipt No." := InvPurchConLn."Receipt No.";
        recContractRelation."Receipt Line No." := InvPurchConLn."Receipt Line No.";
        recContractRelation."Contract Receipt Line No." := RcptLineNo;
        recContractRelation."Settlement Line No." := InvPurchConLn."Settled Line No.";
        recContractRelation."Invoice Line No." := InvPurchConLn."Line No.";
        recContractRelation."Created By" := USERID;
        recContractRelation."Created DateTime" := dtCreatedDateTime;
        recContractRelation."Quantity Linked" := QtyRecd;
        recContractRelation.INSERT();
    END;


    Procedure CheckScaleTkt(ProdLot: Code[20]; ScaleTkt: Code[20]) bReturn: Boolean
    var
        recScaleTkt: Record "Scale Ticket Header";
        recProdLot: Record "Production Lot";
        recItem: record Item;
        recItemUOM: record "Item Unit of Measure";

    Begin
        //RSI-KS
        IF recScaleTkt.Status <> recScaleTkt.Status::Open THEN BEGIN
            ERROR('Scale ticket %1 is not open - can not post', ScaleTkt);
            EXIT(FALSE);
        END;

        IF NOT recProdLot.GET(ProdLot) THEN BEGIN
            ERROR('Production Lot %1 does not exist', ProdLot);
            EXIT(FALSE);
        END;

        IF NOT recScaleTkt.GET(ProdLot, ScaleTkt) THEN BEGIN
            ERROR('Scale ticket %1 does not exist for Production Lot %2', ProdLot, ScaleTkt);
            EXIT(FALSE);
        END;

        IF NOT recItem.GET(recProdLot."Item No.") THEN BEGIN
            ERROR('Item number %1 does not exist', recProdLot."Item No.");
            EXIT(FALSE);
        END;

        IF NOT recItemUOM.GET(recProdLot."Item No.", recProdLot."Purchase UOM") THEN BEGIN
            ERROR('Purchase unit of measure of %1 does not exist for item %2', recProdLot."Purchase UOM", recProdLot."Item No.");
            EXIT(FALSE);
        END;

        IF recScaleTkt."Unit Cost" = 0 THEN
            IF NOT CONFIRM('Unit cost for item %1 is zero, are you sure you want to post', FALSE, recItem."No.") THEN
                EXIT(FALSE);

        IF (recItem."Item Tracking Code" > '') AND (recProdLot."Seed Lot # Planted" = '') THEN BEGIN
            ERROR('Seed Lot # is required on the Production Lot screen');
            EXIT(FALSE);
        END;

        IF recScaleTkt."Receipt Date" = 0D THEN BEGIN
            recScaleTkt."Receipt Date" := TODAY;
            recScaleTkt.MODIFY;
        END;

        EXIT(TRUE);
    END;


    Procedure PostScaleTkt(ProdLot: Code[20]; ScaleTkt: Code[20])
    var
        recProdLot: Record "Production Lot";
        recScaleTkt: Record "Scale Ticket Header";
        recItem: Record Item;
        recItemTran: Record "Item Journal Line";
        LineNo: Integer;
        TransID: Code[20];
        recGrowerTkt: Record "Grower Ticket";
        Type: Option Cash,"Futures (New Crop)";

    Begin
        //RSI-KS
        IF recProdLot.GET(ProdLot) THEN;
        IF recScaleTkt.GET(ProdLot, ScaleTkt) THEN;
        IF recItem.GET(recProdLot."Item No.") THEN;

        recItemTran.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        recItemTran.SETFILTER("Journal Template Name", 'ITEM');
        recItemTran.SETFILTER("Journal Batch Name", 'GROWERTKT');
        IF recItemTran.FINDLAST THEN
            LineNo := recItemTran."Line No." + 1000
        ELSE
            LineNo := 1000;

        TransID := NoSeriesMgt.GetNextNo('IJNL-GEN', TODAY(), FALSE);

        recGrowerTkt.SETFILTER("Production Lot No.", ProdLot);
        recGrowerTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        IF recGrowerTkt.FINDSET THEN BEGIN
            REPEAT
                IF NOT recVendor.GET(recGrowerTkt."Vendor No.") THEN
                    CLEAR(recVendor);
                WITH recItemTran DO BEGIN
                    INIT;
                    "Journal Batch Name" := 'GROWERTKT';
                    "Journal Template Name" := 'ITEM';
                    "Line No." := LineNo;
                    "Document No." := TransID;
                    "Entry Type" := "Entry Type"::Purchase;                   //
                    "Document Type" := "Document Type"::"Purchase Receipt";   //
                    VALIDATE("Posting Date", recScaleTkt."Posting Date");
                    VALIDATE("Item No.", recItem."No.");
                    Adjustment := FALSE;
                    VALIDATE("Location Code", recScaleTkt."Location Code");
                    VALIDATE("Bin Code", recScaleTkt."Bin Code");
                    VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", recItem."Global Dimension 2 Code");
                    VALIDATE("Country/Region Code", recVendor."Country/Region Code");
                    VALIDATE(Quantity, recGrowerTkt."Net Qty in Purchase UOM");
                    VALIDATE("Invoiced Quantity", 0);
                    VALIDATE("Invoiced Qty. (Base)", 0);
                    "Unit Cost" := recScaleTkt."Unit Cost";
                    "Unit Cost (ACY)" := "Unit Cost";
                    "Qty. per Unit of Measure" := 1;
                    Amount := ROUND(recScaleTkt."Unit Cost" * recGrowerTkt."Net Qty in Purchase UOM", 0.01);
                    "Document No." := TransID;
                    "Document Line No." := LineNo;
                    "External Document No." := recGrowerTkt."Grower Ticket No.";
                    "Source Code" := 'ITEMJNL';
                    "Source No." := recGrowerTkt."Vendor No.";                 //
                    "Invoice-to Source No." := recGrowerTkt."Vendor No.";
                    "Source Type" := "Source Type"::Vendor;                   //
                    "Value Entry Type" := "Value Entry Type"::"Direct Cost";
                    VALIDATE("Inventory Posting Group", recItem."Inventory Posting Group");
                    VALIDATE("Gen. Prod. Posting Group", recItem."Gen. Prod. Posting Group");
                    VALIDATE("Gen. Bus. Posting Group", recVendor."Gen. Bus. Posting Group");
                    VALIDATE("Item Category Code", recItem."Item Category Code");
                    VALIDATE("Rupp Product Group Code", recItem."Rupp Product Group Code");
                    INSERT;
                    IF recItem."Item Tracking Code" > '' THEN
                        CreateReservation(recItemTran, recProdLot."Seed Lot # Planted");
                END;
                LineNo += 100;
                recGrowerTkt."Transaction ID" := TransID;
                recGrowerTkt.MODIFY;
            UNTIL recGrowerTkt.NEXT = 0;
        END;
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", recItemTran);
        GetTransNos(TransID);

        recGrowerTkt.SETFILTER("Production Lot No.", ProdLot);
        recGrowerTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        recGrowerTkt.MODIFYALL(Status, recGrowerTkt.Status::Posted);
        recGrowerTkt.MODIFYALL("Posting Date", recScaleTkt."Posting Date");

        recScaleTkt.SETFILTER("Production Lot No.", ProdLot);
        recScaleTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        recScaleTkt.MODIFYALL(Status, recScaleTkt.Status::Posted);
        ApplyReceipts(Type::"Futures (New Crop)");
    END;

    Procedure ReverseScaleTkt(ProdLot: Code[20]; ScaleTkt: Code[20])
    var
        recScaleTkt: Record "Scale Ticket Header";
        recProdLot: Record "Production Lot";
        recItem: Record Item;
        recItemTran: Record "Item Journal Line";
        recGrowerTkt: Record "Grower Ticket";
        LineNo: Integer;
        TransID: Code[20];
        recItemLedgerEntry: Record "Item Ledger Entry";

    Begin
        //RSI-KS
        IF recScaleTkt.GET(ProdLot, ScaleTkt) THEN;
        IF recProdLot.GET(ProdLot) THEN;
        IF recItem.GET(recProdLot."Item No.") THEN;

        recItemTran.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        recItemTran.SETFILTER("Journal Template Name", 'ITEM');
        recItemTran.SETFILTER("Journal Batch Name", 'GROWERTKT');
        IF recItemTran.FINDLAST THEN
            LineNo := recItemTran."Line No." + 1000
        ELSE
            LineNo := 1000;

        TransID := NoSeriesMgt.GetNextNo('IJNL-GEN', TODAY(), FALSE);

        recGrowerTkt.SETFILTER("Production Lot No.", ProdLot);
        recGrowerTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        IF recGrowerTkt.FINDSET THEN BEGIN
            REPEAT
                IF NOT recVendor.GET(recGrowerTkt."Vendor No.") THEN
                    CLEAR(recVendor);
                WITH recItemTran DO BEGIN
                    INIT;
                    recItemLedgerEntry.SETFILTER("Document No.", recGrowerTkt."Transaction ID");
                    recItemLedgerEntry.SETFILTER("Source No.", recGrowerTkt."Vendor No.");
                    IF recItemLedgerEntry.FINDSET THEN BEGIN
                        IF recItemLedgerEntry.Quantity <> recItemLedgerEntry."Remaining Quantity" THEN
                            ERROR('Unable to reverse this transaction, part of the quantity has been consumed');
                        "Journal Batch Name" := 'GROWERTKT';
                        "Journal Template Name" := 'ITEM';
                        "Line No." := LineNo;
                        "Document No." := TransID;
                        "Entry Type" := "Entry Type"::Purchase;                   //
                        "Document Type" := "Document Type"::"Purchase Receipt";   //
                        VALIDATE("Posting Date", recScaleTkt."Posting Date");
                        VALIDATE("Item No.", recItem."No.");
                        Adjustment := FALSE;
                        VALIDATE("Location Code", recScaleTkt."Location Code");
                        VALIDATE("Bin Code", recScaleTkt."Bin Code");
                        VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                        VALIDATE("Shortcut Dimension 2 Code", recItem."Global Dimension 2 Code");
                        VALIDATE("Country/Region Code", recVendor."Country/Region Code");
                        VALIDATE(Quantity, -recGrowerTkt."Net Qty in Purchase UOM");
                        VALIDATE("Invoiced Quantity", 0);
                        VALIDATE("Invoiced Qty. (Base)", 0);
                        "Unit Cost" := recScaleTkt."Unit Cost";
                        "Unit Cost (ACY)" := "Unit Cost";
                        "Qty. per Unit of Measure" := 1;
                        Amount := -ROUND(recScaleTkt."Unit Cost" * recGrowerTkt."Net Qty in Purchase UOM", 0.01);
                        "Document No." := TransID;
                        "Document Line No." := LineNo;
                        "External Document No." := recGrowerTkt."Grower Ticket No.";
                        "Source Code" := 'ITEMJNL';
                        "Source No." := recGrowerTkt."Vendor No.";                 //
                        "Invoice-to Source No." := recGrowerTkt."Vendor No.";
                        "Source Type" := "Source Type"::Vendor;                   //
                        "Value Entry Type" := "Value Entry Type"::"Direct Cost";
                        VALIDATE("Inventory Posting Group", recItem."Inventory Posting Group");
                        VALIDATE("Gen. Prod. Posting Group", recItem."Gen. Prod. Posting Group");
                        VALIDATE("Gen. Bus. Posting Group", recVendor."Gen. Bus. Posting Group");
                        VALIDATE("Item Category Code", recItem."Item Category Code");
                        VALIDATE("Rupp Product Group Code", recItem."Rupp Product Group Code");
                        INSERT;
                        IF recItem."Item Tracking Code" > '' THEN
                            CreateReservation(recItemTran, recProdLot."Seed Lot # Planted");
                    END;
                END;
                LineNo += 100;
                recGrowerTkt."Transaction ID" := TransID;
                recGrowerTkt.MODIFY;
            UNTIL recGrowerTkt.NEXT = 0;
        END;
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", recItemTran);
        recScaleTkt.Status := recScaleTkt.Status::Canceled;
        recScaleTkt.MODIFY;


        /*{recGrowerTkt.SETFILTER("Production Lot No.", ProdLot);
        recGrowerTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        recGrowerTkt.MODIFYALL(Status, recGrowerTkt.Status::Posted);
        recGrowerTkt.MODIFYALL("Posting Date", recScaleTkt."Posting Date");

        recScaleTkt.SETFILTER("Production Lot No.", ProdLot);
        recScaleTkt.SETFILTER("Scale Ticket No.", ScaleTkt);
        recScaleTkt.MODIFYALL(Status, recScaleTkt.Status::Posted);
        ApplyReceipts(Type::"Futures (New Crop)");*/
    END;

    Procedure UnPostScaleTkt(recScaleTkt: Record "Scale Ticket Header")
    var
        recGrowerTkt: Record "Grower Ticket";
        recItemJournalRec: Record "Item Journal Line";
        recItemLedgerEntry: Record "Item Ledger Entry";
        recItem: Record Item;
        LineNo: integer;
        TransID: Code[20];

    begin
        recGrowerTkt.RESET;
        recGrowerTkt.SETFILTER("Production Lot No.", recScaleTkt."Production Lot No.");
        recGrowerTkt.SETFILTER("Scale Ticket No.", recScaleTkt."Scale Ticket No.");

        recItemJournalRec.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        recItemJournalRec.SETFILTER("Journal Template Name", 'ITEM');
        recItemJournalRec.SETFILTER("Journal Batch Name", 'GROWERTKT');
        IF recItemJournalRec.FINDLAST THEN
            LineNo := recItemJournalRec."Line No." + 1000
        ELSE
            LineNo := 1000;

        TransID := NoSeriesMgt.GetNextNo('IJNL-GEN', TODAY(), FALSE);

        IF recGrowerTkt.FINDSET THEN
            REPEAT
                IF recVendor.GET(recGrowerTkt."Vendor No.") THEN;
                WITH recItemJournalRec DO BEGIN
                    RESET;
                    recItemLedgerEntry.SETFILTER("Document No.", recGrowerTkt."Transaction ID");
                    recItemLedgerEntry.SETFILTER("Source No.", recGrowerTkt."Vendor No.");
                    IF recItemLedgerEntry.FINDSET THEN BEGIN
                        IF recItemLedgerEntry.Quantity <> recItemLedgerEntry."Remaining Quantity" THEN
                            ERROR('Unable to reverse this transaction, part of the quantity has been consumed');
                        IF NOT recItem.GET(recItemLedgerEntry."Item No.") THEN
                            CLEAR(recItem);
                        INIT;
                        "Journal Batch Name" := 'GROWERTKT';
                        "Journal Template Name" := 'ITEM';
                        "Line No." := LineNo;
                        "Document No." := TransID;
                        "Entry Type" := "Entry Type"::Purchase;                   //
                        "Document Type" := "Document Type"::"Purchase Receipt";   //
                        VALIDATE("Posting Date", TODAY);
                        VALIDATE("Item No.", recItemLedgerEntry."Item No.");
                        Adjustment := FALSE;
                        VALIDATE("Location Code", recItemLedgerEntry."Location Code");
                        VALIDATE("Bin Code", recGrowerTkt."Bin Code");
                        VALIDATE("Shortcut Dimension 1 Code", recItemLedgerEntry."Global Dimension 1 Code");
                        VALIDATE("Shortcut Dimension 2 Code", recItemLedgerEntry."Global Dimension 2 Code");
                        VALIDATE("Country/Region Code", recItemLedgerEntry."Country/Region Code");
                        VALIDATE(Quantity, -recItemLedgerEntry.Quantity);
                        VALIDATE("Invoiced Quantity", 0);
                        VALIDATE("Invoiced Qty. (Base)", 0);
                        "Unit Cost" := recScaleTkt."Unit Cost";
                        "Unit Cost (ACY)" := "Unit Cost";
                        "Qty. per Unit of Measure" := 1;
                        Amount := -recItemLedgerEntry."Cost Amount (Actual)";
                        VALIDATE("Applies-to Entry", recItemLedgerEntry."Entry No.");
                        "Document Line No." := "Line No.";
                        "External Document No." := recGrowerTkt."Grower Ticket No.";
                        "Source Code" := 'ITEMJNL';
                        "Source No." := recGrowerTkt."Vendor No.";                 //
                        "Invoice-to Source No." := recGrowerTkt."Vendor No.";
                        "Source Type" := "Source Type"::Vendor;                   //
                        "Value Entry Type" := "Value Entry Type"::"Direct Cost";
                        VALIDATE("Inventory Posting Group", recItem."Inventory Posting Group");
                        VALIDATE("Gen. Prod. Posting Group", recItem."Gen. Prod. Posting Group");
                        VALIDATE("Gen. Bus. Posting Group", recVendor."Gen. Bus. Posting Group");
                        VALIDATE("Item Category Code", recItem."Item Category Code");
                        VALIDATE("Rupp Product Group Code", recItem."Rupp Product Group Code");
                        INSERT;
                    END;
                    LineNo += 1000;
                END;
                recGrowerTkt.Status := recGrowerTkt.Status::Canceled;
                recGrowerTkt.MODIFY;
            UNTIL recGrowerTkt.NEXT = 0;
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", recItemJournalRec);
        recScaleTkt.Status := recScaleTkt.Status::Canceled;
        recScaleTkt.MODIFY;
    End;

    LOCAL Procedure CreateReservation(recIJL: Record "Item Journal Line"; LotNo: Code[20])
    var
        recRE: Record "Reservation Entry";
        iEntryNo: Integer;

    Begin
        recRE.RESET();
        recRE.SETRANGE("Source Type", 83);
        recRE.SETRANGE("Source ID", recIJL."Journal Template Name");
        recRE.SETRANGE("Item No.", recIJL."Item No.");
        IF recRE.FINDSET() THEN BEGIN
            IF (recRE.COUNT <> 1) OR (recRE."Lot No." <> LotNo) OR (recRE.Quantity <> recIJL.Quantity) THEN BEGIN
                recRE.DELETEALL();
            END ELSE BEGIN
                EXIT;
            END;
        END;

        recRE.RESET();
        IF recRE.FINDLAST() THEN BEGIN
            iEntryNo := recRE."Entry No." + 1;
        END ELSE BEGIN
            iEntryNo := 1;
        END;
        recRE.INIT();
        recRE."Entry No." := iEntryNo;
        recRE."Item No." := recIJL."Item No.";
        recRE."Location Code" := recIJL."Location Code";
        recRE."Quantity (Base)" := recIJL."Quantity (Base)";
        recRE."Reservation Status" := recRE."Reservation Status"::Surplus;
        recRE."Creation Date" := WORKDATE;
        recRE."Source Type" := recIJL."Source Type";
        recRE."Source Subtype" := 2;
        recRE."Source ID" := recIJL."Journal Template Name";
        recRE."Source Ref. No." := recIJL."Line No.";
        recRE."Expected Receipt Date" := WORKDATE;
        recRE."Created By" := USERID;
        recRE.Positive := TRUE;
        recRE."Qty. per Unit of Measure" := recIJL."Qty. per Unit of Measure";
        recRE.Quantity := recIJL.Quantity;
        recRE."Qty. to Handle (Base)" := recIJL."Quantity (Base)";
        recRE."Qty. to Invoice (Base)" := recIJL."Quantity (Base)";
        recRE."Lot No." := LotNo;
        recRE."Item Tracking" := recRE."Item Tracking"::"Lot No.";
        recRE.INSERT();
    End;

    Procedure ApplyReceipts(Type: Option Cash,"Futures (New Crop)")
    var
        recSettle: Record "Settlement-Prepayment Ticket";
        recGrowerTkt: Record "Grower Ticket";

    Begin
        //RSI-KS
        recSettle.RESET;
        recSettle.SETCURRENTKEY("Settlement Type", "Settlement Date", "Settlement No.");
        recSettle.SETFILTER(Status, '%1', recSettle.Status::Posted);
        recSettle.SETFILTER("Settlement Type", '=%1', Type);
        recSettle.SETFILTER("Remaining Quantity", '>0');

        IF recSettle.FINDSET THEN
            REPEAT
            BEGIN
                recSettle.VALIDATE("Settled Quantity");
                IF recSettle."Remaining Quantity" > 0 THEN BEGIN
                    recGrowerTkt.RESET;
                    recGrowerTkt.SETCURRENTKEY("Vendor No.", "Generic Name Code", "Posting Date");
                    recGrowerTkt.SETFILTER("Generic Name Code", recSettle."Generic Name Code");
                    recGrowerTkt.SETFILTER("Vendor No.", recSettle."Vendor No.");
                    recGrowerTkt.SETFILTER(Status, '%1', recGrowerTkt.Status::Posted);
                    IF recSettle."Settlement Type" = recSettle."Settlement Type"::"Futures (New Crop)" THEN
                        recGrowerTkt.SETFILTER("Receipt Date", '>=%1', recSettle."Futures Date");
                    IF recGrowerTkt.FINDSET THEN
                        REPEAT
                        BEGIN
                            recGrowerTkt.VALIDATE("Net Qty in Purchase UOM");
                            IF recGrowerTkt."Remaining Quantity" > 0 THEN
                                IF recGrowerTkt."Remaining Quantity" > recSettle."Remaining Quantity" THEN
                                    InsertAppliedSettlement(recSettle, recGrowerTkt, recSettle."Remaining Quantity")
                                ELSE
                                    InsertAppliedSettlement(recSettle, recGrowerTkt, recGrowerTkt."Remaining Quantity");
                        END;
                        recSettle.VALIDATE("Settled Quantity");
                        IF recSettle."Remaining Quantity" = 0 THEN    // Enough grower tickets exist to pay vendor
                            CreateInvoice(recSettle, recGrowerTkt);
                        UNTIL (recGrowerTkt.NEXT = 0) OR (recSettle."Remaining Quantity" = 0);
                END;
            END;
            UNTIL recSettle.NEXT = 0;
    End;

    LOCAL Procedure InsertAppliedSettlement(VAR recSettle: Record "Settlement-Prepayment Ticket"; VAR recGrowerTkt: Record "Grower Ticket"; AppliedQty: Decimal)
    var
        recAppliedAmt: Record "Settlement Applied Amounts";

    Begin
        //RSI-KS
        WITH recAppliedAmt DO BEGIN
            "Production Lot No." := recGrowerTkt."Production Lot No.";
            "Settlement Ticket No." := recSettle."Settlement No.";
            "Grower Ticket No." := recGrowerTkt."Grower Ticket No.";
            "Quantity Applied" := AppliedQty;
            INSERT;

            RESET;
            SETFILTER("Settlement Ticket No.", recSettle."Settlement No.");
            CALCSUMS("Quantity Applied");
            recSettle.VALIDATE("Settled Quantity", "Quantity Applied");
            recSettle.MODIFY;

            RESET;
            SETFILTER("Grower Ticket No.", recGrowerTkt."Grower Ticket No.");
            CALCSUMS("Quantity Applied");
            recGrowerTkt.VALIDATE("Settled Quantity", "Quantity Applied");
            recGrowerTkt.MODIFY;
        END;
    End;

    Procedure CreatePaymentFromSettlement(recPrepay: Record "Prepayment Amounts")
    var
        recVendor: Record Vendor;
        recGenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        DocNo: Code[20];
        x: Integer;

    Begin
        //RSI-KS
        IF NOT recVendor.GET(recPrepay."Vendor No.") THEN
            CLEAR(recVendor);
        WITH recGenJnlLine DO BEGIN
            RESET;
            SETCURRENTKEY("Journal Batch Name", "Line No.");
            SETFILTER("Journal Batch Name", 'GROWER PMT');
            IF FINDLAST THEN BEGIN
                LineNo := "Line No." + 10000;
                DocNo := NoSeriesMgt.GetNextNo('GJNL-PMT', TODAY(), FALSE);
            END ELSE BEGIN
                LineNo := 10000;
                DocNo := NoSeriesMgt.GetNextNo('GJNL-PMT', TODAY(), FALSE);
            END;
            "Journal Template Name" := 'PAYMENT';
            "Journal Batch Name" := 'GROWER PMT';
            "Line No." := LineNo;
            "Posting Date" := recPrepay."Prepayment Date";
            "Document Date" := "Posting Date";
            "Document Type" := "Document Type"::Payment;
            "Document No." := DocNo;
            "Account Type" := "Account Type"::Vendor;
            "Account No." := recPrepay."Vendor No.";
            Amount := recPrepay."Prepayment Amount";
            "External Document No." := DocNo;
            "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
            "Bal. Account No." := 'CHECKING';
            VALIDATE("Shortcut Dimension 1 Code", 'G');
            "Bank Payment Type" := "Bank Payment Type"::"Computer Check";
            "Posting Group" := recVendor."Vendor Posting Group";
            "Sell-to/Buy-from No." := recPrepay."Vendor No.";

            "Source Code" := 'PAYMENTJNL';
            Description := 'Prepay ';
            x := STRPOS(recPrepay."Generic Name Code", ',');
            IF x > 0 THEN
                Description += DELCHR(COPYSTR(recPrepay."Generic Name Code", 1, x - 1), '>', ' ')
            ELSE
                Description += DELCHR(recPrepay."Generic Name Code", '>', ' ');
            INSERT;
        END;

        recPrepay.Status := recPrepay.Status::Paid;
        recPrepay."Prepayment Date" := TODAY;
        recPrepay.MODIFY;
    End;

    LOCAL Procedure GetTransNos(TransId: Code[20])
    var
        recGrowerTkt: Record "Grower Ticket";
        recItemLedg: Record "Item Ledger Entry";
        recValueEntry: Record "Value Entry";

    Begin
        //RSI-KS
        recGrowerTkt.RESET;
        recGrowerTkt.SETFILTER("Transaction ID", TransId);
        IF recGrowerTkt.FINDSET THEN
            REPEAT
                recItemLedg.RESET;
                recItemLedg.SETFILTER("Document No.", recGrowerTkt."Transaction ID");
                recItemLedg.SETFILTER("Source No.", recGrowerTkt."Vendor No.");
                recItemLedg.SETFILTER("Document Type", '%1', recItemLedg."Document Type"::"Purchase Receipt");
                recItemLedg.SETFILTER("Entry Type", '%1', recItemLedg."Entry Type"::Purchase);
                IF recItemLedg.FINDSET THEN
                    recGrowerTkt."Item Journal Entry No." := recItemLedg."Entry No.";

                recValueEntry.RESET;
                recValueEntry.SETFILTER("Document No.", recGrowerTkt."Transaction ID");
                recValueEntry.SETFILTER("Source No.", recGrowerTkt."Vendor No.");
                recValueEntry.SETFILTER("Document Type", '%1', recValueEntry."Document Type"::"Purchase Receipt");
                recValueEntry.SETFILTER("Item Ledger Entry Type", '%1', recValueEntry."Item Ledger Entry Type"::Purchase);
                IF recValueEntry.FINDSET THEN
                    recGrowerTkt."Value Entry No." := recValueEntry."Entry No.";
                recGrowerTkt.MODIFY;
            UNTIL recGrowerTkt.NEXT = 0;
    End;

    Procedure CreateInvoice(VAR recSettle: Record "Settlement-Prepayment Ticket"; VAR recGrowerTkt: Record "Grower Ticket")
    var
        recPH: Record "Purchase Header";
        PurchPost: CodeUnit "Purch.-Post";

    Begin
        //RSI-KS
        CreateInvHead(recPH, recSettle);
        CreateInvLine(recPH, recSettle);
        PurchPost.RUN(recPH);

        AdjustCost(recSettle);
    End;

    LOCAL Procedure CreateInvHead(VAR recPH: Record "Purchase Header"; recSettle: Record "Settlement-Prepayment Ticket")
    Begin
        //RSI-KS
        recPH.INIT();
        recPH."Document Type" := recPH."Document Type"::Invoice;
        recPH."No." := '';
        recPH.INSERT(TRUE);
        recPH.VALIDATE("Vendor Invoice No.", recSettle."Settlement No.");
        recPH.VALIDATE("Buy-from Vendor No.", recSettle."Vendor No.");
        recPH.VALIDATE("Location Code", recSettle."Location Code");
        recPH.VALIDATE("Order Date", recSettle."Settlement Date");
        recPH.VALIDATE("Posting Description", 'Payment of Settlement ' + recSettle."Settlement No.");
        recPH.VALIDATE("Posting Date", recSettle."Settlement Date");
        IF recSettle."Deferred Date" <> 0D THEN
            recPH.VALIDATE("Due Date", recSettle."Deferred Date")
        ELSE
            recPH.VALIDATE("Due Date", recSettle."Settlement Date");
        recPH.MODIFY;

        recSettle."Purchase Invoice" := recPH."No.";
        recSettle.MODIFY;
    End;

    LOCAL procedure CreateInvLine(VAR recPH: Record "Purchase Header"; recSettlement: Record "Settlement-Prepayment Ticket")
    var
        recAppliedAmt: Record "Settlement Applied Amounts";
        recProdLot: Record "Production Lot";
        recInvPostSetup: Record "Inventory Posting Setup";
        recItem: Record Item;
        recGenPostSetup: record "General Posting Setup";
        recGrowerTkt: Record "Grower Ticket";
        recScaleTkt: Record "Scale Ticket Header";
        recCommodity: Record "Commodity Settings";
        recPL: Record "Purchase Line";
        recItemLedg: Record "Item Ledger Entry";
        LineNo: Integer;
        TotalPmt: Decimal;
        TotalPremium: Decimal;

    Begin
        //RSI-KS
        // Get scale ticket posting data

        IF NOT recRuppSetup.GET THEN
            CLEAR(recRuppSetup);

        LineNo := 1000;

        //recAppliedAmt.SETFILTER("Production Lot No.", recSettlement."Production Lot No.");
        recAppliedAmt.RESET;
        recAppliedAmt.SETFILTER("Settlement Ticket No.", recSettlement."Settlement No.");
        IF recAppliedAmt.FINDSET THEN
            REPEAT
                IF NOT recProdLot.GET(recAppliedAmt."Production Lot No.") THEN
                    CLEAR(recProdLot);
                IF NOT recItem.GET(recProdLot."Item No.") THEN
                    CLEAR(recItem);
                IF NOT recInvPostSetup.GET('RUPP', recItem."Inventory Posting Group") THEN
                    CLEAR(recInvPostSetup);
                IF NOT recVendor.GET(recSettlement."Vendor No.") THEN
                    CLEAR(recVendor);
                IF NOT recGenPostSetup.GET(recVendor."Gen. Bus. Posting Group", recItem."Gen. Prod. Posting Group") THEN
                    CLEAR(recGenPostSetup);
                IF NOT recGrowerTkt.GET(recAppliedAmt."Grower Ticket No.") THEN
                    CLEAR(recGrowerTkt);
                IF NOT recScaleTkt.GET(recGrowerTkt."Production Lot No.", recGrowerTkt."Scale Ticket No.") THEN
                    CLEAR(recScaleTkt);
                IF NOT recCommodity.GET(recProdLot."Commodity  Code") THEN
                    CLEAR(recCommodity);

                /*              recItemLedg.RESET;
                                recItemLedg.SETFILTER("Document No.", recGrowerTkt."Transaction ID");
                                IF recItemLedg.FINDSET THEN BEGIN
                                    recItemLedg."Invoiced Quantity" += recAppliedAmt."Quantity Applied";
                                    recItemLedg.MODIFY;
                                END;
                */
                // Debit Grower Accrued purchases
                WITH recPL DO BEGIN
                    INIT;
                    VALIDATE("Document Type", "Document Type"::Invoice);
                    VALIDATE("Buy-from Vendor No.", recSettlement."Vendor No.");
                    VALIDATE("Document No.", recPH."No.");
                    "Line No." := LineNo;
                    VALIDATE(Type, Type::"G/L Account");
                    VALIDATE("No.", recGenPostSetup."Invt. Accrual Acc. (Interim)");
                    VALIDATE(Quantity, 1);
                    VALIDATE("Direct Unit Cost", ROUND(recAppliedAmt."Quantity Applied" * recScaleTkt."Unit Cost", 0.01));
                    VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                    //    VALIDATE("Shortcut Dimension 2 Code", recVendor."Global Dimension 2 Code");
                    //INSERT;
                    //LineNo += 1000;

                    // Credit Interim account
                    "Line No." := LineNo;
                    VALIDATE("No.", recInvPostSetup."Inventory Account (Interim)");
                    VALIDATE("Direct Unit Cost", -ROUND(recAppliedAmt."Quantity Applied" * recScaleTkt."Unit Cost", 0.01));
                    //INSERT;
                    //LineNo += 1000;

                    TotalPmt := 0;
                    // G/L Update Inventory Account
                    "Line No." := LineNo;
                    VALIDATE("No.", recInvPostSetup."Inventory Account");
                    VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                    //    VALIDATE("Shortcut Dimension 2 Code", recItem."Global Dimension 2 Code");
                    VALIDATE("Direct Unit Cost", ROUND(recAppliedAmt."Quantity Applied" * (recSettlement."Base Settlement Price" + recGrowerTkt."Total Premi / Disc per UOM"), 0.01));
                    //INSERT;
                    //LineNo += 1000;

                    //Update Direct Purchases Account
                    "Line No." := LineNo;
                    VALIDATE("No.", recGenPostSetup."Direct Cost Applied Account");
                    VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                    //    VALIDATE("Shortcut Dimension 2 Code", recVendor."Global Dimension 2 Code");
                    VALIDATE("Direct Unit Cost", -ROUND(recAppliedAmt."Quantity Applied" * (recSettlement."Base Settlement Price" + recGrowerTkt."Total Premi / Disc per UOM"), 0.01));
                    //INSERT;
                    //LineNo += 1000;

                    // Post Premium amount
                    /*IF TotalPremium<>0 THEN BEGIN
                      "Line No.":=LineNo;
                      VALIDATE("No.", recRuppSetup."Premium/ Discount No.");
                      VALIDATE("Direct Unit Cost", TotalPremium);
                      VALIDATE("Shortcut Dimension 1 Code", recVendor."Global Dimension 1 Code");
                      VALIDATE("Shortcut Dimension 2 Code", recVendor."Global Dimension 2 Code");
                      INSERT;
                      LineNo+=1000;
                    END;
                    */
                    // Post Checkoff
                    IF recProdLot."Check off %" > 0 THEN BEGIN
                        "Line No." := LineNo;
                        IF recCommodity."Grain Program Payable Acct" = '' THEN
                            VALIDATE("No.", '214070')
                        ELSE
                            VALIDATE("No.", recCommodity."Grain Program Payable Acct");
                        VALIDATE("Direct Unit Cost", -ROUND((recSettlement."Base Settlement Price" * recAppliedAmt."Quantity Applied" * recProdLot."Check off %" / 100), 0.01));
                        VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                        INSERT;
                        LineNo += 1000;
                    END;
                    //  Post Purchase Amount
                    "Line No." := LineNo;
                    VALIDATE("No.", recGenPostSetup."Purch. Account");
                    VALIDATE("Direct Unit Cost", ROUND(recAppliedAmt."Quantity Applied" * (recSettlement."Base Settlement Price" + recGrowerTkt."Total Premi / Disc per UOM"), 0.01));
                    VALIDATE("Shortcut Dimension 1 Code", recItem."Global Dimension 1 Code");
                    //    VALIDATE("Shortcut Dimension 2 Code", recVendor."Global Dimension 2 Code");
                    INSERT;
                    LineNo += 1000;
                    ApplyPrepayment(recAppliedAmt, recGrowerTkt, "Direct Unit Cost");
                END;
            UNTIL recAppliedAmt.NEXT = 0;
    end;

    LOCAL Procedure AdjustCost(recSettlement: Record "Settlement-Prepayment Ticket")
    var
        recValueEntry: Record "Value Entry";
        recAppliedAmt: Record "Settlement Applied Amounts";
        recScaleTkt: Record "Scale Ticket Header";
        recPostToGL: Record "Post Value Entry to G/L";
        recGrowerTkt: Record "Grower Ticket";
        recVend: Record Vendor;
        recItem: Record Item;
        nextNo: Integer;
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
        recItemLedgEntry: Record "Item Ledger Entry";

    Begin
        //RSI-KS

        recValueEntry.LOCKTABLE;
        recValueEntry.RESET;
        recValueEntry.SETCURRENTKEY("Entry No.");
        IF recValueEntry.FINDLAST THEN
            nextNo := recValueEntry."Entry No." + 1;

        recAppliedAmt.RESET;
        recAppliedAmt.SETFILTER("Settlement Ticket No.", recSettlement."Settlement No.");
        IF recAppliedAmt.FINDSET THEN
            REPEAT
                IF NOT recGrowerTkt.GET(recAppliedAmt."Grower Ticket No.") THEN
                    CLEAR(recGrowerTkt);
                IF NOT recScaleTkt.GET(recGrowerTkt."Production Lot No.", recGrowerTkt."Scale Ticket No.") THEN
                    CLEAR(recScaleTkt);
                IF NOT recVend.GET(recGrowerTkt."Vendor No.") THEN
                    CLEAR(recVend);
                IF NOT recItem.GET(recGrowerTkt."Item No.") THEN
                    CLEAR(recItem);

                WITH recValueEntry DO BEGIN
                    INIT;
                    "Entry No." := nextNo;
                    "Item No." := recGrowerTkt."Item No.";
                    "Posting Date" := TODAY;
                    "Item Ledger Entry Type" := "Item Ledger Entry Type"::Purchase;
                    "Source No." := recGrowerTkt."Vendor No.";
                    "Document No." := recGrowerTkt."Grower Ticket No.";
                    INSERT;
                    "Location Code" := recSettlement."Location Code";
                    VALIDATE("Inventory Posting Group", recItem."Inventory Posting Group");
                    "Source Posting Group" := recVend."Vendor Posting Group";
                    "Item Ledger Entry No." := recGrowerTkt."Item Journal Entry No.";
                    "Valued Quantity" := recAppliedAmt."Quantity Applied";
                    "Invoiced Quantity" := "Valued Quantity";
                    "Cost per Unit" := recSettlement."Base Settlement Price";
                    "User ID" := USERID;
                    "Source Code" := 'PURCHASES';
                    DimMgt.ValidateShortcutDimValues(1, recItem."Global Dimension 1 Code", DimSetID);
                    VALIDATE("Global Dimension 1 Code", recItem."Global Dimension 1 Code");
                    "Dimension Set ID" := DimSetID;
                    VALIDATE("Global Dimension 2 Code", recItem."Global Dimension 2 Code");
                    "Source Type" := "Source Type"::Vendor;
                    "Cost Amount (Actual)" := ROUND("Valued Quantity" * ("Cost per Unit" + recGrowerTkt."Total Premi / Disc per UOM"), 0.01);
                    //                    "Cost Posted to G/L" := "Cost Amount (Actual)";
                    VALIDATE("Gen. Bus. Posting Group", recVend."Gen. Bus. Posting Group");
                    VALIDATE("Gen. Prod. Posting Group", recItem."Gen. Prod. Posting Group");
                    "Document Date" := TODAY;
                    "Document Type" := "Document Type"::"Purchase Invoice";
                    "Expected Cost" := FALSE;
                    Inventoriable := TRUE;
                    "Valuation Date" := TODAY;
                    "Entry Type" := "Entry Type"::"Direct Cost";
                    "Purchase Amount (Actual)" := "Cost Amount (Actual)";
                    "Purchase Amount (Expected)" := -ROUND("Valued Quantity" * recScaleTkt."Unit Cost", 0.01);
                    "Cost Amount (Expected)" := "Purchase Amount (Expected)";
                    //                    "Expected Cost Posted to G/L" := "Purchase Amount (Expected)";
                    Type := Type::"Work Center";
                    MODIFY;

                    recPostToGL."Value Entry No." := nextNo;
                    recPostToGL."Item No." := "Item No.";
                    recPostToGL."Posting Date" := "Posting Date";
                    recPostToGL.INSERT;

                    IF recItemLedgEntry.GET("Item Ledger Entry No.") THEN
                        IF recItemLedgEntry."Item No." = "Item No." THEN BEGIN
                            recItemLedgEntry."Invoiced Quantity" := recItemLedgEntry."Invoiced Quantity" + "Valued Quantity";
                            recItemLedgEntry.MODIFY;
                        END;
                END;
                nextNo += 1;
            UNTIL recAppliedAmt.NEXT = 0;
        COMMIT;
    End;

    LOCAL Procedure CalcCarryingCharge(recGrowerTkt: Record "Grower Ticket") CarryingCharge: Decimal
    var
        AccountingPeriod: Record "Accounting Period";
        FiscalDateEnd: Date;

    Begin
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod."Starting Date" := recGrowerTkt."Receipt Date";
        IF AccountingPeriod.FIND('>=') THEN
            FiscalDateEnd := CALCDATE('+1D', AccountingPeriod."Starting Date")
        ELSE
            FiscalDateEnd := 99991231D;
    End;

    LOCAL Procedure ApplyPrepayment(VAR recAppliedAmt: Record "Settlement Applied Amounts"; recGrowerTkt: Record "Grower Ticket"; Amount: Decimal)
    var
        recPrepay: Record "Prepayment Amounts";

    Begin
        recPrepay.RESET;
        recPrepay.SETFILTER("Vendor No.", recGrowerTkt."Vendor No.");
        recPrepay.SETFILTER("Amount Remaining", '>0');

        IF recPrepay.FINDSET THEN
            REPEAT
                IF recPrepay."Amount Remaining" >= Amount THEN BEGIN
                    recPrepay."Amount Consumed" += Amount;
                    recPrepay."Amount Remaining" -= Amount;
                    recAppliedAmt."Prepay No." := recPrepay."Prepayment No.";
                    recAppliedAmt."Prepay Consumed" += Amount;
                    recAppliedAmt.MODIFY;
                    recPrepay.MODIFY;
                    Amount := 0;
                END ELSE BEGIN
                    Amount -= recPrepay."Amount Remaining";
                    recAppliedAmt."Prepay No." := recPrepay."Prepayment No.";
                    recAppliedAmt."Prepay Consumed" += recPrepay."Amount Remaining";
                    recPrepay."Amount Remaining" := 0;
                    recAppliedAmt.MODIFY;
                    recPrepay."Amount Consumed" := recPrepay."Prepayment Amount";
                    recPrepay.MODIFY;
                END;
            UNTIL (recPrepay.NEXT = 0) OR (Amount = 0);
    End;
}

