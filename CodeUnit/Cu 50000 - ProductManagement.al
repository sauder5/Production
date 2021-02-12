codeunit 50000 "Product Management"
{
    // //SOC-SC 10-23-14
    //   Added function GetItemQuantityAvailableToSell()
    // 
    // //RSI-KS 09-21-15
    //   Change Item description to be Product Description plus Treatment description
    // 
    // //RSI-KS 10-23-15
    //   Division / Department were not being copied during item creation


    trigger OnRun()
    begin
    end;

    var
        SeedSize: Integer;
        ItemAttr: Record "Product Attribute";
        TreatmentDescription: Text[30];

    [Scope('Internal')]
    procedure GetAvailQty(Item: Record Item; var retQtyAvail: Decimal; var retQtyCanBeProduced: Decimal)
    var
        recItem: Record Item;
    begin

        //SOC-MA
        Message('ToCheck');

        /*
        retQtyAvail := 0;
        retQtyCanBeProduced :=0;
        
        Item.CALCFIELDS("Qty. on Sales Order", "Qty. on Asm. Component", "Trans. Ord. Shipment (Qty.)", Inventory);
        retQtyAvail := Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Asm. Component" - Item."Trans. Ord. Shipment (Qty.)";
        
        recItem.RESET();
        recItem.SETRANGE("Product Code", Item."Product Code");
        IF recItem.FINDSET() THEN BEGIN
          REPEAT
            recItem.CALCFIELDS(Inventory);
            retQtyCanBeProduced += (recItem.Inventory * recItem."LowestUOM Qty. per CommonUOM");
          UNTIL recItem.NEXT = 0;
          retQtyCanBeProduced := ROUND(retQtyCanBeProduced, 1);
        END;
        */

    end;

    [Scope('Internal')]
    procedure GetSLProduceableQty(SalesLine: Record "Sales Line") retCanBeProducedQty: Decimal
    var
        recItem: Record Item;
        dQtyAvail: Decimal;
    begin
        retCanBeProducedQty := 0;

        if SalesLine.Type = SalesLine.Type::Item then begin
            if recItem.Get(SalesLine."No.") then begin
                GetAvailQty(recItem, dQtyAvail, retCanBeProducedQty);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure OpenItemCreationWksh(ProductCode: Code[20])
    var
        recItemCreationPkgSz: Record "Item Creation Pkg Size";
        PgItemCreation: Page "Item Creation Worksheet";
        recProduct: Record Product;
    begin
        recProduct.Get(ProductCode);
        recProduct.TestField("Gen. Prod. Posting Group");
        recProduct.TestField("Inventory Posting Group");
        recProduct.TestField("Item Category Code");
        recProduct.TestField("Rupp Product Group Code");
        recProduct.TestField("Variety Code");
        recProduct.TestField("Generic Name Code");
        recProduct.TestField("Item Group Code");

        recItemCreationPkgSz.Reset();
        recItemCreationPkgSz.SetFilter("Lowest UOM", '<>%1', '');
        recItemCreationPkgSz.SetFilter("Common UOM", '<>%1', '');
        recItemCreationPkgSz.SetFilter("Qty. per LUOM", '>%1', 0);
        recItemCreationPkgSz.SetFilter("Qty. per CUOM", '>%1', 0);
        if recItemCreationPkgSz.Count() > 0 then begin
            recItemCreationPkgSz.FindSet();
            Clear(PgItemCreation);
            PgItemCreation.SetProductCode(ProductCode);
            PgItemCreation.SetTableView(recItemCreationPkgSz);
            PgItemCreation.Run();
            Clear(PgItemCreation);
        end else begin
            Error('Please set up Item Creation Package Sizes and try again');
        end;
    end;

    [Scope('Internal')]
    procedure CheckPkgSize(var ItemCreationPkgSz: Record "Item Creation Pkg Size")
    var
        recProduct: Record Product;
    begin
        ItemCreationPkgSz.SetRange("Create Item", true);
        ItemCreationPkgSz.FindSet();
        repeat
            if ItemCreationPkgSz."Exceeds Item No. length" then
                Error('Package size %1 exceeds Item No. length', ItemCreationPkgSz."Package Size");

            if ItemCreationPkgSz."Item Exists" then
                Error('Item already exists for package size %1', ItemCreationPkgSz."Package Size");

            //IF NOT recProduct.GET(ItemCreationPkgSz."Product Code") THEN
            ItemCreationPkgSz.CalcFields("Product Exists");
            if not ItemCreationPkgSz."Product Exists" then
                Error('Product does not exist for package size %1', ItemCreationPkgSz."Package Size");

            //IF ItemCreationPkgSz."Item Template Code" = '' THEN
            //  ERROR('Product''s Item Template Code cannot be blank');

            ItemCreationPkgSz.TestField("Lowest UOM");
            ItemCreationPkgSz.TestField("Common UOM");
            ItemCreationPkgSz.TestField("Qty. per LUOM");
            ItemCreationPkgSz.TestField("Qty. per CUOM");
        until ItemCreationPkgSz.Next = 0;
    end;

    [Scope('Internal')]
    procedure CreateNewItems(var ItemCreationPkgSz: Record "Item Creation Pkg Size") retCnt: Integer
    var
        recItem: Record Item;
        sItemNo: Code[20];
        recProduct: Record "Product";
        recRuppProduct: Record "Rupp Product Group";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        recConfigTemplateHeader: Record "Config. Template Header";
        sItemDesc: Text[50];
        recItemUOM: Record "Item Unit of Measure";
        recProdAttr: Record "Product Attribute";
        strDesc: Text[30];
    begin
        CheckPkgSize(ItemCreationPkgSz);
        ItemCreationPkgSz.SetRange("Create Item", true);
        retCnt := 0;
        ItemCreationPkgSz.FindSet();
        repeat

            // TAE - Begin Change
            if StrPos(ItemCreationPkgSz."Product Code", 'GC') = 1 then begin

                for SeedSize := 1 to 6 do begin

                    recProduct.Get(ItemCreationPkgSz."Product Code");
                    if ItemAttr.Get(ItemAttr."Attribute Type"::Treatment, recProduct."Treatment Code") then
                        TreatmentDescription := ItemAttr.Description;

                    case SeedSize of
                        1:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'R16' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Round 16' + ', ' + TreatmentDescription;
                            end;
                        2:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'R20' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Round 20' + ', ' + TreatmentDescription;
                            end;
                        3:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'R24' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Round 24' + ', ' + TreatmentDescription;
                            end;
                        4:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'F16' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Flat 16' + ', ' + TreatmentDescription;
                            end;
                        5:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'F20' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Flat 20' + ', ' + TreatmentDescription;
                            end;
                        6:
                            begin
                                ItemCreationPkgSz."New Item No." := recProduct."Variety Code" + '.' + 'F24' + '.' + recProduct."Treatment Code" + '.' + ItemCreationPkgSz."Pkg Size Abbr";
                                ItemCreationPkgSz.Description := recProduct.Description + ', ' + 'Flat 24' + ', ' + TreatmentDescription;
                            end;
                    end;

                    recItem.Init();
                    recItem.Validate("No.", ItemCreationPkgSz."New Item No.");
                    recItem.Validate(Description, ItemCreationPkgSz.Description);
                    recItem.Insert();

                    if recProduct."Item Template Code" <> '' then begin
                        recConfigTemplateHeader.Get(recProduct."Item Template Code");
                        RecRef.GetTable(recItem);
                        ConfigTemplateMgt.UpdateRecord(recConfigTemplateHeader, RecRef);
                    end;

                    recItemUOM.Init();
                    recItemUOM.Validate("Item No.", recItem."No.");
                    recItemUOM.Validate(Code, ItemCreationPkgSz."Package Size");
                    recItemUOM.Validate("Qty. per Unit of Measure", 1);
                    recItemUOM.Validate("Lowest UOM Code", ItemCreationPkgSz."Lowest UOM");
                    recItemUOM.Validate("Common UOM Code", ItemCreationPkgSz."Common UOM");
                    recItemUOM.Insert();

                    recItem.Validate("Product Code", ItemCreationPkgSz."Product Code");
                    recItem.Validate("Treatment Code", recProduct."Treatment Code");
                    recItem."Quality Premium Code" := recProduct."Quality Premium Code";
                    recItem."Checkoff %" := recProduct."Checkoff %";
                    recItem.Validate("Item Category Code", recProduct."Item Category Code");
                    recItem.Validate("Rupp Product Group Code", recProduct."Rupp Product Group Code");
                    recItem.Validate("Inventory Posting Group", recProduct."Inventory Posting Group");
                    recItem.Validate("Gen. Prod. Posting Group", recProduct."Gen. Prod. Posting Group");
                    recItem."Inventory Status Code" := recProduct."Inventory Status Code";
                    recItem.Validate("Global Dimension 1 Code", recProduct."Global Dimension 1 Code");
                    recItem.Validate("Global Dimension 2 Code", recProduct."Global Dimension 2 Code");
                    recItem.Validate("Vendor No.", recProduct."Vendor No.");
                    if recProduct."Sale Item" then
                        recItem.Validate("Sales Blocked", false)
                    else
                        recItem.Validate("Sales Blocked", true);
                    if recProduct."Purchase Item" then
                        recItem.Validate("Purchasing Blocked", false)
                    else
                        recItem.Validate("Purchasing Blocked", true);
                    // TAE 09/2018 - Added "Item Tracking Code"
                    recItem.Validate("Item Tracking Code", recProduct."Item Tracking Code");

                    recItem.Validate("Base Unit of Measure", ItemCreationPkgSz."Package Size");
                    recItem.Validate("Sales Unit of Measure", ItemCreationPkgSz."Package Size");
                    recItem.Modify();

                    retCnt += 1;
                end;
            end else begin
                // TAE - End Change

                recProduct.Get(ItemCreationPkgSz."Product Code");
                //  IF recProdAttr.GET(recProdAttr."Attribute Type"::Treatment, ItemCreationPkgSz."Treatment Code") THEN
                //     strDesc := COPYSTR(ItemCreationPkgSz."Product Description" + ', ' + recProdAttr.Description, 1, 30)
                //  ELSE
                //     strDesc := ItemCreationPkgSz."Product Description";

                recItem.Init();
                recItem.Validate("No.", ItemCreationPkgSz."New Item No."); //sItemNo);
                                                                           //  recItem.VALIDATE(Description, strDesc);
                recItem.Validate(Description, ItemCreationPkgSz.Description); //sItemDesc);
                                                                              //recItem.VALIDATE("Base Unit of Measure", ItemCreationPkgSz."Package Size");
                recItem.Insert();

                if recProduct."Item Template Code" <> '' then begin
                    recConfigTemplateHeader.Get(recProduct."Item Template Code");
                    RecRef.GetTable(recItem);
                    ConfigTemplateMgt.UpdateRecord(recConfigTemplateHeader, RecRef);
                end;

                recItemUOM.Init();
                recItemUOM.Validate("Item No.", recItem."No.");
                recItemUOM.Validate(Code, ItemCreationPkgSz."Package Size");
                recItemUOM.Validate("Qty. per Unit of Measure", 1);
                recItemUOM.Validate("Lowest UOM Code", ItemCreationPkgSz."Lowest UOM");
                recItemUOM.Validate("Common UOM Code", ItemCreationPkgSz."Common UOM");
                recItemUOM.Insert();

                recItem.Validate("Product Code", ItemCreationPkgSz."Product Code");
                recItem.Validate("Treatment Code", recProduct."Treatment Code");
                recItem."Quality Premium Code" := recProduct."Quality Premium Code";
                recItem."Checkoff %" := recProduct."Checkoff %";
                recItem.Validate("Item Category Code", recProduct."Item Category Code");
                recItem.Validate("Rupp Product Group Code", recProduct."Rupp Product Group Code");
                recItem.Validate("Inventory Posting Group", recProduct."Inventory Posting Group");
                recItem.Validate("Gen. Prod. Posting Group", recProduct."Gen. Prod. Posting Group");
                recItem."Inventory Status Code" := recProduct."Inventory Status Code";
                recItem.Validate("Global Dimension 1 Code", recProduct."Global Dimension 1 Code");
                recItem.Validate("Global Dimension 2 Code", recProduct."Global Dimension 2 Code");
                recItem.Validate("Vendor No.", recProduct."Vendor No.");
                if recProduct."Sale Item" then
                    recItem.Validate("Sales Blocked", false)
                else
                    recItem.Validate("Sales Blocked", true);
                if recProduct."Purchase Item" then
                    recItem.Validate("Purchasing Blocked", false)
                else
                    recItem.Validate("Purchasing Blocked", true);

                // TAE - Start Change
                recItem.Validate("Item Tracking Code", recProduct."Item Tracking Code");
                // TAE - End Change

                recItem.Validate("Base Unit of Measure", ItemCreationPkgSz."Package Size");
                recItem.Validate("Sales Unit of Measure", ItemCreationPkgSz."Package Size");
                recItem.Modify();

                retCnt += 1;

                // TAE - Begin Change
            end;
        // TAE - End Change

        until ItemCreationPkgSz.Next = 0;
        ItemCreationPkgSz.SetRange("Create Item");
    end;

    [Scope('Internal')]
    procedure GetExceedingCreditLimit(SalesLine: Record "Sales Line") retExceedingLimit: Boolean
    var
        recCust: Record Customer;
        recSL: Record "Sales Line";
        dTotalAmt: Decimal;
    begin
        //Called from Sales order subpage
        retExceedingLimit := false;

        if recCust.Get(SalesLine."Bill-to Customer No.") then begin
            recSL.SetCurrentKey("Document Type", "Bill-to Customer No.", "Currency Code");
            recSL.SetRange("Document Type", recSL."Document Type"::Order);
            recSL.SetRange("Bill-to Customer No.", SalesLine."Bill-to Customer No.");
            //recSL.SETRANGE(Type, recSL.Type::Item);
            //recSL.SETFILTER("Outstanding Amount", '>0');
            if recSL.FindSet() then begin
                recSL.CalcSums("Outstanding Amount");
                dTotalAmt := recSL."Outstanding Amount";
            end;
            recCust.CalcFields(Balance);
            dTotalAmt += recCust.Balance;
            retExceedingLimit := (dTotalAmt >= recCust."Credit Limit (LCY)");
        end;
    end;

    [Scope('Internal')]
    procedure UpdateItemCalculatedQuantities(var Item: Record Item)
    var
        RuppFunc: Codeunit "Rupp Functions";
        dQtyPerLUOM: Decimal;
    begin
        //SOC-MA

        with Item do begin
            "Product Qty. in Base UOM" := GetProductQuantity();
            "Qty. can be Produced" := GetQuantityCanBeProduced();
            "Qty. Available to Pick" := GetQuantityAvailableToPick();
            "Qty. Available to Sell" := GetQuantityAvailableToSell(); //SOC-SC 10-23-14
        end;
    end;

    [Scope('Internal')]
    procedure GetItemProductQuantity(var Item: Record Item) RetQty: Decimal
    begin
        //SOC-MA
        //Returns "Product Qty. in Base UOM"

        with Item do begin
            if ("Product Code" = '') or ("Qty. per Lowest UOM" = 0) then begin
                RetQty := 0;
            end else begin
                CalcFields("Product Qty. in Lowest UOM");
                RetQty := "Product Qty. in Lowest UOM" / "Qty. per Lowest UOM";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetItemQuantityAvailableToPick(var Item: Record Item) RetQty: Decimal
    begin
        //SOC-MA
        //Returns "Qty. Available to Pick in Base UOM"

        with Item do begin
            CalcFields(Inventory);
            CalcFields("Qty. on Pick");
            RetQty := Inventory - "Qty. on Pick";
        end;
    end;

    [Scope('Internal')]
    procedure GetItemQuantityCanBeProduced(var Item: Record Item) RetQty: Decimal
    var
        recItem: Record Item;
        dAvailableQty: Decimal;
    begin
        //SOC-MA
        //Returns "Qty. can be Produced in Base UOM" from other items with same Product Code

        /*
        WITH Item DO BEGIN
          IF ("Product Code" = '') OR ("Qty. per Lowest UOM" = 0) THEN BEGIN
            RetQty := 0;
          END ELSE BEGIN
            CALCFIELDS("Product Qty. in Lowest UOM");
            CALCFIELDS(Inventory);
            RetQty := "Product Qty. in Lowest UOM" / "Qty. per Lowest UOM";  //"Product Qty. in Base UOM"
            RetQty := RetQty - Inventory;
          END;
        END;
        */

        //Qty on Hand - Qty on Sales Order
        with Item do begin
            if ("Product Code" = '') or ("Qty. per Lowest UOM" = 0) then begin
                RetQty := 0;
            end else begin
                recItem.Reset;
                recItem.CopyFilters(Item);
                recItem.SetRange("Product Code", Item."Product Code");
                if recItem.FindSet() then begin
                    if "No." <> recItem."No." then begin
                        recItem.CalcFields(Inventory, "Qty. on Sales Order");
                        if recItem."Qty. per Lowest UOM" = 0 then
                            recItem.UpdateUOMQuantities();
                        dAvailableQty := (recItem.Inventory - recItem."Qty. on Sales Order") * recItem."Qty. per Lowest UOM";
                        RetQty := RetQty + dAvailableQty;
                    end;
                    RetQty := RetQty / "Qty. per Lowest UOM";
                end;
            end;
        end;

    end;

    [Scope('Internal')]
    procedure GetProductQuantityAvailableInCommonUOM(var Product: Record Product) RetQty: Decimal
    begin
        //SOC-MA

        with Product do begin
            CalcFields("Qty. on Purchase Orders", "Qty. on Sales Orders", "Qty. on Hand");
            RetQty := "Qty. on Hand" + "Qty. on Purchase Orders" - "Qty. on Sales Orders";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateProductCalculatedQuantities(var Product: Record Product)
    var
        RuppFunc: Codeunit "Rupp Functions";
        dQtyPerLUOM: Decimal;
    begin
        //SOC-MA
        with Product do begin
            "Qty. Available" := GetProductQuantityAvailableInCommonUOM(Product);
        end;
    end;

    [Scope('Internal')]
    procedure ItemProductQtyOnDrillDown(var Item: Record Item)
    var
        recILE: Record "Item Ledger Entry";
    begin

        //SOC-MA
        with Item do begin

            recILE.Reset;
            if "Product Code" = '' then begin
                recILE.SetRange("Product Code", '');
                recILE.SetRange("Item No.", "No.");
            end else begin
                recILE.SetRange("Product Code", "Product Code");
            end;
            //recILE.SETFILTER("Product Code", '<>%1&%2', '', "Product Code");

            if "Global Dimension 1 Filter" <> '' then
                recILE.SetRange("Global Dimension 1 Code", "Global Dimension 1 Filter");

            if "Global Dimension 2 Filter" <> '' then
                recILE.SetRange("Global Dimension 2 Code", "Global Dimension 2 Filter");

            if "Location Filter" <> '' then
                recILE.SetRange("Location Code", "Location Filter");

            if "Drop Shipment Filter" <> false then
                recILE.SetRange("Drop Shipment", "Drop Shipment Filter");

            if "Variant Filter" <> '' then
                recILE.SetRange("Variant Code", "Variant Filter");

            if "Lot No. Filter" <> '' then
                recILE.SetRange("Lot No.", "Lot No. Filter");

            if "Serial No. Filter" <> '' then
                recILE.SetRange("Serial No.", "Serial No. Filter");

            PAGE.Run(0, recILE);

        end;
    end;

    [Scope('Internal')]
    procedure UpdateItemUOMQuantities(var Item: Record Item)
    var
        recItemUOM: Record "Item Unit of Measure";
    begin

        with Item do begin
            if recItemUOM.Get("No.", "Base Unit of Measure") then begin
                if recItemUOM."Qty. per Lowest UOM" <> 0 then
                    "Qty. per Lowest UOM" := recItemUOM."Qty. per Lowest UOM";
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetItemQuantityAvailableToSell(var Item: Record Item) RetQty: Decimal
    var
        recInvStatus: Record "Rupp Reason Code";
        tEndDate: Date;
    begin
        //SOC-SC
        //Returns "Qty. Available to Sell in Base UOM"

        with Item do begin
            CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Consumption");
            RetQty := Inventory - "Qty. on Sales Order" - "Qty. on Consumption";
            //  IF Item."Inventory Status Code" <> '' THEN BEGIN
            //    IF recInvStatus.GET(recInvStatus.Type::"Inventory Status", Item."Inventory Status Code") THEN BEGIN
            //      IF recInvStatus."Inv Status Check POs in a Year" THEN BEGIN
            tEndDate := CalcDate('M7');
            Item.SetFilter("Date Filter", '..%1', tEndDate);
            Item.CalcFields("Qty On PO");
            RetQty += Item."Qty On PO";
            Item.SetRange("Date Filter");
            //      END;
            //    END;
            //  END;
        end;
    end;
}

