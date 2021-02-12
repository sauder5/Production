codeunit 50001 "Rupp Functions"
{
    // //SOC-SC 08-09-15
    //   Added func ValidateFreightChargesOption(); When user clicks the button to add Shipping & Handling, check for "Freight Charges Option"
    // 
    // //RSI-KS 12-17-15
    //   Check PO Quantities if checked on Inventory Status
    // 
    // //RSI-KS 04-13-16
    //   Add Product Level availability checks
    // 
    // //SOC-SC 08-01-16
    //   Added function CheckAllowedPostingDate()
    // 
    // //RSI-KS 11-13-19
    //   Change static shipping and handling to pull the price from the resource


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure UpdateHdrShpgStatusFromSalesLn(var SalesLine: Record "Sales Line"; bDeletingSL: Boolean)
    var
        recSL: Record "Sales Line";
        recSH: Record "Sales Header";
        opShpgStatus: Option " ",Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
        dOutstandingQty: Decimal;
    begin
        //Called from Sales Line, Quantity OnValidate(); Ondelete();
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
            Clear(opShpgStatus);
            recSH.Get(SalesLine."Document Type", SalesLine."Document No.");
            if not bDeletingSL then begin
                dOutstandingQty := SalesLine."Outstanding Quantity";
            end;

            recSL.Reset();
            recSL.SetRange("Document Type", SalesLine."Document Type");
            recSL.SetRange("Document No.", SalesLine."Document No.");
            recSL.SetFilter("Line No.", '<>%1', SalesLine."Line No.");
            if recSL.FindSet() then begin
                repeat
                    dOutstandingQty += recSL."Outstanding Quantity";
                until recSL.Next = 0;
            end;

            if dOutstandingQty = 0 then begin
                recSL.SetFilter("Quantity Shipped", '>%1', 0);
                if recSL.FindFirst() then begin
                    opShpgStatus := opShpgStatus::"Completely Shipped";
                end else begin
                    opShpgStatus := opShpgStatus::" ";
                end;
            end else begin
                if CheckSHPicking(recSH) then begin
                    if CheckSHPacking(recSH) then begin
                        opShpgStatus := opShpgStatus::Packing;
                    end else begin
                        opShpgStatus := opShpgStatus::Picking;
                    end;
                end else begin
                    if CheckSHPicked(recSH) then begin
                        opShpgStatus := opShpgStatus::Picked;
                    end else begin
                        if CheckSHPartiallyShipped(recSH) then begin
                            opShpgStatus := opShpgStatus::"Partially Shipped";
                        end;
                    end;
                end;
            end;
        end;
        if recSH."Shipping Status" <> opShpgStatus then begin
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateHdrShpgStatusFromPickLn(var WhseActLn: Record "Warehouse Activity Line"; bDeletingPL: Boolean)
    var
        recSL: Record "Sales Line";
        recSH: Record "Sales Header";
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
        dOutstandingQty: Decimal;
    begin
        //Called from warehouse activity line Ondelete();
        if WhseActLn."Source Document" = WhseActLn."Source Document"::"Sales Order" then begin
            Clear(opShpgStatus);
            recSH.Get(WhseActLn."Source Subtype", WhseActLn."Source No.");

            recSL.Reset();
            recSL.SetRange("Document Type", recSH."Document Type");
            recSL.SetRange("Document No.", recSH."No.");
            recSL.SetFilter("Outstanding Quantity", '>%1', 0);
            if not recSL.FindFirst() then begin
                opShpgStatus := opShpgStatus::"Completely Shipped";
            end else begin
                if IsPickingStatus(recSH, bDeletingPL, WhseActLn."Line No.") then begin
                    if CheckSHPacking(recSH) then begin
                        opShpgStatus := opShpgStatus::Packing;
                    end else begin
                        opShpgStatus := opShpgStatus::Picking;
                    end;
                end else begin
                    if CheckSHPicked(recSH) then begin
                        opShpgStatus := opShpgStatus::Picked;
                    end else begin
                        if CheckSHPartiallyShipped(recSH) then begin
                            opShpgStatus := opShpgStatus::"Partially Shipped";
                        end;
                    end;
                end;
            end;
        end;
        if recSH."Shipping Status" <> opShpgStatus then begin
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateHdrShpgStatusFromPackLn(var PkgLn: Record "Package Line"; bDeletingPL: Boolean)
    var
        recSL: Record "Sales Line";
        recSH: Record "Sales Header";
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
        dOutstandingQty: Decimal;
        recPkgLn: Record "Package Line";
    begin
        //Called from package line Ondelete();
        if PkgLn."Source Type" = 36 then begin
            Clear(opShpgStatus);
            recSH.Get(PkgLn."Source Subtype", PkgLn."Source ID");

            recSL.Reset();
            recSL.SetRange("Document Type", recSH."Document Type");
            recSL.SetRange("Document No.", recSH."No.");
            recSL.SetFilter("Outstanding Quantity", '>%1', 0);
            if not recSL.FindFirst() then begin
                opShpgStatus := opShpgStatus::"Completely Shipped";
            end else begin
                //IF IsPickingStatus(recSH, bDeletingPL, WhseActLn."Line No.") THEN BEGIN
                if CheckSHPicking(recSH) then begin
                    //IF CheckSHPacking(recSH) THEN BEGIN
                    recPkgLn.Reset();
                    recPkgLn.SetRange("Source Type", 36);
                    recPkgLn.SetRange("Source Subtype", recSH."Document Type");
                    recPkgLn.SetRange("Source ID", recSH."No.");
                    if bDeletingPL then begin
                        recPkgLn.SetRange("Package No.", PkgLn."Package No.");
                        recPkgLn.SetFilter("Line No.", '<>%1', PkgLn."Line No.");
                        if recPkgLn.FindFirst() then begin
                            opShpgStatus := opShpgStatus::Packing;
                        end else begin
                            opShpgStatus := opShpgStatus::Picking;
                        end;
                    end else begin
                        opShpgStatus := opShpgStatus::Packing;
                    end;
                end else begin
                    if CheckSHPicked(recSH) then begin
                        opShpgStatus := opShpgStatus::Picked;
                    end else begin
                        if CheckSHPartiallyShipped(recSH) then begin
                            opShpgStatus := opShpgStatus::"Partially Shipped";
                        end;
                    end;
                end;
            end;
        end;
        if recSH."Shipping Status" <> opShpgStatus then begin
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateHdrShpgStatusFromWhseShptLn(var WhseShptLn: Record "Warehouse Shipment Line"; bDeletingWSL: Boolean)
    var
        recSL: Record "Sales Line";
        recSH: Record "Sales Header";
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
        dOutstandingQty: Decimal;
        recPkgLn: Record "Package Line";
        recWhseShptLn: Record "Warehouse Shipment Line";
    begin
        //Called from warehouse shipment line Ondelete();
        //IF PkgLn."Source Type" = 36 THEN BEGIN
        if WhseShptLn."Source Document" = WhseShptLn."Source Document"::"Sales Order" then begin
            Clear(opShpgStatus);
            recSH.Get(WhseShptLn."Source Subtype", WhseShptLn."Source No.");

            recSL.Reset();
            recSL.SetRange("Document Type", recSH."Document Type");
            recSL.SetRange("Document No.", recSH."No.");
            recSL.SetFilter("Outstanding Quantity", '>%1', 0);
            if not recSL.FindFirst() then begin
                opShpgStatus := opShpgStatus::"Completely Shipped";
            end else begin
                if CheckSHPicking(recSH) then begin
                    if CheckSHPacking(recSH) then begin
                        opShpgStatus := opShpgStatus::Packing;
                    end else begin
                        opShpgStatus := opShpgStatus::Picking;
                    end;
                end else begin
                    //IF CheckSHPicked(recSH) THEN BEGIN
                    recWhseShptLn.Reset();
                    recWhseShptLn.SetRange("Source Type", 37);
                    recWhseShptLn.SetRange("Source Subtype", recSH."Document Type");
                    recWhseShptLn.SetRange("Source No.", recSH."No.");
                    recWhseShptLn.SetFilter("Qty. Picked", '>0');
                    if bDeletingWSL then begin
                        recWhseShptLn.SetRange("No.", WhseShptLn."No.");
                        recWhseShptLn.SetFilter("Line No.", '<>%1', WhseShptLn."Line No.");
                        //recWhseShptLn.SETFILTER("Source Line No.", '<>%1', WhseShptLn."Source Line No.");
                    end;
                    if recWhseShptLn.FindFirst() then begin
                        opShpgStatus := opShpgStatus::Picked;
                    end else begin
                        if CheckSHPartiallyShipped(recSH) then begin
                            opShpgStatus := opShpgStatus::"Partially Shipped";
                        end;
                    end;
                end;
            end;
        end;
        if recSH."Shipping Status" <> opShpgStatus then begin
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure UpdateSHStatusAsPickingOnCreatePick(WhseActLn: Record "Warehouse Activity Line")
    var
        recSH: Record "Sales Header";
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
    begin
        //Called from Warehouse Activity Line
        if WhseActLn."Source Document" = WhseActLn."Source Document"::"Sales Order" then begin
            recSH.Get(WhseActLn."Source Subtype", WhseActLn."Source No.");
            SalesHdrShpgStatus(recSH, false, 0, opShpgStatus);
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure SalesHdrShpgStatus(var SalesHdr: Record "Sales Header"; PickDelete: Boolean; PickLineNo: Integer; var retShpgStatus: Option " ",Picking,Picked,Packing,"Partially Shipped","Completely Shipped")
    var
        recSL: Record "Sales Line";
        recWhseShptLn: Record "Warehouse Shipment Line";
    begin
        Clear(retShpgStatus);
        //SalesHdr.CALCFIELDS("Completely Shipped");
        //IF SalesHdr."Completely Shipped" THEN BEGIN
        recSL.Reset();
        recSL.SetRange("Document Type", SalesHdr."Document Type");
        recSL.SetRange("Document No.", SalesHdr."No.");
        recSL.SetFilter("Outstanding Quantity", '>%1', 0);
        if not recSL.FindFirst() then begin
            retShpgStatus := retShpgStatus::"Completely Shipped";
        end else begin
            if IsPickingStatus(SalesHdr, PickDelete, PickLineNo) then begin
                SalesHdr.CalcFields("Package Exists");
                if SalesHdr."Package Exists" then begin
                    retShpgStatus := retShpgStatus::Packing;
                end else begin
                    retShpgStatus := retShpgStatus::Picking;
                end;
            end else begin
                recWhseShptLn.Reset();
                recWhseShptLn.SetRange("Source Type", 37);
                recWhseShptLn.SetRange("Source Subtype", SalesHdr."Document Type");
                recWhseShptLn.SetRange("Source No.", SalesHdr."No.");
                recWhseShptLn.SetFilter("Qty. to Ship", '>0');
                if recWhseShptLn.FindFirst() then begin
                    retShpgStatus := retShpgStatus::Picked;
                end else begin
                    recSL.SetRange(Type, recSL.Type::Item);
                    recSL.SetFilter("Quantity Shipped", '>0');
                    if recSL.FindFirst then begin
                        retShpgStatus := retShpgStatus::"Partially Shipped";
                    end else begin
                        retShpgStatus := retShpgStatus::" ";
                    end;
                end;
            end;
        end;

        if SalesHdr."Shipping Status" <> retShpgStatus then begin
            SalesHdr."Shipping Status" := retShpgStatus;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateSHStatusOnDeletePick_(WhseActLn: Record "Warehouse Activity Line"; FromHeader: Boolean)
    var
        recSH: Record "Sales Header";
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
    begin
        //Called from Warehouse Activity Line
        if WhseActLn."Source Document" = WhseActLn."Source Document"::"Sales Order" then begin
            recSH.Get(WhseActLn."Source Subtype", WhseActLn."Source No.");
            SalesHdrShpgStatus(recSH, not (FromHeader), WhseActLn."Line No.", opShpgStatus);
            recSH."Shipping Status" := opShpgStatus;
            recSH.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure IsPickingStatus(SalesHdr: Record "Sales Header"; PickDelete: Boolean; PickLineNo: Integer) bPicking: Boolean
    var
        recWhseActLn: Record "Warehouse Activity Line";
    begin
        bPicking := false;
        recWhseActLn.Reset();
        recWhseActLn.SetRange("Source Document", recWhseActLn."Source Document"::"Sales Order");
        recWhseActLn.SetRange("Source Subtype", SalesHdr."Document Type");
        recWhseActLn.SetRange("Source No.", SalesHdr."No.");
        if PickDelete then recWhseActLn.SetFilter("Line No.", '<>%1', PickLineNo);
        bPicking := recWhseActLn.FindFirst();
    end;

    [Scope('Internal')]
    procedure UpdateSHShpgStatusOnPost(var SalesHdr: Record "Sales Header")
    var
        opShpgStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
    begin
        SalesHdrShpgStatus(SalesHdr, false, 0, opShpgStatus);
        SalesHdr."Shipping Status" := opShpgStatus;
    end;

    [Scope('Internal')]
    procedure CheckSHPicking(var SalesHdr: Record "Sales Header") retOK: Boolean
    begin
        retOK := IsPickingStatus(SalesHdr, false, 0);
    end;

    [Scope('Internal')]
    procedure CheckSHPacking(var SalesHdr: Record "Sales Header") retOK: Boolean
    begin
        SalesHdr.CalcFields("Package Exists");
        retOK := SalesHdr."Package Exists";
    end;

    [Scope('Internal')]
    procedure CheckSHPicked(var SalesHdr: Record "Sales Header") retOK: Boolean
    var
        recWhseShptLn: Record "Warehouse Shipment Line";
    begin
        recWhseShptLn.Reset();
        recWhseShptLn.SetRange("Source Type", 37);
        recWhseShptLn.SetRange("Source Subtype", SalesHdr."Document Type");
        recWhseShptLn.SetRange("Source No.", SalesHdr."No.");
        //recWhseShptLn.SETFILTER("Qty. to Ship", '>0');
        recWhseShptLn.SetFilter("Qty. Picked", '>0');
        retOK := recWhseShptLn.FindFirst();
    end;

    [Scope('Internal')]
    procedure CheckSHPartiallyShipped(var SalesHdr: Record "Sales Header") retOK: Boolean
    var
        recSL: Record "Sales Line";
    begin
        recSL.Reset();
        recSL.SetRange("Document Type", SalesHdr."Document Type");
        recSL.SetRange("Document No.", SalesHdr."No.");
        recSL.SetRange(Type, recSL.Type::Item);
        recSL.SetFilter("Quantity Shipped", '>0');
        retOK := recSL.FindFirst;
    end;

    [Scope('Internal')]
    procedure CheckSHCompletelyShipped(var SalesHdr: Record "Sales Header") retOK: Boolean
    begin
        SalesHdr.CalcFields("Completely Shipped");
        retOK := SalesHdr."Completely Shipped";
    end;

    [Scope('Internal')]
    procedure UpdateSLWithQtyRequested(var SalesLn: Record "Sales Line"; xSalesLn: Record "Sales Line")
    var
        dQtyAvail: Decimal;
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        SalesHeader: Record "Sales Header";
        recProduct: Record Product;
        bError: Boolean;
    begin
        //Called from Sales Line table, Qty. Requested Onvalidate()
        with SalesLn do begin
            Clear(recProduct);
            bError := recProduct.Get(SalesLn."Product Code");
            if ("Document Type" = "Document Type"::Order) and (Type = Type::Item) and (("Inventory Status Code" <> '') or
                (recProduct."Inventory Status Code" <> '')) then begin
                dQtyAvail := GetItemQtyAvail("No.", "Location Code", SalesLn, xSalesLn);
                if dQtyAvail < 0 then
                    dQtyAvail := 0;
                if dQtyAvail < "Qty. Requested" then begin
                    Validate("Qty. Cancelled", "Qty. Requested" - dQtyAvail);
                end else begin
                    Validate("Qty. Cancelled", 0);
                end;
            end else begin
                //VALIDATE("Qty. Cancelled", 0);
                Validate(Quantity, "Qty. Requested" - "Qty. Cancelled");
                case Type of
                    Type::Item, Type::Resource:
                        begin
                            SalesHeader.Get(SalesLn."Document Type", SalesLn."Document No.");
                            PriceCalcMgt.FindSalesLineLineDisc(SalesHeader, SalesLn);
                            PriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLn, FieldNo(Quantity));
                        end;
                end;
                Validate("Unit Price");
            end;
        end;
        if SalesLn.Modify() then;
    end;

    [Scope('Internal')]
    procedure GetItemQtyAvail(ItemNo: Code[20]; LocCode: Code[10]; SalesLn: Record "Sales Line"; xSalesLn: Record "Sales Line") retQtyAvail: Decimal
    var
        recItem: Record Item;
        recInvStatus: Record "Rupp Reason Code";
        UsePO: Boolean;
        recProduct: Record Product;
        recItemUofM: Record "Item Unit of Measure";
        Multiplier: Decimal;
    begin
        retQtyAvail := 0;

        recItem.Get(ItemNo);
        recItem.SetRange("Location Filter", LocCode);
        recItem.CalcFields(Inventory, recItem."Qty. on Sales Order", recItem."Qty. on Purch. Order");

        //RSI-KS 04-13-16
        UsePO := false;
        Multiplier := 0;
        if recItem."Product Code" > '' then
            if recProduct.Get(recItem."Product Code") then
                if recProduct."Inventory Status Code" > '' then begin
                    if recItemUofM.Get(ItemNo, recItem."Base Unit of Measure") then
                        Multiplier := recItemUofM."Qty. per Common UOM";
                    if Multiplier <= 0 then
                        Multiplier := 1;

                    recInvStatus.SetFilter(Type, 'Inventory Status');
                    recInvStatus.SetFilter(Code, recProduct."Inventory Status Code");
                    if recInvStatus.FindSet then
                        UsePO := recInvStatus."Inv Status Check POs in a Year";
                    recProduct.CalcFields("Qty. on Hand", "Qty. on Sales Orders", "Qty. on Purchase Orders");
                    recProduct."Qty. on Sales Orders" := recProduct."Qty. on Sales Orders" - (xSalesLn.Quantity * Multiplier);
                    if UsePO then
                        retQtyAvail := ((recProduct."Qty. on Hand" + recProduct."Qty. on Purchase Orders" - recProduct."Qty. on Sales Orders") / Multiplier)
                    else
                        retQtyAvail := ((recProduct."Qty. on Hand" - recProduct."Qty. on Sales Orders") / Multiplier);
                    exit;
                end;
        //RSI-KS 04-13-16

        UsePO := false;
        if recItem."Inventory Status Code" > '' then begin
            recInvStatus.SetFilter(Type, 'Inventory Status');
            recInvStatus.SetFilter(Code, recItem."Inventory Status Code");
            if recInvStatus.FindSet then
                UsePO := recInvStatus."Inv Status Check POs in a Year";
        end;
        if UsePO then
            retQtyAvail := recItem.Inventory + recItem."Qty On PO" - recItem."Qty. on Sales Order"
        else
            retQtyAvail := recItem.Inventory - recItem."Qty. on Sales Order";
    end;

    [Scope('Internal')]
    procedure UpdateSLUnitDiscount(var SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
            if (Quantity = 0) or ((Quantity - "Quantity Invoiced") = 0) then begin
                "Unit Discount" := 0;
            end else begin
                "Unit Discount" := Round("Line Discount Amount" / (Quantity - "Quantity Invoiced"), 0.00001);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetQtyLUOMandQtyCUOM(ItemNo: Code[20]; "UOM Code": Code[20]; Quantity: Decimal; var RetQtyInLUOM: Decimal; var RetQtyInCUOM: Decimal; var RetQtyPerLUOM: Decimal)
    var
        recItemUOM: Record "Item Unit of Measure";
    begin
        //Called from Sales Line, Purchase Line, Item
        RetQtyInLUOM := 0;
        RetQtyInLUOM := 0;
        RetQtyPerLUOM := 0;
        if recItemUOM.Get(ItemNo, "UOM Code") then begin
            RetQtyInLUOM := Quantity * recItemUOM."Qty. per Lowest UOM";
            RetQtyInCUOM := Quantity * recItemUOM."Qty. per Common UOM";
            RetQtyPerLUOM := recItemUOM."Qty. per Lowest UOM";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateForGeographicalRestr(var SalesLine: Record "Sales Line")
    var
        recGeographicalRestr: Record "Geographical Restriction";
        recSH: Record "Sales Header";
        bRestricted: Boolean;
        recRuppSetup: Record "Rupp Setup";
    begin
        //Called from Sales LIne, No. field OnValidate
        bRestricted := false;
        if SalesLine.Type = SalesLine.Type::Item then begin
            recSH.Get(SalesLine."Document Type", SalesLine."Document No.");
            if recSH."Ship-to Country/Region Code" = '' then
                recSH."Ship-to Country/Region Code" := 'US';

            if recGeographicalRestr.Get(SalesLine."No.", recSH."Ship-to Country/Region Code", recSH."Ship-to County", recSH."Ship-to City", recSH."Ship-to Post Code") then begin
                //ERROR('This item is restricted from being shipped to %1, %2, %3, %4', recSH."Ship-to City", recSH."Ship-to County", recSH."Ship-to Post Code", recSH."Ship-to Country/Region Code");
                bRestricted := true;
            end else begin
                if recGeographicalRestr.Get(SalesLine."No.", recSH."Ship-to Country/Region Code", recSH."Ship-to County", recSH."Ship-to City", '') then begin
                    bRestricted := true;
                end else begin
                    if recGeographicalRestr.Get(SalesLine."No.", recSH."Ship-to Country/Region Code", recSH."Ship-to County", '', '') then begin
                        bRestricted := true;
                    end else begin
                        if recGeographicalRestr.Get(SalesLine."No.", recSH."Ship-to Country/Region Code", '', '', '') then begin
                            bRestricted := true;
                        end;
                    end;
                end;
            end;
        end;

        if bRestricted then begin
            recRuppSetup.Get();
            SalesLine.Validate("Qty. Cancelled", SalesLine."Outstanding Quantity");
            SalesLine."Cancelled Reason Code" := recRuppSetup."Geographical Restriction Code";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateShpgStatusSH_(var SalesHdr: Record "Sales Header")
    var
        recSL: Record "Sales Line";
        recWhseShptLn: Record "Warehouse Shipment Line";
    begin
        /*sales Header: field "Shipping Status"::Blank, Picking, Picked, Packing, Partially Shipped, Completely Shipped
        Completeley Shipped: (if sales header's flow-field "Completely shipped" is true)
        Picking: if a pick line exists (warehouse activity line)
        Packing: if a package line exists
        Picked: if qty. to ship on any line is greater than 0
        Partially Shipped: (if sales header's flow-field "Completely shipped" is false; "Ship" is true)
        Blank
        
        triggers:
        create a pick
        delete a pick line
        delete a pick
        register a pick
        create a package
        delete a package
        close order
        delete a warehouse shipment
        delete a warehouse shipment line
        new sales line is added
        sales line quantity is modified
        sales line is deleted
        */

        SalesHdr.CalcFields("Completely Shipped");
        if SalesHdr."Completely Shipped" then begin
            SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::"Completely Shipped";
        end else begin
            recSL.Reset();
            recSL.SetRange("Document Type", SalesHdr."Document Type");
            recSL.SetRange("Document No.", SalesHdr."No.");
            recSL.SetRange(Type, recSL.Type::Item);
            recSL.SetFilter("Pick Qty.", '>0');
            if recSL.FindFirst() then begin
                SalesHdr.CalcFields("Package Exists");
                if SalesHdr."Package Exists" then begin
                    SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::Packing;
                end else begin
                    SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::Picking;
                end;
            end else begin
                recWhseShptLn.Reset();
                recWhseShptLn.SetRange("Source Type", 37);
                recWhseShptLn.SetRange("Source Subtype", SalesHdr."Document Type");
                recWhseShptLn.SetRange("Source No.", SalesHdr."No.");
                recWhseShptLn.SetFilter("Qty. to Ship", '>0');
                if recWhseShptLn.FindFirst() then begin
                    SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::Picked;
                end else begin
                    recSL.SetRange("Pick Qty.");
                    recSL.SetFilter("Quantity Shipped", '>0');
                    if recSL.FindFirst then begin
                        SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::"Partially Shipped";
                    end else begin
                        SalesHdr."Shipping Status" := SalesHdr."Shipping Status"::" ";
                    end;
                end;
            end;
        end;

    end;

    [Scope('Internal')]
    procedure UpdateOrderPkgTrackingNo(Pkg: Record Package)
    var
        recSH: Record "Sales Header";
    begin
        //SOC-SC 09-04-14 Code to update sales order's "Package Tracking No." field; Called from cu 14000787: FedEx Transaction Web Services
        with Pkg do begin
            if "Source Type" = 36 then begin
                recSH.Reset();
                recSH.SetRange("Document Type", "Source Subtype");
                recSH.SetFilter("No.", "Source ID");
                if recSH.FindSet() then begin
                    repeat
                        if recSH."Package Tracking No." <> "External Tracking No." then begin
                            recSH."Package Tracking No." := "External Tracking No.";
                            recSH.Modify();
                        end;
                    until recSH.Next = 0;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure CheckSalesLineDuplicateExists(var SalesLn: Record "Sales Line")
    var
        recSalesLn: Record "Sales Line";
    begin
        //Called from Sales Line table, "No." field OnValidate()
        if (SalesLn."Document Type" in [SalesLn."Document Type"::Order, SalesLn."Document Type"::Quote]) and (SalesLn.Type = SalesLn.Type::Item) then begin
            recSalesLn.Reset();
            recSalesLn.SetRange("Document Type", SalesLn."Document Type");
            recSalesLn.SetRange("Document No.", SalesLn."Document No.");
            recSalesLn.SetRange(Type, SalesLn.Type);
            recSalesLn.SetRange("No.", SalesLn."No.");
            recSalesLn.SetFilter("Line No.", '<>%1', SalesLn."Line No.");
            if recSalesLn.FindFirst() then begin
                if not Confirm('Item %1 has already been entered on this order. Do you want to enter it again?', false, SalesLn."No.") then begin
                    Error('');
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure ValidateSalesLnInventoryStatus(var SalesLn: Record "Sales Line")
    begin
        //Caled from Sales Line table, "Inventory Status Code" OnValidate()
    end;

    [Scope('Internal')]
    procedure GetDefBinCode(LocCode: Code[10]; ItemNo: Code[20]; VariantCode: Code[20]; UOMCode: Code[10]) retDefBinCode: Code[20]
    var
        recBinContent: Record "Bin Content";
    begin
        recBinContent.Reset(); //PK: "Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code"
        recBinContent.SetRange("Location Code", LocCode);
        recBinContent.SetRange("Item No.", ItemNo);
        recBinContent.SetRange("Unit of Measure Code", UOMCode);
        recBinContent.SetRange(Default, true);
        if recBinContent.FindFirst() then begin
            retDefBinCode := recBinContent."Bin Code";
        end;
    end;

    [Scope('Internal')]
    procedure PrintPickTTicketForSO(SalesOrderNo: Code[20])
    var
        recSH: Record "Sales Header";
    begin
        //called from sales order page and page 50071
        recSH.SetRange(recSH."Document Type", recSH."Document Type"::Order);
        recSH.SetRange("No.", SalesOrderNo);
        recSH.FindSet();
        REPORT.RunModal(50018, true, false, recSH); //10153
    end;

    [Scope('Internal')]
    procedure CountWhShipmentOrders(WHShipmentNumber: Text) recCount: Integer
    var
        recWHLine: Record "Warehouse Shipment Line";
        prevOrder: Text[20];
    begin

        recWHLine.SetRange(recWHLine."No.", WHShipmentNumber);
        recCount := recWHLine.Count;
        //prevOrder:='';

        //IF recWHLine.FINDFIRST() THEN BEGIN
        //  prevOrder:=recWHLine."Source No.";
        //  recCount:=1;
        //  REPEAT
        //     IF prevOrder <>  recWHLine."Source No." THEN
        //        recCount := recCount + 1;
        //  UNTIL recWHLine.NEXT = 0;
        //END;
    end;

    [Scope('Internal')]
    procedure AddStaticShpgHandlingToSO(var SalesHdr: Record "Sales Header") retOK: Boolean
    var
        recSL: Record "Sales Line";
        iLineNo: Integer;
        recRuppSetup: Record "Rupp Setup";
        recResource: Record Resource;
    begin
        //Called from Page 42
        retOK := false;

        recRuppSetup.Get();
        recRuppSetup.TestField("Static S/H Charge");
        recRuppSetup.TestField("Static S/H Charge Type");
        recRuppSetup.TestField("Static S/H Charge No.");

        //SOC-SC 08-09-15
        if SalesHdr."Freight Charges Option" = SalesHdr."Freight Charges Option"::"All Actual Charges" then begin
            Error('Cannot add shipping charges as Freight Charges  is %1 in order %2', SalesHdr."Freight Charges Option", SalesHdr."No.");
        end;
        //SOC-SC 08-09-15

        SalesHdr.CalcFields(Amount);
        if SalesHdr.Amount >= recRuppSetup."Min.Order Value for Static S/H" then
            //ERROR('Sales Order''s Amount is more than the Min.Order Value for Static S/H in Rupp Setup');
            if not Confirm('Sales Order''s Amount is more than the Min.Order Value for Static S/H in Rupp Setup. Do you still want to add it?', false) then
                exit;

        recSL.Reset();
        recSL.SetRange("Document Type", SalesHdr."Document Type");
        recSL.SetRange("Document No.", SalesHdr."No.");
        recSL.SetRange("Shipping Charge", true);
        if recSL.FindFirst() then
            Error('Cannot add Static Shipping & Handling as there is a Shipping Charge already in the Sales Order');

        recSL.SetRange("Shipping Charge");
        recSL.SetRange(Type, recRuppSetup."Static S/H Charge Type");
        recSL.SetRange("No.", recRuppSetup."Static S/H Charge No.");
        if recSL.FindFirst() then
            Error('Cannot add Static Shipping & Handling as there it already exists in the Sales Order');

        recSL.SetRange(Type);
        recSL.SetRange("No.");
        recSL.FindLast();
        iLineNo := recSL."Line No.";

        if not recResource.Get(recRuppSetup."Static S/H Charge No.") then
            Clear(recResource);

        recSL.Init();
        recSL.Validate("Document Type", SalesHdr."Document Type");
        recSL.Validate("Document No.", SalesHdr."No.");
        recSL.Validate("Line No.", iLineNo + 10000);
        recSL.Validate("Sell-to Customer No.", SalesHdr."Sell-to Customer No.");
        recSL.Validate(Type, recRuppSetup."Static S/H Charge Type");
        recSL.Validate("No.", recRuppSetup."Static S/H Charge No.");
        if recRuppSetup."Static S/H Charge UOM Code" <> '' then
            recSL.Validate("Unit of Measure Code", recRuppSetup."Static S/H Charge UOM Code");
        recSL.Validate("Qty. Requested", 1);
        //recSL.VALIDATE("Unit Price", recRuppSetup."Static S/H Charge");
        recSL.Validate("Unit Price", recResource."Unit Price");
        recSL.Insert(true);

        SalesHdr."Free Freight" := true;
        SalesHdr."No Free Freight Lines on Order" := true;
        retOK := true;
    end;

    [Scope('Internal')]
    procedure GetDepositAccountName(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]) retAccountName: Text[50]
    var
        recGLAccount: Record "G/L Account";
        recCust: Record Customer;
        recVendor: Record Vendor;
        recBankAcc: Record "Bank Account";
    begin
        //Called from Deposit Subform and Posted Deposit Subform pages
        retAccountName := '';
        case AccountType of
            AccountType::"G/L Account":
                begin
                    if recGLAccount.Get(AccountNo) then begin
                        retAccountName := recGLAccount.Name;
                    end;
                end;
            AccountType::Customer:
                begin
                    if recCust.Get(AccountNo) then begin
                        retAccountName := recCust.Name;
                    end;
                end;
            AccountType::Vendor:
                begin
                    if recVendor.Get(AccountNo) then begin
                        retAccountName := recVendor.Name;
                    end;
                end;
            AccountType::"Bank Account":
                begin
                    if recBankAcc.Get(AccountNo) then begin
                        retAccountName := recBankAcc.Name;
                    end;
                end;
            else
                ;
        end;
    end;

    [Scope('Internal')]
    procedure ValidateFreightChargesOption(var SalesHeader: Record "Sales Header")
    var
        recSL: Record "Sales Line";
    begin
        //Called from Sales Header table, Freight Charges Option field

        case SalesHeader."Freight Charges Option" of
            SalesHeader."Freight Charges Option"::"User Decides":
                begin
                    SalesHeader."Free Freight" := true;
                    SalesHeader."No Free Freight Lines on Order" := true;
                end;
            SalesHeader."Freight Charges Option"::"One Time Charge":
                begin
                    recSL.Reset();
                    recSL.SetRange("Document Type", SalesHeader."Document Type");
                    recSL.SetRange("Document No.", SalesHeader."No.");
                    recSL.SetRange("Shipping Charge", true);
                    if recSL.FindFirst() then begin
                        SalesHeader."Free Freight" := true;
                        SalesHeader."No Free Freight Lines on Order" := true;
                    end else begin
                        SalesHeader."Shipping Payment Type" := SalesHeader."Shipping Payment Type"::Prepaid;
                        SalesHeader."Free Freight" := false;
                        SalesHeader."No Free Freight Lines on Order" := false;
                    end;
                end;
            SalesHeader."Freight Charges Option"::"All Actual Charges":
                begin
                    SalesHeader."Shipping Payment Type" := SalesHeader."Shipping Payment Type"::Prepaid;
                    SalesHeader."Free Freight" := false;
                    SalesHeader."No Free Freight Lines on Order" := false;
                end;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateUnitPricePerCUOM(var SalesLn: Record "Sales Line")
    var
        recBaseItemUOM: Record "Item Unit of Measure";
        recItem: Record Item;
        dQtyPerCUOM: Decimal;
    begin
        //Called by Sales Line table
        if SalesLn.Type = SalesLn.Type::Item then begin
            if recItem.Get(SalesLn."No.") then begin
                if recBaseItemUOM.Get(SalesLn."No.", recItem."Base Unit of Measure") then begin
                    dQtyPerCUOM := recBaseItemUOM."Qty. per Common UOM";
                end;
            end;
        end;
        SalesLn."Common Unit of Measure" := recBaseItemUOM."Common UOM Code";
        if dQtyPerCUOM <> 0 then begin
            SalesLn."Unit Price per CUOM" := Round(SalesLn."Unit Price" / dQtyPerCUOM, 0.01);
        end else begin
            SalesLn."Unit Price per CUOM" := SalesLn."Unit Price";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateUnitPriceFromCUOM(var SalesLn: Record "Sales Line")
    var
        dQtyPerCUOM: Decimal;
        recItem: Record Item;
        recBaseItemUOM: Record "Item Unit of Measure";
    begin
        //Called by Sales Line table
        with SalesLn do begin
            dQtyPerCUOM := 1;
            if SalesLn.Type = SalesLn.Type::Item then begin
                if recItem.Get(SalesLn."No.") then begin
                    if recBaseItemUOM.Get(SalesLn."No.", recItem."Base Unit of Measure") then begin
                        dQtyPerCUOM := recBaseItemUOM."Qty. per Common UOM";
                        SalesLn."Common Unit of Measure" := recBaseItemUOM."Common UOM Code";
                    end;
                end;
            end;

            "Unit Price" := "Unit Price per CUOM" * dQtyPerCUOM;
        end;
    end;

    [Scope('Internal')]
    procedure CheckAllowedPostingDate(PostingDate: Date; CurrUserID: Code[50]) retOK: Boolean
    var
        recGLSetup: Record "General Ledger Setup";
        recUserSetup: Record "User Setup";
    begin
        retOK := false;
        recGLSetup.Get();
        if (PostingDate < recGLSetup."Allow Posting From") or (PostingDate > recGLSetup."Allow Posting To") then begin
            if recUserSetup.Get(CurrUserID) then begin
                if (PostingDate >= recUserSetup."Allow Posting From") and (PostingDate <= recUserSetup."Allow Posting To") then begin
                    retOK := true;
                end;
            end;
        end else begin
            retOK := true;
        end;
    end;
}

