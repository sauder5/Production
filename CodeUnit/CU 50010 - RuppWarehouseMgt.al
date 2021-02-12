codeunit 50010 "Rupp Warehouse Mgt"
{
    // //RSI-KS 12-26-15
    //   Routine added to pre-check Canadian orders
    // 
    // //SOC-SC 01-07-16
    //   When creating pick from the SO using <Create Rupp Pick>, reset the "Do not fill qty. to handle" filter to FALSE in the Options tab
    // 
    // //RSI-KS 01-28-16
    //   Always create a new warehouse shipment when generating picks


    trigger OnRun()
    var
        recSH: Record "Sales Header";
    begin
        recSH.Get(recSH."Document Type"::Order, 'SO-000322');
        //CreateRuppWhsePick(recSH);
        PrintRuppWhsePick(recSH);
    end;

    var
        Text003: Label 'The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text004: Label 'No %1 was found. The warehouse shipment could not be created.';
        Text011: Label 'Nothing to handle.';

    [Scope('Internal')]
    procedure CreateRuppWhsePick(recSH: Record "Sales Header")
    var
        recWAL: Record "Warehouse Activity Line";
        recWhseShptLn: Record "Warehouse Shipment Line";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhseRqst: Record "Warehouse Request";
        recWhseShptHdr: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report "Get Source Documents";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
        CreatePickFromWhseShpt: Report "Whse.-Shipment - Create Pick";
        RuppBusLogic: Codeunit "Rupp Business Logic";
    begin
        //Called from page 42. Creates Warehouse Shipment if not already created, creates Warehouse Pick if not already created and opens Whse Shpt if the user confirms
        //The goal is to have all sales lines of this order on the same Warehouse Shipment and maybe multiple Warehouse Picks
        //If no picks have been created yet, then simply create a Pick
        //If pick already exists and the user clicks Create Pick and Print from the Warehouse Shipment, then create a new (diff) Whse Pick and print it
        RuppBusLogic.ReleaseSO(recSH);
        recSH.TestField(Status, recSH.Status::Released);
        recWAL.Reset();
        recWAL.SetRange("Source Type", 37);
        recWAL.SetRange("Source Subtype", recSH."Document Type");
        recWAL.SetRange("Source No.", recSH."No.");
        recWAL.SetRange("Location Code", 'RUPP');
        //IF NOT recWAL.FINDFIRST() THEN BEGIN
        //  IF NOT CONFIRM('Do you want to create Pick for Sales Order %1', FALSE, recSH."No.") THEN BEGIN
        //    EXIT;
        //  END;

        //  recWhseShptLn.RESET();
        //  recWhseShptLn.SETRANGE("Source Type", 37);
        //  recWhseShptLn.SETRANGE("Source Subtype", recSH."Document Type");
        //  recWhseShptLn.SETRANGE("Source No.", recSH."No.");
        //  IF NOT recWhseShptLn.FINDSET() THEN BEGIN
        //Create WhseShpt
        //GetSourceDocOutbound.CreateFromSalesOrder(RecSH);
        with recSH do begin
            TestField(Status, Status::Released);
            if WhseShpmntConflict("Document Type", "No.", "Shipping Advice") then
                Error(Text003, Format("Shipping Advice"));
            GetSourceDocOutbound.CheckSalesHeader(recSH, true);
            WhseRqst.SetRange(Type, WhseRqst.Type::Outbound);
            WhseRqst.SetRange("Source Type", DATABASE::"Sales Line");
            WhseRqst.SetRange("Source Subtype", "Document Type");
            WhseRqst.SetRange("Source No.", "No.");
            WhseRqst.SetRange("Document Status", WhseRqst."Document Status"::Released);
            GetRequireShipRqst(WhseRqst);
        end;

        if WhseRqst.FindFirst then begin //OpenWarehouseShipmentPage(WhseRqst);
            GetSourceDocuments.UseRequestPage(false);
            GetSourceDocuments.SetTableView(WhseRqst);
            GetSourceDocuments.RunModal;
            GetSourceDocuments.GetLastShptHeader(recWhseShptHdr);
            recWhseShptLn.SetRange("No.", recWhseShptHdr."No.");
        end else begin
            Message(Text004, WhseRqst.TableCaption);
        end;
        //  END ELSE BEGIN
        //    recWhseShptHdr.GET(recWhseShptLn."No.");
        //  END;

        //Create Pick
        if recWhseShptHdr.Status = recWhseShptHdr.Status::Open then
            ReleaseWhseShipment.Release(recWhseShptHdr);

        //CreatePickDoc(recWhseShptLn,recWhseShptHdr);
        recWhseShptLn.SetFilter(Quantity, '>0');
        recWhseShptLn.SetRange("Completely Picked", false);
        if recWhseShptLn.Find('-') then begin
            Clear(CreatePickFromWhseShpt);
            CreatePickFromWhseShpt.SetWhseShipmentLine(recWhseShptLn, recWhseShptHdr);
            CreatePickFromWhseShpt.Initialize('', 0, false, false, false);  //SOC-SC 01-07-16
            CreatePickFromWhseShpt.SetHideValidationDialog(true);//HideValidationDialog);
            CreatePickFromWhseShpt.UseRequestPage(false);//NOT HideValidationDialog);
            CreatePickFromWhseShpt.RunModal;
            CreatePickFromWhseShpt.GetResultMessage;
            Clear(CreatePickFromWhseShpt);
        end else
            Message(Text011);
        //END;
    end;

    local procedure GetRequireShipRqst(var WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        if WhseRqst.FindSet then begin
            repeat
                if Location.RequireShipment(WhseRqst."Location Code") then
                    LocationCode += WhseRqst."Location Code" + '|';
            until WhseRqst.Next = 0;
            if LocationCode <> '' then
                LocationCode := CopyStr(LocationCode, 1, StrLen(LocationCode) - 1);
            WhseRqst.SetFilter("Location Code", LocationCode);
        end;
    end;

    [Scope('Internal')]
    procedure PrintRuppWhsePick(recSH: Record "Sales Header")
    var
        recWhseShptLn: Record "Warehouse Shipment Line";
        recWAL: Record "Warehouse Activity Line";
        recWhseShptHdr: Record "Warehouse Shipment Header";
        WhseActPrint: Codeunit "Warehouse Document-Print";
        recWAH: Record "Warehouse Activity Header";
        cPrevPickNo: Code[20];
        repPickTicket: Report "Pick Ticket per Order";
    begin
        //Called from page 42
        //Print Pick
        /*recSH.SETRECFILTER();
        REPORT.RUNMODAL(50018, TRUE, FALSE, recSH);
        COMMIT;
        */

        recWAL.SetCurrentKey("Source Document", "Source No.", "Location Code");
        recWAL.SetRange("Source Type", 37);
        recWAL.SetRange("Source Subtype", recSH."Document Type");
        recWAL.SetRange("Source No.", recSH."No.");
        recWAL.SetRange("Location Code", 'RUPP');
        if recWAL.FindSet() then begin
            recWAH.Reset();
            cPrevPickNo := '';
            repeat
                if recWAL."No." <> cPrevPickNo then begin
                    recWAH.SetRange(Type, recWAL."Activity Type");
                    recWAH.SetRange("No.", recWAL."No.");
                    recWAH.FindFirst();
                    recWAH.Mark(true);
                end;
                cPrevPickNo := recWAL."No.";
            until recWAL.Next = 0;

            recWAH.SetRange(Type);
            recWAH.SetRange("No.");
            if recWAH.MarkedOnly(true) then begin
                Commit;
                recWAH.FindSet();
                Clear(repPickTicket);
                repPickTicket.SetSalesHdrNo(recSH."No.");
                repPickTicket.SetTableView(recWAH);
                repPickTicket.RunModal();
                Clear(repPickTicket);
                //REPORT.RUNMODAL(50030, TRUE, FALSE, recWAH);
            end;
        end;

        /*
        recWhseShptLn.RESET();
        recWhseShptLn.SETRANGE("Source Type", 37);
        recWhseShptLn.SETRANGE("Source Subtype", recSH."Document Type");
        recWhseShptLn.SETRANGE("Source No.", recSH."No.");
        IF recWhseShptLn.FINDFIRST THEN BEGIN
          recWhseShptHdr.RESET();
          recWhseShptHdr.SETRANGE("No.", recWhseShptLn."No.");
          recWhseShptHdr.FINDSET();
          recWhseShptHdr.SETRECFILTER();
          REPORT.RUNMODAL(50013, TRUE, FALSE, recWhseShptHdr);
        END;
        */

    end;

    [Scope('Internal')]
    procedure DeleteRuppWhsePick(recSH: Record "Sales Header")
    var
        recWAL: Record "Warehouse Activity Line";
        recWhseShptLn: Record "Warehouse Shipment Line";
        recWAH: Record "Warehouse Activity Header";
        cPrevPickNo: Code[20];
        recWhseShptHdr: Record "Warehouse Shipment Header";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        //Called from page 42

        //Check
        if recSH."Shipping Status" in [recSH."Shipping Status"::Picked, recSH."Shipping Status"::Packing] then
            if not Confirm('Order''s Shipping Status is %1.\ Please contact the Warehouse prior to delete', false, recSH."Shipping Status") then
                exit;

        recWhseShptLn.Reset();
        recWhseShptLn.SetRange("Source Type", 37);
        recWhseShptLn.SetRange("Source Subtype", recSH."Document Type");
        recWhseShptLn.SetRange("Source No.", recSH."No.");

        recWAL.Reset();
        recWAL.SetRange("Source Type", 37);
        recWAL.SetRange("Source Subtype", recSH."Document Type");
        recWAL.SetRange("Source No.", recSH."No.");
        recWAL.SetRange("Location Code", 'RUPP');
        if (recWAL.Count > 0) or (recWhseShptLn.Count > 0) then begin
            if not Confirm('Do you want to delete Pick(s) for Sales Order %1', false, recSH."No.") then begin
                exit;
            end;
        end else
            exit;

        if recWAL.FindSet() then begin
            recWAH.Reset();
            cPrevPickNo := '';
            repeat
                if recWAL."No." <> cPrevPickNo then begin
                    recWAH.SetRange(Type, recWAL."Activity Type");
                    recWAH.SetRange("No.", recWAL."No.");
                    recWAH.FindFirst();
                    recWAH.Mark(true);
                end;
                cPrevPickNo := recWAL."No.";
            until recWAL.Next = 0;

            recWAH.SetRange(Type);
            recWAH.SetRange("No.");
            if recWAH.MarkedOnly(true) then begin
                recWAH.FindSet();
                recWAH.DeleteAll(true);
            end;
        end;

        if recWhseShptLn.FindFirst() then begin
            recWhseShptHdr.Get(recWhseShptLn."No.");
            if recWhseShptHdr.Status <> recWhseShptHdr.Status::Open then begin
                ReleaseWhseShipment.Reopen(recWhseShptHdr);
                Commit;
            end;
            recWhseShptHdr.Get(recWhseShptLn."No.");
            recWhseShptHdr.Delete(true);
        end;

        Commit;
        Message('Pick has been deleted. Please contact the Warehouse to destroy any pick tickets for this order');
    end;

    [Scope('Internal')]
    procedure OpenRuppWhseShpt(recSH: Record "Sales Header")
    var
        recWhseShptLn: Record "Warehouse Shipment Line";
        recWhseShptHdr: Record "Warehouse Shipment Header";
    begin
        //Called from page 42
        recWhseShptLn.Reset();
        recWhseShptLn.SetRange("Source Type", 37);
        recWhseShptLn.SetRange("Source Subtype", recSH."Document Type");
        recWhseShptLn.SetRange("Source No.", recSH."No.");
        if recWhseShptLn.FindFirst then begin
            recWhseShptHdr.Reset();
            recWhseShptHdr.Get(recWhseShptLn."No.");
            PAGE.RunModal(7335, recWhseShptHdr);
        end;
    end;

    [Scope('Internal')]
    procedure GetCreditCardAuthNo(SalesHdr: Record "Sales Header"; var retCaption: Text[30]; var retCreditCardAuthNo: Code[30]) retOK: Boolean
    var
        recEFTTransaction: Record "EFT Transaction -CL-";
        recPmtMethod: Record "Payment Method";
    begin
        //Called from report 50010 and from Sales Order screen
        retCreditCardAuthNo := '';
        retCaption := '';
        retOK := true;
        if recPmtMethod.Get(SalesHdr."Payment Method Code") then begin
            if recPmtMethod."EFT Tender Type -CL-" = recPmtMethod."EFT Tender Type -CL-"::"Credit Card" then begin
                recEFTTransaction.SetCurrentKey("Document Type", "Document No.", "Date Created", "Time Created");
                recEFTTransaction.SetRange("Document Type", SalesHdr."Document Type");
                recEFTTransaction.SetRange("Document No.", SalesHdr."No.");
                recEFTTransaction.SetFilter("Expiration Filter", '<%1', WorkDate);
                recEFTTransaction.SetFilter("Transaction Status", 'Approved');
                if recEFTTransaction.FindLast() then begin
                    //retCreditCardAuthNo := recEFTTransaction."Reference Number";//recEFTTransaction."Approval Number";
                    retCreditCardAuthNo := recEFTTransaction."Approval Number";
                    retCaption := 'Credit Card Auth No.: ';
                end else begin
                    retOK := false;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure SeedSummaryFromManifest(Manifest: Record "Manifest Header")
    var
        recManifestLine: Record "Manifest Line";
        recSeedSummary: Record "Seed Summary";
        recPostedPkgLn: Record "Posted Package Line";
        sPrevProductNoAndLotNo: Text[50];
    begin
        /*
        //Called from Manifest page
        
        IF NOT Manifest.Posted THEN BEGIN
          recSeedSummary.RESET();
          recSeedSummary.SETRANGE("No.", Manifest."No.");
          IF recSeedSummary.FINDSET() THEN BEGIN
            recSeedSummary.DELETEALL();
          END;
        
          recPostedPkgLn.RESET();
        
          recManifestLine.RESET();
          recManifestLine.SETRANGE("Manifest No.", Manifest."No.");
          recManifestLine.SETRANGE(Type, recManifestLine.Type::Package);
          IF recManifestLine.FINDSET() THEN BEGIN
            REPEAT
              recPostedPkgLn.SETRANGE("Package No.", recManifestLine."No.");
              IF recPostedPkgLn.FINDSET() THEN BEGIN
                REPEAT
                  recPostedPkgLn.MARK(TRUE);
                UNTIL recPostedPkgLn.NEXT = 0;
              END;
            UNTIL recManifestLine.NEXT = 0;
        
            recPostedPkgLn.SETRANGE("Package No.");
            IF recPostedPkgLn.MARKEDONLY(TRUE) THEN BEGIN
              recPostedPkgLn.SETCURRENTKEY("Product No.","Internal Lot No.");
              IF recPostedPkgLn.FINDSET() THEN BEGIN
                REPEAT
                  //IF sPrevProductNoAndLotNo <> (recPostedPkgLn."Product No." + ',' + recPostedPkgLn."Internal Lot No.") THEN BEGIN
                    IF recSeedSummary.GET(Manifest."No.", recPostedPkgLn."Product No.", recPostedPkgLn."Internal Lot No.") THEN BEGIN
                      recSeedSummary.VALIDATE("Actual Weight in g", recSeedSummary."Actual Weight in g" + recPostedPkgLn."Line Seed Weight");
                      recSeedSummary.MODIFY();
                    END ELSE BEGIN
                      recSeedSummary.INIT();
                      recSeedSummary."No." := Manifest."No.";
                      recSeedSummary."Product Code" := recPostedPkgLn."Product No.";
                      recSeedSummary."Internal Lot No."      := recPostedPkgLn."Internal Lot No.";
                      recSeedSummary.VALIDATE("Actual Weight in g", recPostedPkgLn."Line Seed Weight");
                      recSeedSummary.INSERT();
                    END;
                  //  sPrevProductNoAndLotNo := recPostedPkgLn."Product No." + ',' + recPostedPkgLn."Internal Lot No.";
                  //END;
                UNTIL recPostedPkgLn.NEXT = 0;
                COMMIT;
              END;
            END;
          END;
        END;
        
        recSeedSummary.RESET();
        recSeedSummary.SETRANGE("No.", Manifest."No.");
        IF recSeedSummary.FINDSET() THEN BEGIN
          PAGE.RUNMODAL(0, recSeedSummary);
        END ELSE BEGIN
          ERROR('No Seed Summary to display');
        END;
        */

    end;

    [Scope('Internal')]
    procedure UpdateSeedWeight(var FastPackLineTmp: Record "Fast Pack Line"; PackingControl: Record "Packing Control"; ShippingSetup: Record "Shipping Setup"; PackingStation: Record "Packing Station")
    var
        PackageLine: Record "Package Line";
    begin
        /*
        ShippingSetup.GET();
        
        PackageLine.RESET;
        PackageLine.SETCURRENTKEY("Source Type","Source Subtype","Source ID","No.","Variant Code");
        PackageLine.SETRANGE("Source Type",PackingControl."Source Type");
        PackageLine.SETRANGE("Source Subtype",PackingControl."Source Subtype");
        IF FastPackLineTmp."From Source ID" <> '' THEN
          PackageLine.SETRANGE("Source ID",FastPackLineTmp."From Source ID")
        ELSE
          IF PackingControl."Multi Document Package" THEN
            PackageLine.SETFILTER("Source ID",PackingControl."Multi Document No.")
          ELSE
            PackageLine.SETRANGE("Source ID",PackingControl."Source ID");
        PackageLine.SETRANGE(Type,FastPackLineTmp.Type);
        PackageLine.SETRANGE("No.",FastPackLineTmp."No.");
        PackageLine.SETRANGE("Variant Code",FastPackLineTmp."Variant Code");
          IF ShippingSetup."Location Packing" THEN
            PackageLine.SETRANGE("Location Code",PackingStation."Location Code");
        IF PackageLine.FINDSET() THEN BEGIN
          //MESSAGE('Unit Seed Weight is %1', FastPackLineTmp."Unit Seed Weight");
          REPEAT
            PackageLine.VALIDATE("Unit Seed Weight", FastPackLineTmp."Unit Seed Weight");
            PackageLine.MODIFY();
          UNTIL PackageLine.NEXT = 0;
        END;
        */

    end;

    [Scope('Internal')]
    procedure SeedSummaryFromSeedWksh(var SeedWorksheetLines: Record "Order Line Seed Worksheet Line")
    var
        recSeedSummaryTemp: Record "Seed Summary" temporary;
        sPrevProductNoAndLotNo: Text[50];
        cSeedSummaryNo: Code[20];
        lVariety: Text;
        lProduct: Text;
    begin
        //Called from Seed Worksheet page

        if SeedWorksheetLines.FindSet() then begin
            cSeedSummaryNo := Format(SeedWorksheetLines."Batch No.") + Format(SeedWorksheetLines."Created DateTime");
            recSeedSummaryTemp.Reset();
            recSeedSummaryTemp.SetRange("No.", cSeedSummaryNo);
            if recSeedSummaryTemp.FindSet() then begin
                recSeedSummaryTemp.DeleteAll();
            end;

            repeat
                //RSI-KS
                lProduct := ConvertStr(SeedWorksheetLines."Product Code", '.', ',');
                lVariety := SelectStr(1, lProduct);

                //    IF recSeedSummaryTemp.GET(cSeedSummaryNo, SeedWorksheetLines."Product Code", SeedWorksheetLines."Internal Lot No.") THEN BEGIN
                if recSeedSummaryTemp.Get(cSeedSummaryNo, lVariety, SeedWorksheetLines."Internal Lot No.") then begin
                    recSeedSummaryTemp.Validate("Actual Weight in g", recSeedSummaryTemp."Actual Weight in g" + SeedWorksheetLines."Line Seed Weight in g");
                    recSeedSummaryTemp.Modify();
                end else begin
                    recSeedSummaryTemp.Init();
                    recSeedSummaryTemp."No." := cSeedSummaryNo;
                    //      recSeedSummaryTemp."Product Code" := SeedWorksheetLines."Product Code";
                    recSeedSummaryTemp."Product Code" := lVariety;
                    recSeedSummaryTemp."Seed Size" := SeedWorksheetLines."Seed Size";
                    recSeedSummaryTemp."Internal Lot No." := SeedWorksheetLines."Internal Lot No.";
                    recSeedSummaryTemp.Validate("Actual Weight in g", SeedWorksheetLines."Line Seed Weight in g");
                    recSeedSummaryTemp.Insert();
                end;
            until SeedWorksheetLines.Next = 0;
            Commit;
            SeedWorksheetLines.FindSet();
        end;

        recSeedSummaryTemp.Reset();
        recSeedSummaryTemp.SetRange("No.", cSeedSummaryNo);
        if recSeedSummaryTemp.FindSet() then begin
            PAGE.RunModal(0, recSeedSummaryTemp);
        end else begin
            Error('No Seed Summary to display');
        end;
    end;

    [Scope('Internal')]
    procedure CheckShipment(recWHSHead: Record "Warehouse Shipment Header")
    var
        recWHSLines: Record "Warehouse Shipment Line";
        recSalesHead: Record "Sales Header";
        UPSOptionPage: Record "UPS Option Page";
        sError: Text;
        sPrevOrder: Text;
    begin
        sError := '';
        sPrevOrder := '';
        recWHSLines.SetCurrentKey("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
        recWHSLines.SetFilter("No.", recWHSHead."No.");

        if recWHSLines.FindSet then begin
            repeat
                if recSalesHead.Get(recWHSLines."Source Subtype", recWHSLines."Source No.") then begin
                    if recWHSLines."Source No." <> sPrevOrder then begin
                        sPrevOrder := recWHSLines."Source No.";
                        if recSalesHead."Ship-to Country/Region Code" <> 'CA' then
                            sError := sError + 'Order ' + recWHSLines."Source No." + ' is not a Canadian Order.' + '\';
                        if recSalesHead."Ship-to Phone No. -CL-" = '' then
                            sError := sError + 'Order ' + recWHSLines."Source No." + ' has missing shipping phone #' + '\';

                        UPSOptionPage.SetFilter(Type, 'Master Data');
                        UPSOptionPage.SetFilter("Source ID", recSalesHead."Sell-to Customer No.");
                        UPSOptionPage.SetFilter("Source Type", '%1', 18);
                        UPSOptionPage.SetFilter("Source Subtype", '%1', 1);
                        UPSOptionPage.SetFilter("Shipping Agent Code", recSalesHead."Shipping Agent Code");
                        UPSOptionPage.SetFilter("Shipping Agent Service", recSalesHead."E-Ship Agent Service");

                        if UPSOptionPage.FindSet then begin
                            if UPSOptionPage."World Ease" = false then
                                sError := sError + 'Order ' + recWHSLines."Source No." + ' is not marked for World Ease' + '\';
                        end
                        else
                            sError := sError + 'Order ' + recWHSLines."Source No." + ' is not marked for World Ease' + '\';
                    end;
                    recWHSLines.CalcFields(recWHSLines."Missing Reqd License", recWHSLines."Missing Reqd Liability Waiver",
                                             recWHSLines."Missing Reqd Quality Release");
                    if recWHSLines."Qty. to Pick" > 0 then
                        if recWHSLines."Missing Reqd License" = true or
                          recWHSLines."Missing Reqd Liability Waiver" = true or
                           recWHSLines."Missing Reqd Quality Release" = true then
                            sError := sError + 'Order ' + recWHSLines."Source No." + '/Item ' + recWHSLines."Item No." + ' has missing compliances' + '\';
                    if recWHSLines.Description = '' then
                        sError := sError + 'Order ' + recWHSLines."Source No." + ' has a blank line' + '\';
                end;
            until recWHSLines.Next = 0;
        end;

        if sError > '' then
            Message(sError);
    end;
}

