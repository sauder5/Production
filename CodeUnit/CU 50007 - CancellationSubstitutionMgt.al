codeunit 50007 "Cancellation Substitution Mgt."
{
    // //SOC-SC 12-16-15
    //   As per Kristen, when cancelling, if there are whse shpt lines for the sales line without any picks, then delete them. Also popualte Unit Price Reason Code.
    // 
    // //SOC-SC 12-28-15
    //   After cancelling, if the order was released, then re-release it only if there are lines with Outstanding Quantity
    // 
    // //SOC-SC 01-06-16
    //   When cancelling, prevent user from getting confirmation pop up for compliances at the time of releasing SO
    // 
    // //SOC-SC 01-07-16
    //   Re-get the Warehouse Shipment after reopening for deletion in Substitute/Cancel function


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure InventoryStatusValidateFromProduct(var Product: Record Product)
    begin
        //Called from Product table, "Inventory Status" OnValidate
        //Called from Products page as well

        with Product do begin
            if "Inventory Status Code" <> '' then begin
                CalcFields("Qty. on Sales Orders");
                if "Qty. on Sales Orders" > 0 then begin
                    if Confirm('There are outstanding sales lines. Do you want to cancel/substitute?', false) then begin
                        Modify();
                        PAGE.Run(50060, Product);
                    end;
                end;
            end else begin
                Message('Product %1 has no Inventory Status Code', Code);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure InventoryStatusValidateFromItem(var Item: Record Item)
    var
        recInvStatus: Record "Rupp Reason Code";
    begin
        //Called from Item table, "Inventory Status" OnValidate

        with Item do begin
            //MESSAGE('Inventory Status Code is %1', "Inventory Status Code");
            if "Inventory Status Code" <> '' then begin
                recInvStatus.Get(recInvStatus.Type::"Inventory Status", "Inventory Status Code");
                recInvStatus.TestField("Inv. Status Line Cancel Reason");
                CalcFields("Qty. on Sales Order");
                if "Qty. on Sales Order" > 0 then begin
                    if Confirm('There are outstanding sales lines. Do you want to substitute?', false) then begin
                        Modify(); //needed in order to see the change in the "Inventory Status Code". Without the modify, it still sees the old Inventory Status Code, if not blank
                        PAGE.Run(50061, Item);
                    end;
                end;
            end else begin
                Message('Item %1 has no Inventory Status Code', "No.");
            end;
        end;
    end;

    [Scope('Internal')]
    procedure DeletePick(SalesLn: Record "Sales Line")
    var
        recWhseActLn: Record "Warehouse Activity Line";
        recWhseActLn2: Record "Warehouse Activity Line";
        recWhseActHdr: Record "Warehouse Activity Header";
        bDeletedPick: Boolean;
    begin
        //Called from page 50062
        recWhseActLn.Reset();
        recWhseActLn.SetRange("Source Type", 37);
        recWhseActLn.SetRange("Source Subtype", SalesLn."Document Type");
        recWhseActLn.SetRange("Source No.", SalesLn."Document No.");
        recWhseActLn.SetRange("Source Line No.", SalesLn."Line No.");
        if recWhseActLn.FindSet() then begin //there could be multiple picks for the same sales line
            repeat
                //If there are pick lines for the other lines on sames pick, then just delete the pick line. Else, delete the Pick itself
                recWhseActLn2.SetRange("Activity Type", recWhseActLn."Activity Type");
                recWhseActLn2.SetRange("No.", recWhseActLn."No.");
                recWhseActLn2.SetFilter("Line No.", '<>%1', recWhseActLn."Line No.");
                if recWhseActLn2.FindFirst() then begin
                    recWhseActLn.Delete(true);
                    bDeletedPick := true;
                end else begin
                    recWhseActHdr.Get(recWhseActLn."Activity Type", recWhseActLn."No.");
                    recWhseActHdr.Delete(true);
                    bDeletedPick := true;
                end;
            until recWhseActLn.Next = 0;
        end;

        if bDeletedPick then begin
            Commit;
            Message('Deleted pick for sales line');
        end;
    end;

    [Scope('Internal')]
    procedure SubstituteCancel(var SalesLn: Record "Sales Line"; InventoryStatus: Code[10]; UnitPrice: Decimal)
    var
        recSL: Record "Sales Line";
        cPrevDocNo: Code[20];
        recSH: Record "Sales Header";
        bOrderNotOpen: Boolean;
        ReleaseSO: Codeunit "Release Sales Document";
        recWhseShptLn: Record "Warehouse Shipment Line";
        recWhseShptLn2: Record "Warehouse Shipment Line";
        recWhseShptHdr: Record "Warehouse Shipment Header";
        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
        recRuppReason: Record "Rupp Reason Code";
        recSL2: Record "Sales Line";
    begin
        //Called from page 50062

        //recSL.COPYFILTERS(SalesLn);
        if SalesLn.Count > 0 then begin
            //SalesLn.SETFILTER("Inventory Status Action", '%1|%2', SalesLn."Inventory Status Action"::Cancel, SalesLn."Inventory Status Action"::Substitute);
            if SalesLn.FindSet() then begin
                cPrevDocNo := '';
                repeat
                    bOrderNotOpen := false;
                    if SalesLn."Inventory Status Action" in [SalesLn."Inventory Status Action"::Substitute, SalesLn."Inventory Status Action"::Cancel] then begin
                        //If the order is not open, re-open it, perform the action and after the last line of the order is done, re-release it
                        if SalesLn."Document No." <> cPrevDocNo then begin
                            recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
                            if recSH.Status <> recSH.Status::Open then begin
                                bOrderNotOpen := true;
                                ReleaseSO.PerformManualReopen(recSH);
                            end;
                        end;

                        //If Action is 'Substitute', then add a new sales line
                        if SalesLn."Inventory Status Action" = SalesLn."Inventory Status Action"::Substitute then begin
                            SalesLn.TestField("Substituted Item No.");
                            CreateSubsLine(SalesLn, UnitPrice);
                        end;

                        //SOC-SC 12-16-15
                        //If there are a warehouse shipment line not having pick lines for this sales line, then delete it
                        recWhseShptLn.Reset();
                        recWhseShptLn.SetRange("Source Document", recWhseShptLn."Source Document"::"Sales Order");
                        recWhseShptLn.SetRange("Source Subtype", SalesLn."Document Type");
                        recWhseShptLn.SetRange("Source No.", SalesLn."Document No.");
                        recWhseShptLn.SetRange("Source Line No.", SalesLn."Line No.");
                        if recWhseShptLn.FindSet() then begin
                            recWhseShptLn.CalcFields("Pick Qty.");
                            if recWhseShptLn."Pick Qty." = 0 then begin
                                DeleteWSLn(recWhseShptLn);
                            end;
                        end;
                        //SOC-SC 12-16-15

                        //Cancel the Outstanding Quantity on the line in question
                        SalesLn.Validate("Qty. Cancelled", SalesLn."Qty. Cancelled" + SalesLn."Outstanding Quantity");
                        recRuppReason.Reset();
                        recRuppReason.SetRange(Type, recRuppReason.Type::"Inventory Status");
                        recRuppReason.SetRange(Code, InventoryStatus);
                        recRuppReason.FindFirst();
                        recRuppReason.TestField(recRuppReason."Inv. Status Line Cancel Reason");

                        SalesLn.Validate("Cancelled Reason Code", recRuppReason."Inv. Status Line Cancel Reason");
                        SalesLn.Validate("Inventory Status Action", SalesLn."Inventory Status Action"::" ");
                        SalesLn."Unit Price Reason Code" := InventoryStatus; //SOC-SC 12-16-15
                        SalesLn.Modify(true);
                    end;

                    //if it's the last line of the order, then re-release it
                    cPrevDocNo := SalesLn."Document No.";
                    if bOrderNotOpen then begin
                        /*//SOC-SC 12-28-15 commenting
                        IF SalesLn.NEXT = 0 THEN BEGIN
                            ReleaseSO.PerformManualRelease(recSH);
                        END ELSE BEGIN
                          IF SalesLn."Document No." <> cPrevDocNo THEN BEGIN
                            ReleaseSO.PerformManualRelease(recSH);
                          END;
                        END;
                        SalesLn.NEXT(-1);
                        */

                        //SOC-SC 12-28-15
                        recSL2.Reset();
                        recSL2.SetRange("Document Type", recSH."Document Type");
                        recSL2.SetRange("Document No.", recSH."No.");
                        recSL2.SetFilter("Outstanding Quantity", '>%1', 0);
                        if recSL2.FindFirst() then begin
                            if SalesLn.Next = 0 then begin
                                //ReleaseSO.PerformManualRelease(recSH);
                                CODEUNIT.Run(CODEUNIT::"Release Sales Document", recSH); //SOC-SC 01-06-16
                            end else begin
                                if SalesLn."Document No." <> cPrevDocNo then begin
                                    //ReleaseSO.PerformManualRelease(recSH);
                                    CODEUNIT.Run(CODEUNIT::"Release Sales Document", recSH); //SOC-SC 01-06-16
                                end;
                            end;
                            SalesLn.Next(-1);
                        end;
                        //SOC-SC 12-28-15

                    end;

                until SalesLn.Next = 0;

                //SalesLn.MODIFYALL("Inventory Status Action", SalesLn."Inventory Status Action"::" ");

                //SalesLn.SETRANGE("Inventory Status Action");
                //SalesLn.SETRANGE("Outstanding Quantity");
                //SalesLn.SETRANGE("In-process User ID", USERID);
                //SalesLn.COPY(recSL);
            end;
        end;

    end;

    [Scope('Internal')]
    procedure CreateSubsLine(SalesLn: Record "Sales Line"; UnitPrice: Decimal)
    var
        recSL: Record "Sales Line";
        iLineNo: Integer;
    begin
        recSL.Reset();
        recSL.SetRange("Document Type", SalesLn."Document Type");
        recSL.SetRange("Document No.", SalesLn."Document No.");
        recSL.SetFilter("Line No.", '>%1', SalesLn."Line No.");
        if recSL.FindFirst() then begin
            iLineNo := SalesLn."Line No." + ((recSL."Line No." - SalesLn."Line No.") div 2);
        end else begin
            iLineNo := SalesLn."Line No." + 10000;
        end;

        recSL.Init();
        recSL."Document Type" := SalesLn."Document Type";
        recSL."Document No." := SalesLn."Document No.";
        recSL."Line No." := iLineNo;
        recSL."Sell-to Customer No." := SalesLn."Sell-to Customer No.";
        recSL.Insert(true);

        recSL.Validate(Type, SalesLn.Type::Item);
        recSL.Validate("No.", SalesLn."Substituted Item No.");
        recSL.Validate("Location Code", SalesLn."Location Code");
        recSL.Validate("Qty. Requested", SalesLn."Outstanding Quantity");
        if UnitPrice > 0 then begin
            recSL.Validate("Unit Price", UnitPrice);
        end else begin
            recSL.Validate("Unit Price", SalesLn."Unit Price");
        end;
        recSL."Original Item No." := SalesLn."No.";
        recSL.Substitute := true;
        recSL.Modify();
    end;

    [Scope('Internal')]
    procedure Reopen(var SalesLn: Record "Sales Line")
    var
        ReleaseSO: Codeunit "Release Sales Document";
        recSH: Record "Sales Header";
    begin
        //Called from page 50062
        recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
        ReleaseSO.PerformManualReopen(recSH);
    end;

    [Scope('Internal')]
    procedure Release(var SalesLn: Record "Sales Line")
    var
        ReleaseSO: Codeunit "Release Sales Document";
        recSH: Record "Sales Header";
    begin
        //Called from page 50062
        recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
        ReleaseSO.PerformManualRelease(recSH);
    end;

    [Scope('Internal')]
    procedure CheckSLInventoryStatusAction(SalesLn: Record "Sales Line")
    begin
        if SalesLn."Inventory Status Action" <> SalesLn."Inventory Status Action"::" " then begin
            SalesLn.TestField("Drop Shipment", false);
            if SalesLn."Outstanding Quantity" = 0 then begin
                Error('Nothing to ship');

                if SalesLn."Inventory Status Action" = SalesLn."Inventory Status Action"::Substitute then
                    if SalesLn."Quantity Shipped" > 0 then
                        Error('cannot substitute, since the item has already been shipped');

                SalesLn.CalcFields("Pick Qty.");
                if SalesLn."Pick Qty." > 0 then
                    Error('Already picked');
            end;

        end;
    end;

    local procedure DeleteWSLn(WhseShptLn: Record "Warehouse Shipment Line")
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        recWhseShptLn2: Record "Warehouse Shipment Line";
        OrderStatus: Option;
        RuppFn: Codeunit "Rupp Functions";
        recWhseShptHdr: Record "Warehouse Shipment Header";
        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
    begin
        with WhseShptLn do begin

            recWhseShptLn2.Reset();
            recWhseShptLn2.SetRange("No.", WhseShptLn."No.");
            recWhseShptLn2.SetFilter("Line No.", '<>%1', WhseShptLn."Line No."); //Other whse shpt lines in the same whse shpt
            if recWhseShptLn2.FindFirst() then begin
                //Delete the whse shpt line
                if "Assemble to Order" then
                    Validate("Qty. to Ship", 0);

                if "Qty. Shipped" < "Qty. Picked" then
                    Error('Warehouse Shipment Line %1, %2 has Qty. Picked but not Shipped. Please delete it manually', "No.", "Line No.");

                ItemTrackingMgt.SetDeleteReservationEntries(true);
                ItemTrackingMgt.DeleteWhseItemTrkgLines(
                  DATABASE::"Warehouse Shipment Line", 0, "No.", '', 0, "Line No.", "Location Code", true);

                OrderStatus := recWhseShptHdr.GetDocumentStatus("Line No.");
                if OrderStatus <> recWhseShptHdr."Document Status" then begin
                    recWhseShptHdr.Validate("Document Status", OrderStatus);
                    recWhseShptHdr.Modify;
                end;
                RuppFn.UpdateHdrShpgStatusFromWhseShptLn(WhseShptLn, true);
                WhseShptLn.Delete();
            end else begin
                //delete the whse shpt hdr
                recWhseShptHdr.Get(WhseShptLn."No.");
                if recWhseShptHdr.Status = recWhseShptHdr.Status::Released then begin
                    ReleaseWhseShptDoc.Reopen(recWhseShptHdr);
                    recWhseShptHdr.Get(WhseShptLn."No."); //SOC-SC 01-07-16
                    recWhseShptHdr.Delete(true);
                end;
            end;
        end;
    end;
}

