codeunit 50011 RuppCodeExt
{
    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', true, true)]
    local procedure OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
            "Created By" := UserId;
            "Created Date Time" := CurrentDateTime;
            "Requested Ship Date" := WorkDate();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateShippingAgentCodeOnBeforeUpdateLines', '', true, true)]
    local procedure OnValidateShippingAgentCodeOnBeforeUpdateLines(VAR SalesHeader: Record "Sales Header"; CallingFieldNo: Integer; HideValidationDialog: Boolean)
    begin
        SalesHeader."E-Ship Agent Service" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitOutstandingAmount', '', true, true)]
    local procedure OnAfterInitOutstandingAmount(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Currency: Record Currency)
    begin
        SalesLine.UpdateUOMQuantities();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPrice', '', true, true)]
    local procedure OnBeforeUpdateUnitPrice(VAR SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; VAR Handled: Boolean)
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" then begin
            Handled := true;
            SalesLine.Validate("Unit Price");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateUnitPrice', '', true, true)]
    local procedure OnAfterUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        if NOT SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then
            Clear(SalesHeader);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
            SalesLine."Unit Price" := xSalesLine."Unit Price";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', true, true)]
    local procedure PH_OnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do begin
            "Created By" := UserId;
            "Created Date Time" := CurrentDateTime;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingAmount', '', true, true)]
    local procedure PL_OnAfterInitOutstandingAmount(VAR PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; Currency: Record Currency)
    begin
        PurchLine.UpdateUOMQuantities();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterTransferFromShptLine', '', true, true)]
    local procedure WAL_OnAfterTransferFromShptLine(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        recSH: Record "Sales Header";
        recItem: Record Item;
    begin
        with WarehouseActivityLine do Begin
            //SOC-SC 08-24-15
            CASE "Source Type" OF
                37:
                    BEGIN
                        IF recSH.GET("Source Subtype", "Source No.") THEN BEGIN
                            "Ship-to Country Code" := recSH."Ship-to Country/Region Code";
                        END;
                    END;
            END;
            //SOC-SC 08-24-15
            if not recItem.Get("Item No.") then
                clear(recItem);
            "Country of Origin Code" := recItem."Country/Region of Origin Code"; //SOC-SC 08-28-15
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"SE World Ease Master", 'OnBeforeConsolidationInsert', '', true, true)]
    local procedure WEM_OnBeforeConsolidationInsert(var recConsolidation: Record "SE World Ease Consol. Shipment"; recExportSourceLine: Record "Export Source Line")
    begin
        //SOC-SC 08-30-15
        recConsolidation.VALIDATE("Unit Seed Weight in g", recExportSourceLine."Unit Seed Weight in g");
        recConsolidation.VALIDATE("Internal Lot No.", recExportSourceLine."Internal Lot No.");
        recConsolidation.VALIDATE("Country of Origin Code", recExportSourceLine."Country of Origin Code");
        //SOC-SC 08-30-15
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', true, true)]
    local procedure CU12_OnBeforeInsertDltdCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        with DtldCustLedgEntry do begin
            "Seasonal Disc. Entry No." := GenJournalLine."Seasonal Disc. Entry No."; //SOC-SC 06-25-15
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Gen. Jnl.-Post Line", 'RuppUpdateSeasonalCodes', '', true, true)]
    local procedure CU12_RuppUpdateSeasonalCodes(var CustLedgEntry: Record "Cust. Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    var
        SeasDiscMgt: Codeunit "Seasonal Discounts Mgt.";
    begin
        //SOC-SC 06-25-15
        CustLedgEntry."Seasonal Disc. Entry No." := SeasDiscMgt.GetNextSeasDiscEntryNo();
        GenJnlLine."Seasonal Disc. Entry No." := CustLedgEntry."Seasonal Disc. Entry No.";
        CustLedgEntry."Season Code" := GenJnlLine."Seasonal Cash Disc Code";
        //SOC-SC 06-25-15
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'RuppOnAfterPostSalesDoc', '', true, true)]
    local procedure CU80_OnAfterpostSalesDoc(var recSalesHeader: Record "Sales Header"; var recCustLedgEntry: Record "Cust. Ledger Entry")
    var
        RuppFn: Codeunit "Rupp Functions";
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
    begin
        with recSalesHeader do begin
            RuppFn.UpdateSHShpgStatusOnPost(recSalesHeader);
            IF recSalesHeader.Modify() then;
            IF "Document Type" = "Document Type"::Order THEN BEGIN
                IF Invoice THEN BEGIN
                    CustPmtLinkMgt.ApplyInvoiceCLEAtPosting(recCustLedgEntry);
                END;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', true, true)]
    local procedure CU80_OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        GenJnlLine."Seasonal Cash Disc Code" := SalesHeader."Seasonal Cash Disc Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReopenSalesDoc', '', true, true)]
    local procedure CU414_OnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        RuppFun: Codeunit "Rupp Functions";
        ShipPaymentType: Option Prepaid,"Third Party","Freight Collect",Consignee;
    begin
        with SalesHeader do begin
            //RSI-KS 02-19-18 Store Shipping Payment Type
            ShipPaymentType := "Shipping Payment Type";

            RuppFun.ValidateFreightChargesOption(SalesHeader); //SOC-SC 08-09-15

            //RSI-KS 02-19-18 Reset Shipping Payment Type
            "Shipping Payment Type" := ShipPaymentType;
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnPerformManualReleaseOnBeforeTestSalesPrepayment', '', true, true)]
    local procedure CU414_OnPerformManualReleaseOnBeforeTestSalesPrepayment(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        RuppBusLogic: Codeunit "Rupp Business Logic";
    begin
        RuppBusLogic.ReleaseSO(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchase-Post Prepayments", 'OnAfterFillInvLineBuffer', '', true, true)]
    local procedure CU444_OnAfterFillInvLineBuffer(var PrepmtInvLinebuf: Record "Prepayment Inv. Line Buffer"; PurchLine: Record "Purchase Line"; CommitIsSuppressed: Boolean)
    begin
        with PrepmtInvLinebuf do begin
            "Product Code" := PurchLine."Product Code";
            "Purchase Contract No." := PurchLine."Purchase Contract No.";
            "Purchase Contract Line No." := PurchLine."Purchase Contract Inv Line No.";
            "Rcpt No." := PurchLine."Rcpt No.";
            "Auto-generating Process" := PurchLine."Auto-generating Process";
            "Rcpt Line No." := PurchLine."Rcpt Line No.";
            "Prepmt Item No." := PurchLine."No.";
            "Prepmt Line Quantity" := PurchLine."Outstanding Quantity";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purchase-Post Prepayments", 'OnBeforePurchInvLineInsert', '', true, true)]
    local procedure cu444_OnBeforePurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSupressed: Boolean)
    begin
        //SOC-SC 08-21-14
        PurchInvLine."Purchase Contract No." := PrepmtInvLineBuffer."Purchase Contract No.";
        PurchInvLine."Purchase Contract Inv Line No." := PrepmtInvLineBuffer."Purchase Contract Line No.";
        PurchInvLine."Rcpt No." := PrepmtInvLineBuffer."Rcpt No.";
        PurchInvLine."Rcpt Line No." := PrepmtInvLineBuffer."Rcpt Line No.";
        PurchInvLine."Auto-generating Process" := PrepmtInvLineBuffer."Auto-generating Process";
        //SOC-SC 08-21-14

        //SOC-SC 09-30-14
        PurchInvLine."Prepmt Item No." := PrepmtInvLineBuffer."Prepmt Item No.";
        PurchInvLine."Prepmt Line Quantity" := PrepmtInvLineBuffer."Prepmt Line Quantity";
        //SOC-SC 09-30-14
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purchase-Post Prepayments", 'OnBeforePurchCrMemoLineInsert', '', true, true)]
    local procedure cu444_OnBeforePurchCrMemoLineInsert(var PurchCrMemoLine: Record "Purch. Cr. Memo LIne"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSupressed: Boolean)
    begin
        //SOC-SC 08-21-14
        PurchCrMemoLine."Purchase Contract No." := PrepmtInvLineBuffer."Purchase Contract No.";
        PurchCrMemoLine."Purchase Contract Line No." := PrepmtInvLineBuffer."Purchase Contract Line No.";
        PurchCrMemoLine."Rcpt No." := PrepmtInvLineBuffer."Rcpt No.";
        PurchCrMemoLine."Rcpt Line No." := PrepmtInvLineBuffer."Rcpt Line No.";
        PurchCrMemoLine."Auto-generating Process" := PrepmtInvLineBuffer."Auto-generating Process";
        //SOC-SC 08-21-14

        //SOC-SC 09-30-14
        PurchCrMemoLine."Prepmt Item No." := PrepmtInvLineBuffer."Prepmt Item No.";
        PurchCrMemoLine."Prepmt Line Quantity" := PrepmtInvLineBuffer."Prepmt Line Quantity";
        //SOC-SC 09-30-14
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterCreatePickDoc', '', true, true)]
    local procedure TAB7321_OnAfterCreatePickDoc(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        SaveNo: Code[20];
    begin
        SaveNo := WarehouseShipmentHeader."No.";
        //SOC-SC 10-22-14
        with WarehouseShipmentHeader do begin
            COMMIT;
            RESET();
            SETRANGE("No.", SaveNo);
            FINDSET();
            SETRECFILTER();
            REPORT.RUNMODAL(Report::"Pick List - Warehouse Shipment", TRUE, FALSE, WarehouseShipmentHeader);
        end;
        //SOC-SC 10-22-14
    end;

    [EventSubscriber(ObjectType::Page, Page::"Fast Pack Order", 'RuppFastPackOnOpenPage', '', true, true)]
    local procedure RuppFastPackOnOpenPage(var PackingControl: Record "Packing Control"; FastPackLine: Record "Fast Pack Line")
    var
        recWHShipment: Record "Warehouse Shipment Header";
        recWHShipLine: Record "Warehouse Shipment Line";
    begin
        recWHShipLine.SetFilter("Source No.", PackingControl."Source ID");
        recWHShipLine.SetFilter("Source Subtype", '%1', PackingControl."Source Subtype");
        if not recWHShipLine.FindSet() then
            Clear(recWHShipLine);

        PackingControl."Warehouse Shipment No." := recWHShipLine."No.";

        PackingControl.TransferFromSource2;
        WITH PackingControl DO BEGIN
            IF "Warehouse Shipment No." > '' THEN
                IF recWHShipment.GET("Warehouse Shipment No.") THEN BEGIN
                    IF (recWHShipment."Shipping Agent Code" > '') AND (recWHShipment."Shipping Agent Code" <> "Shipping Agent Code") THEN
                        "Shipping Agent Code" := recWHShipment."Shipping Agent Code";
                    IF (recWHShipment."E-Ship Agent Service" > '') AND (recWHShipment."E-Ship Agent Service" <> "E-Ship Agent Service") THEN
                        "E-Ship Agent Service" := recWHShipment."E-Ship Agent Service";
                    "External Tracking No." := recWHShipment."External Tracking No.";
                END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EShip Page Subscriber Funcs", 'RuppFastPackOrders', '', true, true)]
    local procedure RuppFastPackOrders(var ShipmentNo: Code[20]; var FastPackLine: Record "Fast Pack Line")
    begin
        IF ShipmentNo > '' THEN
            FastPackLine.SETRANGE("Warehouse Shipment No.", ShipmentNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EShip Page Subscriber Funcs", 'RuppEshipOptionsAction', '', true, true)]
    local procedure RuppEshipOptionsAction(var PackingControl: Record "Packing Control"; WHShipHeader: Record "Warehouse Shipment Header")
    begin
        IF (WHShipHeader."External Tracking No." > '') AND (WHShipHeader."External Tracking No." <> PackingControl."External Tracking No.") THEN
            PackingControl."External Tracking No." := WHShipHeader."External Tracking No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipping", 'RuppValidateFreight', '', true, true)]
    local procedure RuppValidateFreight(var SalesHeader: Record "Sales Header")
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        RuppFun.ValidateFreightChargesOption(SalesHeader);
        SalesHeader."Free Freight" := FALSE;
        SalesHeader."No Free Freight Lines on Order" := FALSE;
        SalesHeader.MODIFY();
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Shipping", 'RuppUpdateOrderTrack', '', true, true)]
    local procedure RuppUpdateOrderTrack(var Package: Record Package)
    begin
        Package.UpdateOrderTrackingNo(Package);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SE World Ease Print Documents", 'RuppGetWeightLotNo', '', true, true)]
    local Procedure RuppGetWeightLotNo(var ExportLineSource: Record "Export Source Line"; var SeedWeight: Decimal; var LotNo: Code[30])
    begin
        SeedWeight := ExportLineSource."Line Seed Weight in kg";
        LotNo := ExportLineSource."Internal Lot No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SE World Ease Print Documents", 'RuppGetGeneric', '', true, true)]
    local procedure RuppGetGeneric(recItem: Record Item; var GenericCode: Code[20])
    begin
        GenericCode := recItem."Generic Name Code";
    end;

    [EventSubscriber(ObjectType::CodeUnit, Codeunit::"Package Management", 'RuppCheckShipment', '', true, true)]
    local procedure RuppCheckShipment(var Package: Record Package; var PackingControl: Record "Packing Control");
    var
        recWHShipment: Record "Warehouse Shipment Header";
    begin
        //RSI-KS
        Package."Warehouse Shipment No." := PackingControl."Warehouse Shipment No.";
        WITH Package DO BEGIN
            IF "Warehouse Shipment No." > '' THEN
                IF recWHShipment.GET("Warehouse Shipment No.") THEN BEGIN
                    IF (recWHShipment."Shipping Agent Code" > '') AND (recWHShipment."Shipping Agent Code" <> "Shipping Agent Code") THEN
                        "Shipping Agent Code" := recWHShipment."Shipping Agent Code";
                    IF (recWHShipment."E-Ship Agent Service" > '') AND (recWHShipment."E-Ship Agent Service" <> "Shipping Agent Service") THEN
                        "Shipping Agent Service" := recWHShipment."E-Ship Agent Service";
                    IF (recWHShipment."External Tracking No." > '') AND (recWHShipment."External Tracking No." <> "External Tracking No.") THEN
                        "External Tracking No." := recWHShipment."External Tracking No.";
                    Package.Modify();
                END;
        END;
        //RSI-KS        
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Package Management", 'RuppPostWhseShipment', '', true, true)]
    procedure RuppPostWhseShipment(VAR PackingControl: Record "Packing Control"; VAR PackingStation: Record "Packing Station"; VAR SalesHeader: Record "Sales Header"; var ShippingSetup: Record "Shipping Setup")
    begin
        PostWhseShipment_SalesOrder(
           PackingControl."Source Type", SalesHeader."Document Type", SalesHeader."No.",
           PackingStation."Sales Order Close Action" =
           PackingStation."Sales Order Close Action"::"Ship and Invoice", PackingControl."Warehouse Shipment No.",
           PackingStation, ShippingSetup);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Package Management", 'RuppBolPrint', '', true, true)]
    local procedure RuppBolPrint(VAR ShippingAgent: Record "Shipping Agent"; VAR SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        IF ShippingAgent."BOL Required" THEN BEGIN
            SalesShipmentHeader.FINDLAST();
            SalesShipmentHeader.SETRECFILTER();
            REPORT.RUN(Report::"Bill of Lading - Rupp", FALSE, FALSE, SalesShipmentHeader);
        END;
    end;

    [EventSubscriber(ObjectType::CodeUnit, Codeunit::"Package Management", 'RuppPackageFilter', '', true, true)]
    local procedure RuppPackageFilter(VAR PackingLine: Record "Package Line"; "Packing Control": Record "Packing Control")
    begin
        PackingLine.SETRANGE("Warehouse Shipment No.", "Packing Control"."Warehouse Shipment No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Package Management", 'RuppLicenseCheck', '', true, true)]
    local procedure RuppLicenseCheck(VAR SalesLine: Record "Sales Line"; PackingControl: Record "Packing Control")
    begin
        SalesLine.SETRANGE("Missing Reqd License", FALSE);
        SalesLine.SETRANGE("Missing Reqd Liability Waiver", FALSE);
        SalesLine.SETRANGE("Missing Reqd Quality Release", FALSE);
        IF PackingControl."Warehouse Shipment No." <> '' THEN BEGIN
            SalesLine.SETRANGE("Whse Shpt No. Filter", PackingControl."Warehouse Shipment No.");
            SalesLine.SETRANGE("Whse Shpt Line Exists", TRUE);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Package Management", 'RuppCheckOrderForClosing', '', true, true)]
    local procedure RuppCheckOrderForClosing(var PackingControl: Record "Packing Control")
    var
        recPackage: Record Package;
        recPkgLn: Record "Package Line";
        sPrevSrcDoc: Text[50];
    begin
        //SOC-SC 04-26-16 New function
        IF PackingControl."Source Type" = DATABASE::"Sales Header" THEN BEGIN
            recPackage.RESET;
            recPackage.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
            recPackage.SETRANGE("Source Type", PackingControl."Source Type");
            recPackage.SETRANGE("Source Subtype", PackingControl."Source Subtype");
            IF PackingControl."Multi Document Package" THEN
                recPackage.SETFILTER("Source ID", PackingControl."Multi Document No.")
            ELSE
                recPackage.SETRANGE("Source ID", PackingControl."Source ID");
            IF recPackage.FINDSET() THEN BEGIN
                REPEAT
                    IF FORMAT(recPackage."Source Type") + FORMAT(recPackage."Source Subtype") + recPackage."Source ID" <> sPrevSrcDoc THEN BEGIN
                        recPkgLn.SETRANGE("Package No.", recPackage."No.");
                        sPrevSrcDoc := FORMAT(recPackage."Source Type") + FORMAT(recPackage."Source Subtype") + recPackage."Source ID";
                    END;
                UNTIL recPackage.NEXT = 0;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Exp. Pre-Mapping Det EFT US", 'RuppPrepareEFTDetail', '', true, true)]
    local procedure RuppPrepareEFTDetail(DataExchangeEntryNo: Integer; BankAccountFromExport: Code[20]; DataExchLineDefCode: Code[20]; PaymentAmount: Decimal)
    var
        BankAccount: Record "Bank Account";
        ACHUSDetail: Record "ACH US Detail";
    begin
        BankAccount.GET(BankAccountFromExport);

        WITH ACHUSDetail DO BEGIN
            INIT;
            "Data Exch. Entry No." := DataExchangeEntryNo;
            "Payee Bank Account Number" := BankAccount."Bank Account No.";
            "Data Exch. Line Def Code" := DataExchLineDefCode;
            "Total Debits" := PaymentAmount;

            INSERT(TRUE);
            COMMIT;
        END;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'RuppCheckLicense', '', true, true)]
    local procedure RuppCheckLicense(SalesLine: Record "Sales Line"; var bMissingLicense: Boolean)
    begin
        IF SalesLine."Missing Reqd License" OR
          SalesLine."Missing Reqd Liability Waiver" OR
          SalesLine."Missing Reqd Quality Release" THEN
            bMissingLicense := true
        else
            bMissingLicense := false;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', true, true)]
    local procedure OnAfterCreateShptHeader(VAR WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then
            Clear(SalesHeader);
        WarehouseShipmentHeader."Shipment Method Code" := SalesHeader."Shipment Method Code";
        WarehouseShipmentHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
        WarehouseShipmentHeader."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        WarehouseShipmentHeader."E-Ship Agent Service" := SalesHeader."E-Ship Agent Service";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivLineInsert', '', true, true)]
    local procedure OnBeforeWhseActivLineInsert(VAR WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header")
    begin
        WarehouseActivityLine."Created By" := USERID;
        WarehouseActivityLine."Created Date Time" := CURRENTDATETIME;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterWhseActivLineInsert', '', true, true)]
    local procedure OnAfterWhseActivLineInsert(VAR WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        RupFun: Codeunit "Rupp Functions";
    begin
        RupFun.UpdateHdrShpgStatusFromPickLn(WarehouseActivityLine, FALSE);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Whse.-Shipment - Create Pick", 'OnAfterCalculateQuantityToPick', '', true, true)]
    local procedure OnAfterCalculateQuantityToPick(VAR WarehouseShipmentLine: Record "Warehouse Shipment Line"; VAR QtyToPick: Decimal; VAR QtyToPickBase: Decimal)
    var
        recWarehouseHeader: Record "Warehouse Shipment Header";
    begin
        if not recWarehouseHeader.Get(WarehouseShipmentLine."No.") then
            clear(recWarehouseHeader);
        with recWarehouseHeader do begin
            IF "Create Pick for Qty. to Pick" THEN BEGIN
                IF WarehouseShipmentLine."Qty. to Pick" > 0 THEN BEGIN
                    IF WarehouseShipmentLine."Qty. to Pick" <= QtyToPick THEN BEGIN
                        QtyToPick := WarehouseShipmentLine."Qty. to Pick";
                        QtyToPickBase := QtyToPick * WarehouseShipmentLine."Qty. per Unit of Measure";
                    END;
                    WarehouseShipmentLine."Qty. to Pick" := 0;
                    WarehouseShipmentLine.Modify();
                END ELSE BEGIN
                    QtyToPick := 0;
                    QtyToPickBase := 0;
                END;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Post Code", 'OnBeforeCheckClearPostCodeCityCounty', '', true, true)]
    local procedure OnBeforeCheckClearPostCodeCityCounty(VAR CityTxt: Text; VAR PostCode: Code[20]; VAR CountyTxt: Text; VAR CountryCode: Code[10]; xCountryCode: Code[10]; VAR IsHandled: Boolean)
    begin
        // Prevent address lines from clearing
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(VAR SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."Sell-to Phone No. -CL-" := SellToCustomer."Phone No.";
        SalesHeader.Validate("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure OnAfterCopyShipToCustomerAddressFieldsFromCustomer(VAR SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        SalesHeader."Ship-to Phone No. -CL-" := SellToCustomer."Phone No.";
        SalesHeader.Validate("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr', '', true, true)]
    local procedure OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(VAR SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address")
    begin
        SalesHeader."Ship-to Phone No. -CL-" := ShipToAddress."Phone No.";
        SalesHeader.Validate("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', true, true)]
    local procedure OnAfterSetFieldsBilltoCustomer(VAR SalesHeader: Record "Sales Header"; Customer: Record Customer)
    begin
        SalesHeader."Bill-to Phone No. -CL-" := Customer."Phone No.";
        SalesHeader.Validate("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::CodeUnit, codeunit::"Whse. Validate Source Line", 'RuppGetWONumber', '', true, true)]
    local procedure RuppGetWONumber(recAssemblyLine: Record "Assembly Line"; VAR WONumber: Code[20])
    begin
        WONumber := recAssemblyLine."Work Order No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCheckWhseRcptLine', '', true, true)]
    local procedure OnAfterCheckWhseRcptLine(VAR WarehouseReceiptLine: Record "Warehouse Receipt Line");
    var
        recItem: Record Item;
        recItemTracking: Record "Item Tracking Code";
        recRE: Record "Reservation Entry";
    begin
        with WarehouseReceiptLine do Begin
            recItem.GET("Item No.");
            IF recItem."Item Tracking Code" <> '' THEN BEGIN
                recItemTracking.GET(recItem."Item Tracking Code");
                IF recItemTracking."Lot Sales Outbound Tracking" THEN BEGIN
                    recRE.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line",
                                "Reservation Status", "Shipment Date", "Expected Receipt Date");
                    recRE.SETRANGE(Positive, TRUE);
                    recRE.SETRANGE("Item No.", "Item No.");
                    recRE.SETRANGE("Reservation Status", recRE."Reservation Status"::Surplus);
                    recRE.SETRANGE("Source Type", WarehouseReceiptLine."Source Type");
                    recRE.SETRANGE("Source Subtype", WarehouseReceiptLine."Source Subtype");
                    recRE.SETRANGE("Source ID", WarehouseReceiptLine."Source No.");
                    recRE.SETRANGE("Source Ref. No.", WarehouseReceiptLine."Source Line No.");
                    IF recRE.FINDSET() THEN BEGIN
                        recRE.CALCSUMS(Quantity);
                        IF recRE.Quantity < "Qty. to Receive" THEN BEGIN
                            ERROR('Please enter Lot No. for Item %1 on Order No. %2 and Line No. %3 for Quantity %4', "Item No.", "Source No.", "Source Line No.", "Qty. to Receive");
                        END;
                    END ELSE BEGIN
                        ERROR('Lot Numbers are required for Item %1 on Order No. %2 and Line No. %3', "Item No.", "Source No.", "Source Line No.");
                    END;
                END;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", 'OnAfterCode', '', true, true)]
    Local procedure OnAfterCode(VAR WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        recSH: Record "Sales Header";
    begin
        with WarehouseActivityLine do Begin
            IF ("Activity Type" = "Activity Type"::Pick) AND ("Source Document" = "Source Document"::"Sales Order") THEN
                IF recSH.GET("Source Subtype", "Source No.") THEN BEGIN
                    recSH."Shipping Status" := recSH."Shipping Status"::Picked;
                    recSH.MODIFY();
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Custom Fields", 'GenJnlLineTOCustLedgEntry', '', true, true)]
    local procedure GenJnlLineTOCustLedgEntry(VAR GenJnlLine: Record "Gen. Journal Line"; VAR CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry."Requested Fall Amount" := GenJnlLine."Fall Amount";
        CustLedgEntry."Requested Spring Amount" := GenJnlLine."Spring Amount";
        CustLedgEntry."Requested Seasonal Discount" := GenJnlLine."Seasonal Discount";
        CustLedgEntry."Season Code" := GenJnlLine."Seasonal Cash Disc Code";
        // >> EDI
        CustLedgEntry."EDI Payment" := GenJnlLine."EDI Payment";
        CustLedgEntry."EDI Internal Doc. No." := GenJnlLine."EDI Internal Doc. No.";
        // << EDI
        if CustLedgEntry.Modify() then;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Custom Fields", 'GenJnlLineTOVendLedgEntry', '', true, true)]
    local procedure GenJnlLineTOVendLedgEntry(VAR GenJnlLine: Record "Gen. Journal Line"; VAR VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry."Check-off" := GenJnlLine."Check-off";
        VendLedgEntry."Check-off Payment No." := GenJnlLine."Check-off Payment No.";
        // >> EDI
        VendLedgEntry."EDI Payment" := GenJnlLine."EDI Payment";
        VendLedgEntry."EDI Internal Doc. No." := GenJnlLine."EDI Internal Doc. No.";
        // << EDI
        if VendLedgEntry.Modify() then;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Custom Fields", 'ItemJnlLineTOItemLedgEntry', '', true, true)]
    local procedure ItemJnlLineTOItemLedgEntry(VAR ItemJnlLine: Record "Item Journal Line"; VAR ItemLedgEntry: Record "Item Ledger Entry")
    var
        recItem: Record Item;
        RuppFun: Codeunit "Rupp Functions";
        recPostedAssemblyHeader: Record "Posted Assembly Header";
        dQtyperLOUM: Decimal;
    begin
        //RSPM
        IF ItemJnlLine."Item No." <> '' THEN BEGIN
            IF recItem.GET(ItemJnlLine."Item No.") THEN BEGIN
                IF recItem."Product Code" <> '' THEN BEGIN
                    ItemLedgEntry."Product Code" := recItem."Product Code";
                    RuppFun.GetQtyLUOMandQtyCUOM(ItemJnlLine."Item No.", ItemJnlLine."Unit of Measure Code", ItemLedgEntry.Quantity,
                                                ItemLedgEntry."Qty. in Lowest UOM", ItemLedgEntry."Qty. in Common UOM", dQtyperLOUM);
                END;
            END;
        END;
        //RSPM

        IF ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Posted Assembly" THEN
            IF recPostedAssemblyHeader.GET(ItemLedgEntry."Document No.") THEN
                ItemLedgEntry."Work Order No." := recPostedAssemblyHeader."Work Order No.";
        if ItemLedgEntry.Modify() then;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    var
        recItem: Record Item;
        RuppFun: Codeunit "Rupp Functions";
        recPostedAssemblyHeader: Record "Posted Assembly Header";
        dQtyperLOUM: Decimal;
    begin
        IF ItemJournalLine."Item No." <> '' THEN BEGIN
            IF recItem.GET(ItemJournalLine."Item No.") THEN BEGIN
                IF recItem."Product Code" <> '' THEN BEGIN
                    NewItemLedgEntry."Product Code" := recItem."Product Code";
                    RuppFun.GetQtyLUOMandQtyCUOM(ItemJournalLine."Item No.", ItemJournalLine."Unit of Measure Code", NewItemLedgEntry.Quantity,
                                                NewItemLedgEntry."Qty. in Lowest UOM", NewItemLedgEntry."Qty. in Common UOM", dQtyperLOUM);
                END;
            END;
        END;

        IF NewItemLedgEntry."Document Type" = NewItemLedgEntry."Document Type"::"Posted Assembly" THEN
            IF recPostedAssemblyHeader.GET(NewItemLedgEntry."Document No.") THEN
                NewItemLedgEntry."Work Order No." := recPostedAssemblyHeader."Work Order No.";

        if NewItemLedgEntry.Modify() then;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Sales Price on Wksh.", 'OnBeforeModifyOrInsertSalesPriceWksh', '', true, true)]
    local Procedure OnBeforeModifyOrInsertSalesPriceWksh(VAR SalesPriceWorksheet: Record "Sales Price Worksheet"; VAR SalesPrice: Record "Sales Price")
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::Shipping, 'RuppAddFreightLine', '', true, true)]
    local procedure RuppAddFreightLine(Var SalesHeader: Record "Sales Header"; RateShopLine: Record "Rate Shop Line"; Currency: Record Currency)
    var
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        ShippingAgent: Record "Shipping Agent";
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingSetup: Record "Shipping Setup";
        Text023: Label ' (Quoted)';
    begin
        IF NOT (SalesHeader."Free Freight") AND NOT (SalesHeader."No Free Freight Lines on Order") THEN BEGIN //SOC-SC 08-09-15
            GetShippingSetup(ShippingSetup, SalesSetup);
            GetShippingAgent(RateShopLine."Shipping Agent Code", ShippingAgent, ShippingSetup, SalesSetup);
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            IF SalesLine.FIND('+') THEN
                LineNo := SalesLine."Line No." + 10000
            ELSE
                LineNo := 10000;
            SalesLine.INIT;
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := LineNo;
            ShippingAgent.TESTFIELD("Prepaid Freight Type");
            SalesLine.Type := ShippingAgent."Prepaid Freight Type";
            ShippingAgent.TESTFIELD("Prepaid Freight Code");
            SalesLine."Shipping Charge" := TRUE;
            SalesLine.VALIDATE("No.", ShippingAgent."Prepaid Freight Code");
            SalesLine.Description := COPYSTR(SalesLine.Description + Text023, 1, 30);
            SalesLine.VALIDATE(Quantity, 1);
            IF ShippingSetup."No Discounts on Ship. Charge" THEN
                SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
            SalesLine.VALIDATE("Unit Cost (LCY)", RateShopLine."Shipping Cost");
            SalesLine.VALIDATE(
            "Unit Price",
            ROUND(
                SalesHeader."Currency Factor" * RateShopLine."Shipping Charge",
                Currency."Unit-Amount Rounding Precision"));
            SalesLine."Shipping Charge" := TRUE;
            SalesLine."Rate Quoted" := TRUE;
            SalesLine.INSERT(TRUE);

            IF SalesHeader."Free Freight" THEN BEGIN
                SalesLine.INIT;
                SalesLine."Line No." := SalesLine."Line No." + 10000;
                ShippingAgent.TESTFIELD("Free Freight Type");
                SalesLine.Type := ShippingAgent."Free Freight Type";
                ShippingAgent.TESTFIELD("Free Freight Code");
                SalesLine."Shipping Charge" := TRUE;
                SalesLine.VALIDATE("No.", ShippingAgent."Free Freight Code");
                SalesLine.Description := COPYSTR(SalesLine.Description + Text023, 1, 30);

                SalesLine.VALIDATE(Quantity, 1);
                IF ShippingSetup."No Discounts on Ship. Charge" THEN
                    SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
                SalesLine.VALIDATE("Unit Cost (LCY)", 0);
                SalesLine.VALIDATE(
                    "Unit Price",
                    -ROUND(
                    SalesHeader."Currency Factor" * RateShopLine."Shipping Charge",
                    Currency."Unit-Amount Rounding Precision"));
                SalesLine."Shipping Charge" := TRUE;
                SalesLine."Rate Quoted" := TRUE;
                SalesLine.INSERT(TRUE);
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'RuppOnAfterDelete', '', true, true)]
    local procedure RuppOnAfterDelete(WhseActivityLine: Record "Warehouse Activity Line")
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        RuppFun.UpdateHdrShpgStatusFromPickLn(WhseActivityLine, TRUE);
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnBeforeDisplayErrorIfItemIsBlocked', '', true, true)]
    local procedure OnBeforeDisplayErrorIfItemIsBlocked(VAR Item: Record Item; VAR ItemJournalLine: Record "Item Journal Line"; VAR IsHandled: Boolean)
    begin
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Sale then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'RuppGroupDiscount', '', true, true)]
    local procedure RuppGroupDiscount(VAR TempSalesPrice: Record "Sales Price"; VAR SalesHeader: Record "Sales Header"; VAR SalesLine: Record "Sales Line"; VAR UnitPrice: Decimal)
    var
        recCustPriceGroup: Record "Customer Price Group";
    begin
        IF TempSalesPrice."Allow Group Discount" THEN BEGIN
            IF SalesHeader."Customer Price Group" <> '' THEN BEGIN
                IF recCustPriceGroup.GET(SalesHeader."Customer Price Group") THEN BEGIN
                    IF recCustPriceGroup."Additional Cust. Discount" <> 0 THEN BEGIN
                        IF (UnitPrice - recCustPriceGroup."Additional Cust. Discount") > 0 THEN
                            UnitPrice := UnitPrice - recCustPriceGroup."Additional Cust. Discount";
                    END;
                END;
            END;
        END;
        SalesLine."Unit Price per CUOM" := TempSalesPrice."Unit Price per Common UOM";
        SalesLine."Unit Discount" := TempSalesPrice."Unit Price" - UnitPrice;
        if SalesLine.Modify() then;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'RuppBestSalesPrice', '', true, true)]
    local procedure RuppBestSalesPrice(VAR BestSalesPrice: Record "Sales Price"; VAR CustomerPriceGrp: Code[30]);
    var
        recCustPriceGroup: Record "Customer Price Group";
    begin
        IF BestSalesPrice."Allow Group Discount" THEN BEGIN
            IF CustomerPriceGrp <> '' THEN BEGIN
                IF recCustPriceGroup.GET(CustomerPriceGrp) THEN BEGIN
                    IF recCustPriceGroup."Additional Cust. Discount" <> 0 THEN BEGIN
                        IF (BestSalesPrice."Unit Price" - recCustPriceGroup."Additional Cust. Discount") > 0 THEN
                            BestSalesPrice."Unit Price" := BestSalesPrice."Unit Price" - recCustPriceGroup."Additional Cust. Discount";
                    END;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'RuppGetRegion', '', true, true)]
    local procedure RuppGetRegion(Var SalesHeader: Record "Sales Header"; var RegionCode: Text[30])
    begin
        RegionCode := SalesHeader."Region Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'RuppSetRegion', '', true, true)]
    local procedure RuppSetRegion(Var FromSalesPrice: Record "Sales Price"; gsRegionCode: Code[30])
    begin
        with FromSalesPrice do begin
            SETRANGE("Region Code", gsRegionCode);
            IF NOT FINDSET() THEN
                SETRANGE("Region Code", '');
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure OnAfterAssignItemValues(var PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchLine."Product Code" := Item."Product Code";
        if PurchLine.Modify() then;
    end;

    [EventSubscriber(ObjectType::Report, report::"SE World Ease Commercial Inv.", 'RuppGetValues', '', true, true)]
    local procedure RuppGetValues(VAR ConsolShipment: Record "SE World Ease Consol. Shipment"; VAR dUnitSeedWgt: Decimal; VAR dLineSeedWgt: Decimal; VAR cInternalLot: Code[40]; VAR cCountryofOrgin: Code[10]; VAR sGenericCode: Code[20])
    var
        recItem: Record Item;
    begin
        dUnitSeedWgt := ConsolShipment."Unit Seed Weight in g";
        dLineSeedWgt := ConsolShipment."Line Seed Weight in g";
        cInternalLot := ConsolShipment."Internal Lot No.";
        cCountryofOrgin := ConsolShipment."Country of Origin Code";
        if recItem.get(ConsolShipment."No.") then
            sGenericCode := recItem."Generic Name Code"
        else
            Clear(sGenericCode);
    end;

    local procedure GetShippingSetup(var ShippingSetup: Record "Shipping Setup"; var SalesSetup: Record "Sales & Receivables Setup")
    begin
        ShippingSetup.GET;
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Enable Shipping");
    END;

    local procedure GetShippingAgent(ShippingAgentCode: Code[10]; var ShippingAgent: Record "Shipping Agent"; ShippingSetup: Record "Shipping Setup"; SalesSetup: Record "Sales & Receivables Setup")
    begin
        IF (ShippingAgent.Code <> ShippingAgentCode) OR (ShippingAgentCode = '') THEN BEGIN
            GetShippingSetup(ShippingSetup, SalesSetup);
            IF (ShippingAgentCode <> '') OR ShippingSetup."Shipping Agent Required" THEN
                ShippingAgent.GET(ShippingAgentCode)
            ELSE
                CLEAR(ShippingAgent);
        END;
    end;

    procedure PostWhseShipment_SalesOrder(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; Invoice: Boolean; WhseShptNo: Code[20]; PackingStation: Record "Packing Station"; ShippingSetup: Record "Shipping Setup")
    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        Package: Record Package;
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        PackageMgt: Codeunit "Package Management";
        Text044: Label 'No Warehouse ship lines found for %1 %2.';
        Text045: Label 'Packages not posted';

    Begin
        WhseShipmentLine.RESET;
        WhseShipmentLine.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        CASE SourceType OF
            DATABASE::"Sales Header":
                BEGIN
                    WhseShipmentLine.SETRANGE("Source Type", DATABASE::"Sales Line");
                    WhseShipmentLine.SETRANGE("Source Document", WhseShipmentLine."Source Document"::"Sales Order")
                END;
            DATABASE::"Purchase Header":
                BEGIN
                    WhseShipmentLine.SETRANGE("Source Type", DATABASE::"Purchase Line");
                    WhseShipmentLine.SETRANGE(
                        "Source Document", WhseShipmentLine."Source Document"::"Purchase Return Order");
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    WhseShipmentLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
                    WhseShipmentLine.SETRANGE(
                        "Source Document", WhseShipmentLine."Source Document"::"Outbound Transfer");
                END;
        END;
        WhseShipmentLine.SETRANGE("Source Subtype", SourceSubtype);
        WhseShipmentLine.SETRANGE("Source No.", SourceID);
        IF ShippingSetup."Location Packing" THEN
            WhseShipmentLine.SETRANGE("Location Code", PackingStation."Location Code");
        IF WhseShipmentLine.FIND('-') THEN BEGIN
            WhseShipmentLine.SETFILTER("No.", '<>%1', WhseShipmentLine."No.");
        END;

        RuppRegisterPickForWhseShpt(SourceType, SourceSubtype, SourceID, WhseShptNo, PackingStation, ShippingSetup);
        WhseShipmentLine.SETRANGE("No.", WhseShptNo);  //SOC-SC 04-26-16 new code
        IF NOT WhseShipmentLine.FIND('-') THEN
            ERROR(Text044, SourceSubtype, SourceID);

        WhsePostShipment.SetPostingSettings(Invoice);
        WhsePostShipment.RUN(WhseShipmentLine);

        Package.RESET;
        Package.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        Package.SETRANGE("Source Type", SourceType);
        Package.SETRANGE("Source Subtype", SourceSubtype);
        Package.SETRANGE("Source ID", SourceID);
        Package.SETRANGE("Warehouse Shipment No.", WhseShptNo); //SOC-SC 04-26-16
        IF ShippingSetup."Location Packing" THEN
            Package.SETRANGE("Location Code", PackingStation."Location Code");
        IF Package.FIND('-') THEN
            ERROR(Text045);
    End;

    procedure RuppRegisterPickForWhseShpt(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; WhseShptNo: Code[20]; PackingStation: Record "Packing Station"; ShippingSetup: Record "Shipping Setup")
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        WhseActivityLine2: Record "Warehouse Activity Line";
        LastPickNo: Code[20];
        WhsePostPick: Codeunit "Whse.-Activity-Register";
        Text121: Label 'Warehouse Activity %1 cannot be registered.';
        Text043: Label '%1 %2 has not been posted.';
    begin
        WhseActivityLine.RESET;
        WhseActivityLine.SETCURRENTKEY(
        "Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.");
        WhseActivityLine.SETRANGE("Activity Type", WhseActivityLine."Activity Type"::Pick);
        CASE SourceType OF
            DATABASE::"Sales Header":
                WhseActivityLine.SETRANGE("Source Type", DATABASE::"Sales Line");
            DATABASE::"Purchase Header":
                WhseActivityLine.SETRANGE("Source Type", DATABASE::"Purchase Line");
            DATABASE::"Transfer Header":
                WhseActivityLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
        END;
        WhseActivityLine.SETRANGE("Source Subtype", SourceSubtype);
        WhseActivityLine.SETRANGE("Source No.", SourceID);
        IF ShippingSetup."Location Packing" THEN
            WhseActivityLine.SETRANGE("Location Code", PackingStation."Location Code");
        WhseActivityLine.SETRANGE("Whse. Document No.", WhseShptNo); //SOC-SC 04-26-16
        IF WhseActivityLine.FIND('-') THEN
            IF PackingStation."Auto Post Pick" THEN BEGIN
                LastPickNo := WhseActivityLine."No.";
                REPEAT
                    IF PackingStation."Auto Fill Qty. to Handle" THEN BEGIN
                        WhseActivityLine2.COPY(WhseActivityLine);
                        WhseActivityLine2.AutofillQtyToHandle(WhseActivityLine2);
                    END;

                    WhseActivityLine.SETFILTER("Breakbulk No.", '<>0');
                    // Very far from optimal key, but posting will only go through in line no.
                    // order. Another key should be added containing the source reference
                    IF WhseActivityLine.FIND('-') THEN
                        WhseActivityLine.SETCURRENTKEY("Activity Type", "No.", "Line No.");
                    WhseActivityLine.SETRANGE("Breakbulk No.");

                    WhsePostPick.RUN(WhseActivityLine);
                UNTIL NOT WhseActivityLine.FIND('-') OR (WhseActivityLine."No." = LastPickNo);

                IF WhseActivityLine.FIND('-') THEN
                    ERROR(Text121, WhseActivityLine."No.");
            END ELSE
                ERROR(
                Text043,
                WhseActivityLine."Activity Type", WhseActivityLine."No.");
    End;
}
