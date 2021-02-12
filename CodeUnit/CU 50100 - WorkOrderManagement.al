codeunit 50100 "Work Order Management"
{
    // //SOC-SC 08-07-15
    //   Produce only if "Item No." is not blank in the Produced Items section and consume only if "Type" is not blank in Consumed Items section
    // 
    // //SOC-MA 09-24-15
    //   Modified code to use "Work Order No." as default "Lot No." for produced item
    // 
    // //SOC-MA 10-12-15
    //   Modified code in functon UpdateAssemblyLinesToResolveRoundingErr() to resolve rounding error
    // 
    // //SOC-SC 12-26-15
    //   When copying a Consumed Item from a template, reset the "Template" field to False
    // 
    // //SOC-SC 02-18-16
    //   Fixing CAL programming error when posting a WO


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CreateAssemblyOrders(WorkOrder: Record "Work Order")
    var
        recProducedItem: Record "Produced Item";
        recAssmblyHdr: Record "Assembly Header";
        sAssemblyOrderNo: Code[30];
        dTotalQty: Decimal;
        dTotalNonSCRNQty: Decimal;
        dTotQtyUsed: Decimal;
        dTotNonSCRNUsed: Decimal;
        dQtyToAsmbl: Decimal;
        iLineCnt: Integer;
        iNonSCRNLineCnt: Integer;
        i1: Integer;
        i2: Integer;
        dFractionAll: Decimal;
        dFractionWOScreen: Decimal;
    begin

        WorkOrder.TestField(Status, WorkOrder.Status::Open);

        recAssmblyHdr.Reset;
        recAssmblyHdr.SetRange("Work Order No.", WorkOrder."No.");
        if recAssmblyHdr.FindFirst() then
            Error('Assembly Order(s) already exists.\ Cannot create new Assembly Order(s) before posting or deleting existing Assembly Orderds.');

        CheckConsumedItems(WorkOrder."No.");
        CheckProducedItems(WorkOrder."No.");  //SOC-MA 08-08-15

        //WorkOrder.CALCFIELDS("Qty. to Assemble in Lowest UOM");
        //dTotalQty := WorkOrder."Qty. to Assemble in Lowest UOM";

        recProducedItem.Reset;
        recProducedItem.SetRange("Work Order No.", WorkOrder."No.");
        recProducedItem.SetFilter("Item No.", '<>%1', ''); //SOC-SC 08-07-15
        recProducedItem.SetFilter("Quantity to Assemble", '<>0');
        if recProducedItem.FindSet() then begin
            repeat
                dTotalQty += recProducedItem."Qty. to Assemble in Lowest UOM";
                iLineCnt += 1;
                if not recProducedItem.Screen then begin
                    dTotalNonSCRNQty += recProducedItem."Qty. to Assemble in Lowest UOM";
                    iNonSCRNLineCnt += 1;
                end;
            until recProducedItem.Next = 0;
        end;

        if recProducedItem.FindSet() then begin
            repeat
                recProducedItem."Fraction All" := 0;
                recProducedItem."Fraction Without Screen" := 0;
                //i1 += 1;
                //IF i1 = iLineCnt THEN BEGIN
                //  recProducedItem."Fraction All" := 1 - dFractionAll;
                //END ELSE BEGIN
                recProducedItem."Fraction All" := Round(recProducedItem."Qty. to Assemble in Lowest UOM" / dTotalQty, 0.00000001);
                dFractionAll += recProducedItem."Fraction All";
                //END;

                if not recProducedItem.Screen then begin
                    //i2 += 1;
                    //IF i2 = iNonSCRNLineCnt THEN BEGIN
                    //  recProducedItem."Fraction Without Screen" := 1 - dFractionWOScreen;
                    //END ELSE BEGIN
                    recProducedItem."Fraction Without Screen" := Round(recProducedItem."Qty. to Assemble in Lowest UOM" / dTotalNonSCRNQty, 0.00000001);
                    dFractionWOScreen += recProducedItem."Fraction Without Screen";
                    //END;
                end;
                recProducedItem.Modify;
            until recProducedItem.Next = 0;
        end;

        if recProducedItem.FindSet() then begin
            repeat
                Clear(recAssmblyHdr);
                recAssmblyHdr.Init;
                recAssmblyHdr."Document Type" := recAssmblyHdr."Document Type"::Order;
                recAssmblyHdr."Work Order No." := recProducedItem."Work Order No.";
                recAssmblyHdr."Produced Item Line No." := recProducedItem."Line No.";
                recAssmblyHdr.Insert(true);

                recAssmblyHdr.SetWarningsOff; //SOC-SC 02-18-16

                if WorkOrder."Due Date" = 0D then begin
                    recAssmblyHdr."Due Date" := WorkDate();
                end else begin
                    recAssmblyHdr."Due Date" := WorkOrder."Due Date";
                end;
                recAssmblyHdr."Starting Date" := WorkDate();
                recAssmblyHdr."Ending Date" := WorkDate();
                recAssmblyHdr.Validate("Location Code", recProducedItem."Location Code");
                if WorkOrder."Posting Date" = 0D then begin
                    recAssmblyHdr.Validate("Posting Date", WorkDate);
                end else begin
                    recAssmblyHdr.Validate("Posting Date", WorkOrder."Posting Date");
                end;
                recAssmblyHdr.Validate("Item No.", recProducedItem."Item No.");
                recAssmblyHdr.Validate("Unit of Measure Code", recProducedItem."Unit of Measure Code");
                recAssmblyHdr.Validate(Quantity, recProducedItem."Quantity to Assemble");
                recAssmblyHdr.Validate("Quantity to Assemble", recProducedItem."Quantity to Assemble");
                recAssmblyHdr.Validate("Bin Code", recProducedItem."Bin Code");
                recAssmblyHdr.Modify(true);

                CreateAssemblyLines(recAssmblyHdr, recProducedItem);

            until recProducedItem.Next = 0;

            //Take care of rounding error
            UpdateAssemblyLinesToResolveRoundingErr(WorkOrder."No.");

            //Insert Lot Nos
            UpdateAssemblyOrderTrackings(WorkOrder."No.");

        end;
    end;

    [Scope('Internal')]
    procedure CreateAssemblyLines(AssemblyHeader: Record "Assembly Header"; ProducedItem: Record "Produced Item")
    var
        recConsumedItem: Record "Consumed Item";
        recAssemblyLine: Record "Assembly Line";
        iLineNo: Integer;
        dQty: Decimal;
    begin

        iLineNo := 0;

        recConsumedItem.Reset;
        recConsumedItem.SetRange("Work Order No.", ProducedItem."Work Order No.");
        recConsumedItem.SetFilter(Type, '<>%1', recConsumedItem.Type::" "); //SOC-SC 08-07-15
        if ProducedItem.Screen then
            recConsumedItem.SetRange("Consume for Screen", true);
        if recConsumedItem.FindSet() then begin
            repeat
                recConsumedItem.CalcFields("Is a Bag");
                if recConsumedItem."Is a Bag" and (recConsumedItem."No." <> ProducedItem."Bag Item No.") then begin
                    //skip
                end else begin
                    Clear(recAssemblyLine);
                    recAssemblyLine.Reset;
                    //iLineNo += 10000;
                    iLineNo += 1000;
                    recAssemblyLine.SkipAvailWarning();
                    recAssemblyLine.Init;
                    recAssemblyLine."Document Type" := AssemblyHeader."Document Type"::Order;
                    recAssemblyLine."Document No." := AssemblyHeader."No.";
                    recAssemblyLine."Line No." := iLineNo;
                    recAssemblyLine."Work Order No." := recConsumedItem."Work Order No.";
                    recAssemblyLine."Consumed Item Line No." := recConsumedItem."Line No.";
                    recAssemblyLine.Type := recConsumedItem.Type;
                    recAssemblyLine.Validate("No.", recConsumedItem."No.");
                    recAssemblyLine.Validate("Unit of Measure Code", recConsumedItem."Unit of Measure Code");   //SOC-MA 08-04-15
                    if recAssemblyLine.Type = recAssemblyLine.Type::Item then begin
                        recAssemblyLine.Validate("Location Code", recConsumedItem."Location Code");
                        recAssemblyLine.Validate("Bin Code", recConsumedItem."Bin Code");
                    end;
                    if recConsumedItem."Is a Bag" and (recConsumedItem."No." = ProducedItem."Bag Item No.") then begin
                        //SOC-MA 08-05-15 start
                        //recAssemblyLine.VALIDATE(Quantity, recConsumedItem."Quantity to Consume");
                        if ProducedItem."Bag Quantity" <> 0 then begin
                            recAssemblyLine.Validate(Quantity, ProducedItem."Bag Quantity");
                        end else begin
                            recAssemblyLine.Validate(Quantity, ProducedItem."Quantity to Assemble");
                        end;
                        //SOC-MA 08-05-15 end
                    end else begin
                        if recConsumedItem."Consume for Screen" then begin
                            dQty := Round(recConsumedItem."Quantity to Consume" * ProducedItem."Fraction All", 0.00000001);
                            recAssemblyLine.Validate(Quantity, dQty);
                        end else begin
                            dQty := Round(recConsumedItem."Quantity to Consume" * ProducedItem."Fraction Without Screen", 0.00000001);
                            recAssemblyLine.Validate(Quantity, dQty);
                        end;
                    end;
                    recAssemblyLine.Validate("Quantity to Consume", recAssemblyLine.Quantity);
                    //      recAssemblyLine."Line No."      := iLineNo;
                    recAssemblyLine.Insert(true);
                end;
            until recConsumedItem.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure CopyWorkOrder(CopyFromWONo: Code[20]; var CopyToWO: Record "Work Order")
    var
        recCopyFromWO: Record "Work Order";
        sCopyToWONo: Text[30];
        recTempOriginalWO: Record "Work Order" temporary;
        recCopyFromProducedItem: Record "Produced Item";
        recCopyToProducedItem: Record "Produced Item";
        recCopyFromConsumedItem: Record "Consumed Item";
        recCopyToConsumedItem: Record "Consumed Item";
    begin

        CopyToWO.TestField(Status, CopyToWO.Status::Open);
        CopyToWO.CalcFields("Assembled Quantity");
        CopyToWO.TestField(CopyToWO."Assembled Quantity", 0);

        recCopyToProducedItem.Reset;
        recCopyToProducedItem.SetRange("Work Order No.", CopyToWO."No.");
        if recCopyToProducedItem.FindFirst() then
            Error('Work Order %1 has Produced Item line. Cannot copy from another Work Order.', CopyToWO."No.");

        recCopyToConsumedItem.Reset;
        recCopyToConsumedItem.SetRange("Work Order No.", CopyToWO."No.");
        if recCopyToConsumedItem.FindFirst() then
            Error('Work Order %1 has Consumed Item line. Cannot copy from another Work Order.', CopyToWO."No.");

        recCopyFromWO.Get(CopyFromWONo);

        if CopyToWO.Description = '' then
            CopyToWO.Description := recCopyFromWO.Description;
        CopyToWO."Location Code" := recCopyFromWO."Location Code";
        CopyToWO."Bin Code" := recCopyFromWO."Bin Code";
        //CopyToWO.Quantity
        //CopyToWO.MODIFY;

        //******************************//
        // Copy all Produced Item lines //
        //******************************//
        recCopyFromProducedItem.Reset;
        recCopyFromProducedItem.SetRange("Work Order No.", CopyFromWONo);
        if recCopyFromProducedItem.FindSet() then begin
            repeat
                recCopyToProducedItem.Init;
                recCopyToProducedItem.TransferFields(recCopyFromProducedItem);
                recCopyToProducedItem."Work Order No." := CopyToWO."No.";
                recCopyToProducedItem.Validate(Quantity, recCopyFromProducedItem.Quantity);
                recCopyToProducedItem.Insert;
            until recCopyFromProducedItem.Next = 0;
        end;

        //******************************//
        // Copy all Consumed Item lines //
        //******************************//
        recCopyFromConsumedItem.Reset;
        recCopyFromConsumedItem.SetRange("Work Order No.", CopyFromWONo);
        if recCopyFromConsumedItem.FindSet() then begin
            repeat
                recCopyToConsumedItem.Init;
                recCopyToConsumedItem.TransferFields(recCopyFromConsumedItem);
                recCopyToConsumedItem."Work Order No." := CopyToWO."No.";
                recCopyToConsumedItem.Validate(Quantity, recCopyFromConsumedItem.Quantity);
                recCopyToConsumedItem.Validate(Template, false); //SOC-SC 12-26-15
                recCopyToConsumedItem.Insert;
            until recCopyFromConsumedItem.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateAssemblyLinesToResolveRoundingErr(WONo: Code[20])
    var
        recConsumedItem: Record "Consumed Item";
        dQtyToConsume: Decimal;
        recAssemblyLine: Record "Assembly Line";
        dAssemblyLineQty: Decimal;
        dQtyDifference: Decimal;
    begin

        recConsumedItem.Reset;
        recConsumedItem.SetRange("Work Order No.", WONo);
        recConsumedItem.SetFilter("Quantity to Consume", '>0');
        if recConsumedItem.FindSet() then begin
            repeat
                dQtyToConsume := recConsumedItem."Quantity to Consume";
                dAssemblyLineQty := 0;
                recAssemblyLine.Reset;
                recAssemblyLine.SetRange("Work Order No.", WONo);
                recAssemblyLine.SetRange("Consumed Item Line No.", recConsumedItem."Line No.");
                if recAssemblyLine.FindSet() then begin
                    recAssemblyLine.CalcSums(Quantity);
                    dAssemblyLineQty := recAssemblyLine.Quantity;
                    if dAssemblyLineQty <> dQtyToConsume then begin
                        dQtyDifference := dQtyToConsume - dAssemblyLineQty;
                        if dQtyDifference > 0 then begin
                            if recAssemblyLine.FindFirst() then begin   //SOC-MA 10-12-15
                                recAssemblyLine.Validate(Quantity, (recAssemblyLine.Quantity + dQtyDifference));
                                recAssemblyLine.Validate("Quantity to Consume", recAssemblyLine.Quantity);
                                recAssemblyLine.Modify;
                            end;                                        //SOC-MA 10-12-15
                        end;
                        if dQtyDifference < 0 then begin
                            recAssemblyLine.SetFilter(Quantity, '>%1', -dQtyDifference);
                            if recAssemblyLine.FindFirst() then begin
                                recAssemblyLine.Validate(Quantity, (recAssemblyLine.Quantity + dQtyDifference));
                                recAssemblyLine.Validate("Quantity to Consume", recAssemblyLine.Quantity);
                                recAssemblyLine.Modify;
                            end;
                        end;
                    end;
                end;
            until recConsumedItem.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateAssemblyOrderTrackings(WONo: Code[30])
    var
        recProducedItem: Record "Produced Item";
        recConsumedItem: Record "Consumed Item";
        recAssemblyHeader: Record "Assembly Header";
        recAssemblyLine: Record "Assembly Line";
        recItem: Record Item;
        sLotNo: Text[30];
        sProducedLotNo: Text[30];
    begin

        //Get default Lot No
        //SOC-MA 09-24-15 >>
        /*
        recConsumedItem.RESET;
        recConsumedItem.SETRANGE("Work Order No.", WONo);
        recConsumedItem.SETFILTER("Lot No.", '<>%1', '');
        IF recConsumedItem.FINDFIRST() THEN
          sLotNo := recConsumedItem."Lot No.";
        IF sLotNo = '' THEN
          sLotNo := WONo;
        */
        sLotNo := WONo;
        //SOC-MA 09-24-15 <<

        //**********************************//
        // Insert Lot No. for Produced Item //
        //**********************************//
        recAssemblyHeader.Reset;
        recAssemblyHeader.SetRange("Work Order No.", WONo);
        if recAssemblyHeader.FindSet() then begin
            repeat
                with recAssemblyHeader do begin
                    if recItem.Get("Item No.") then begin
                        if recItem."Item Tracking Code" <> '' then begin
                            //check if this for produced item
                            //TBD
                            sProducedLotNo := GetProducedItemLotNo(recAssemblyHeader);
                            if sProducedLotNo = '' then
                                sProducedLotNo := sLotNo;
                            CreateReservationEntry("Item No.", "Location Code", 900, "No.", 0, sProducedLotNo, Quantity);
                        end;
                    end;
                end;
            until recAssemblyHeader.Next = 0;
        end;

        //**********************************//
        // Insert Lot No. for Consumed Item //
        //**********************************//
        recAssemblyLine.Reset;
        recAssemblyLine.SetRange("Work Order No.", WONo);
        recAssemblyLine.SetRange(Type, recAssemblyLine.Type::Item);
        if recAssemblyLine.FindSet() then begin
            repeat
                with recAssemblyLine do begin
                    if recItem.Get("No.") then begin
                        if recItem."Item Tracking Code" <> '' then begin
                            //check if this for produced item
                            //TBD
                            sLotNo := GetConsumedItemLotNo(recAssemblyLine);
                            if sLotNo <> '' then
                                CreateReservationEntry("No.", "Location Code", 901, "Document No.", "Line No.", sLotNo, Quantity);
                        end;
                    end;
                end;
            until recAssemblyLine.Next = 0;
        end;

    end;

    [Scope('Internal')]
    procedure CreateReservationEntry(ItemNo: Code[30]; LocationCode: Code[30]; SourceType: Integer; SourceID: Text[30]; SourceLineNo: Integer; LotNo: Text[30]; Qty: Decimal)
    var
        recReservationEntry: Record "Reservation Entry";
    begin

        recReservationEntry.Reset;
        recReservationEntry.SetRange("Item No.", ItemNo);
        recReservationEntry.SetRange("Location Code", LocationCode);
        recReservationEntry.SetRange("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
        recReservationEntry.SetRange("Source Type", SourceType);        //900 = Assembly Header; 901 = Assembly Line
        recReservationEntry.SetRange("Source Subtype", 1);
        recReservationEntry.SetRange("Source ID", SourceID);
        recReservationEntry.SetRange("Source Ref. No.", SourceLineNo);  //Line No.
        recReservationEntry.SetRange(Positive, true);         //Producing
        recReservationEntry.SetRange("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
        recReservationEntry.SetRange("Lot No.", LotNo);
        if recReservationEntry.FindFirst() then begin

        end else begin
            recReservationEntry.Init;
            recReservationEntry.Validate("Item No.", ItemNo);
            recReservationEntry.Validate("Location Code", LocationCode);
            recReservationEntry."Reservation Status" := recReservationEntry."Reservation Status"::Surplus;
            recReservationEntry."Source Type" := SourceType;
            recReservationEntry."Source Subtype" := 1;
            recReservationEntry."Source ID" := SourceID;
            recReservationEntry."Source Ref. No." := SourceLineNo;
            recReservationEntry.Positive := (Qty > 0);
            recReservationEntry."Item Tracking" := recReservationEntry."Item Tracking"::"Lot No.";
            recReservationEntry."Lot No." := LotNo;
            recReservationEntry.Insert(true);
        end;

        recReservationEntry."Qty. per Unit of Measure" := 1;
        recReservationEntry.Validate("Quantity (Base)", Qty);
        recReservationEntry.Modify;
    end;

    [Scope('Internal')]
    procedure GetConsumedItemLotNo(AssemblyLine: Record "Assembly Line") RetLotNo: Text[30]
    var
        recConsumedItem: Record "Consumed Item";
    begin

        RetLotNo := '';
        recConsumedItem.Reset;
        recConsumedItem.SetRange("Work Order No.", AssemblyLine."Work Order No.");
        recConsumedItem.SetRange("Line No.", AssemblyLine."Consumed Item Line No.");
        recConsumedItem.SetFilter("Lot No.", '<>%1', '');
        if recConsumedItem.FindFirst() then
            RetLotNo := recConsumedItem."Lot No.";
    end;

    [Scope('Internal')]
    procedure CheckConsumedItems(WONo: Text[30])
    var
        recConsumedItem: Record "Consumed Item";
    begin

        recConsumedItem.Reset;
        recConsumedItem.SetRange("Work Order No.", WONo);
        recConsumedItem.SetFilter("Quantity to Consume", '>0');
        recConsumedItem.SetRange(Type, recConsumedItem.Type::Item);
        if recConsumedItem.FindSet() then begin
            repeat
                recConsumedItem.TestField("Unit of Measure Code");    //SOC-MA 08-08-15
                recConsumedItem.CalcFields("Tracking Enabled");
                if recConsumedItem."Tracking Enabled" then
                    recConsumedItem.TestField("Lot No.");
                recConsumedItem.TestField("Location Code");
                if LocationRequiresBin(recConsumedItem."Location Code") then
                    recConsumedItem.TestField("Bin Code");
            until recConsumedItem.Next = 0;
        end else begin
            Error('Nothing to Consume.');
        end;
    end;

    [Scope('Internal')]
    procedure LocationRequiresBin(LocationCode: Code[30]) RetRequiresBin: Boolean
    var
        recLoc: Record Location;
    begin

        RetRequiresBin := false;

        if recLoc.Get(LocationCode) then
            RetRequiresBin := recLoc."Bin Mandatory";
    end;

    [Scope('Internal')]
    procedure GetProducedItemLotNo(AssemblyHeader: Record "Assembly Header") RetLotNo: Text[30]
    var
        recProducedItem: Record "Produced Item";
    begin

        RetLotNo := '';
        if recProducedItem.Get(AssemblyHeader."Work Order No.", AssemblyHeader."Produced Item Line No.") then
            RetLotNo := recProducedItem."Lot No.";
    end;

    [Scope('Internal')]
    procedure CheckProducedItems(WONo: Text[30])
    var
        recProducedItem: Record "Produced Item";
    begin
        //SOC-MA 08-08-15

        recProducedItem.Reset;
        recProducedItem.SetRange("Work Order No.", WONo);
        recProducedItem.SetFilter("Quantity to Assemble", '>0');
        recProducedItem.SetFilter("Item No.", '<>%1', '');
        if recProducedItem.FindSet() then begin
            repeat
                //recProducedItem.CALCFIELDS("Tracking Enabled");
                //IF recProducedItem."Tracking Enabled" THEN
                //  recProducedItem.TESTFIELD("Lot No.");
                recProducedItem.TestField("Unit of Measure Code");
                recProducedItem.TestField("Location Code");
                if LocationRequiresBin(recProducedItem."Location Code") then
                    recProducedItem.TestField("Bin Code");
            until recProducedItem.Next = 0;
        end else begin
            Error('Nothing to Produce.');
        end;
    end;

    [Scope('Internal')]
    procedure CheckLotAvailability(ConsumedItem: Record "Consumed Item")
    var
        recILE: Record "Item Ledger Entry";
        dAvailableQty: Decimal;
        recBinContent: Record "Bin Content";
        recConsumedItem: Record "Consumed Item";
        dDemandQty: Decimal;
        dBaseQtyToConsume: Decimal;
    begin
        with ConsumedItem do begin
            if Type = Type::Item then begin
                if ("Lot No." <> '') and ("Quantity to Consume" > 0) then begin
                    dAvailableQty := 0;
                    recILE.Reset;
                    recILE.SetRange("Item No.", "No.");
                    recILE.SetRange("Location Code", "Location Code");
                    recILE.SetRange(Open, true);
                    recILE.SetRange("Lot No.", "Lot No.");
                    if recILE.FindSet() then begin
                        repeat
                            dAvailableQty += recILE."Remaining Quantity";
                        until recILE.Next = 0;
                    end;
                    //IF dAvailableQty < "Quantity to Consume" THEN
                    if dAvailableQty < "Quantity to Consume (Base)" then
                        Error('Quantity to Consume (%1) > Remaining Quantity (%2) for Lot No. %3 in Location %4',
                                      "Quantity to Consume (Base)", dAvailableQty, "Lot No.", "Location Code");
                end;
                if ("Bin Code" <> '') and ("Quantity to Consume" > 0) then begin
                    dAvailableQty := 0;
                    recBinContent.Reset;
                    recBinContent.SetRange("Item No.", "No.");
                    recBinContent.SetRange("Location Code", "Location Code");
                    recBinContent.SetRange("Bin Code", "Bin Code");
                    recBinContent.SetRange("Variant Code", "Variant Code");
                    if recBinContent.FindSet() then begin
                        repeat
                            recBinContent.CalcFields("Quantity (Base)");
                            dAvailableQty += recBinContent."Quantity (Base)";
                        until recBinContent.Next = 0;
                    end;
                    if dAvailableQty < "Quantity to Consume (Base)" then
                        Error('Quantity to Consume (%1) > Bin Quantity (%2) for Bin Code %3', "Quantity to Consume (Base)", dAvailableQty, "Bin Code");

                end;
                if ("Quantity to Consume" > 0) then begin
                    //calculate supply
                    dAvailableQty := 0;
                    recILE.Reset;
                    recILE.SetRange("Item No.", "No.");
                    recILE.SetRange("Location Code", "Location Code");
                    recILE.SetRange(Open, true);
                    //recILE.SETRANGE("Lot No.", "Lot No.");
                    if recILE.FindSet() then begin
                        repeat
                            dAvailableQty += recILE."Remaining Quantity";
                        until recILE.Next = 0;
                    end;

                    //calculate demand without this line
                    recConsumedItem.Reset;
                    recConsumedItem.SetRange(Type, Type);
                    recConsumedItem.SetRange("No.", "No.");
                    recConsumedItem.SetFilter("Quantity to Consume", '<>0');
                    if recConsumedItem.FindSet() then begin
                        repeat
                            if (recConsumedItem."Work Order No." = "Work Order No.") and (recConsumedItem."Line No." = "Line No.") then begin
                            end else begin
                                //dDemandQty += recConsumedItem."Quantity to Consume";
                                dDemandQty := recConsumedItem."Quantity to Consume (Base)";   //SOC-MA 12-01-15
                            end;
                        until recConsumedItem.Next = 0;
                    end;

                    //IF dAvailableQty < (dDemandQty + "Quantity to Consume") THEN
                    if dAvailableQty < (dDemandQty + "Quantity to Consume (Base)") then //SOC-MA 12-01-15
                        Message('Available Quantity %1 in this locaion is less than required quantity %2', (dAvailableQty - dDemandQty), "Quantity to Consume (Base)");
                end;

            end;
        end;
    end;
}

