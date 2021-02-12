table 50021 "Produced Item"
{
    // // RSI-KS 11-05-15
    //   Add Tracking Enabled field, similar to what is on the Consumed Items table

    DataCaptionFields = "Work Order No.", Description;

    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Work Order"."No.";

            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                //ToDo
                TestStatusOpen;
                SetDefaultFromWorkOrder;
            end;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(5; "Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }
        field(6; "Creation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Creation Date';
            Editable = false;
        }
        field(7; "Last Date Modified"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item WHERE(Type = CONST(Inventory));

            trigger OnValidate()
            begin

                TestStatusOpen;
                SetDefaultFromWorkOrder;

                if "Item No." = '' then begin
                    "Unit of Measure Code" := '';
                    Quantity := 0;
                    "Variant Code" := '';
                    "Location Code" := '';
                    "Bin Code" := '';
                end else begin
                    SetDescriptionsFromItem;
                    Validate("Unit of Measure Code", Item."Base Unit of Measure");
                    GetDefaultBin;
                end;
            end;
        }
        field(12; "Variant Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."),
                                                       Code = FIELD("Variant Code"));

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin

                TestStatusOpen;
                if "Variant Code" = '' then begin
                    SetDescriptionsFromItem
                end else begin
                    ItemVariant.Get("Item No.", "Variant Code");
                    Description := ItemVariant.Description;
                    "Description 2" := ItemVariant."Description 2";
                end;
                GetDefaultBin;
            end;
        }
        field(15; "Inventory Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory Posting Group';
            Description = 'ToCheck';
            TableRelation = "Inventory Posting Group";
        }
        field(16; "Gen. Prod. Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Prod. Posting Group';
            Description = 'ToCheck';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin

                TestStatusOpen;
            end;
        }
        field(20; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin

                TestStatusOpen;
                GetDefaultBin;
            end;
        }
        field(23; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                ATOLink: Record "Assemble-to-Order Link";
                SalesHeader: Record "Sales Header";
            begin
            end;
        }
        field(24; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
            Description = 'ToCheck';
        }
        field(25; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date';
            Description = 'ToCheck';
        }
        field(27; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
            Description = 'ToCheck';
        }
        field(33; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bin Code';
            TableRelation = IF (Quantity = FILTER(< 0)) "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                                                     "Item No." = FIELD("Item No."),
                                                                                     "Variant Code" = FIELD("Variant Code"))
            ELSE
            Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin

                if Quantity < 0 then
                    BinCode := WMSManagement.BinContentLookUp("Location Code", "Item No.", "Variant Code", '', "Bin Code")
                else
                    BinCode := WMSManagement.BinLookUp("Location Code", "Item No.", "Variant Code", '');

                if BinCode <> '' then
                    Validate("Bin Code", BinCode);
            end;

            trigger OnValidate()
            begin

                ValidateBinCode("Bin Code");
            end;
        }
        field(40; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin

                TestStatusOpen;
                TestField("Item No.");  //SOC-MA 08-08-15

                RoundQty(Quantity);

                UpdateAssembledQty();   //SOC-MA

                if Quantity < "Assembled Quantity" then
                    Error(Text002, FieldCaption(Quantity), FieldCaption("Assembled Quantity"), "Assembled Quantity");

                "Quantity (Base)" := CalcBaseQty(Quantity);
                InitRemainingQty;

                InitQtyToAssemble;
                Validate("Quantity to Assemble");
            end;
        }
        field(41; "Quantity (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                TestStatusOpen;
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
            end;
        }
        field(42; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(43; "Remaining Quantity (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(44; "Assembled Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Assembled Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(45; "Assembled Quantity (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Assembled Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(46; "Quantity to Assemble"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Assemble';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ATOLink: Record "Assemble-to-Order Link";
            begin

                InitRemainingQty();  //SOC-MA

                RoundQty("Quantity to Assemble");
                if "Quantity to Assemble" > "Remaining Quantity" then
                    Error(Text003, FieldCaption("Quantity to Assemble"), FieldCaption("Remaining Quantity"), "Remaining Quantity");


                Validate("Quantity to Assemble (Base)", CalcBaseQty("Quantity to Assemble"));
            end;
        }
        field(47; "Quantity to Assemble (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Assemble (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                UpdateCustomQuantities(); //SOC-MA
            end;
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin

                TestField("Assembled Quantity", 0);
                TestStatusOpen;

                GetItem;
                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

                Validate(Quantity);
            end;
        }
        field(81; "Qty. per Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin

                TestStatusOpen;
            end;
        }
        field(120; Status; Option)
        {
            CalcFormula = Lookup ("Work Order".Status WHERE("No." = FIELD("Work Order No.")));
            Caption = 'Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Open,Finished';
            OptionMembers = Open,Finished;
        }
        field(150; Screen; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(160; "Fraction All"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 10;
        }
        field(161; "Fraction Without Screen"; Decimal)
        {
            DecimalPlaces = 0 : 10;
        }
        field(200; "Bag Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;

            trigger OnLookup()
            var
                recConsItem: Record "Consumed Item";
            begin

                recConsItem.Reset;
                recConsItem.SetRange("Work Order No.", "Work Order No.");
                recConsItem.SetRange(Type, recConsItem.Type::Item);
                recConsItem.SetRange("Consume for Screen", false);
                if recConsItem.FindSet() then begin
                    if PAGE.RunModal(50107, recConsItem) = ACTION::LookupOK then begin
                        Validate("Bag Item No.", recConsItem."No.");
                    end else begin
                        //MESSAGE('not ok');
                    end;
                end;
            end;

            trigger OnValidate()
            var
                recConsItem: Record "Consumed Item";
            begin

                recConsItem.Reset;
                recConsItem.SetRange("Work Order No.", "Work Order No.");
                recConsItem.SetRange(Type, recConsItem.Type::Item);
                recConsItem.SetRange("Consume for Screen", false);
                recConsItem.SetRange("No.", "Bag Item No.");
                if not recConsItem.FindFirst() then
                    Error('Item is not in the Consumed Items');
            end;
        }
        field(201; "Bag Quantity"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'SOC-MA 08-02-15';
        }
        field(500; "Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(501; "Qty. to Assemble in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(502; "Assembled Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(503; "Remaining Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(510; "Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(511; "Qty. to Assemble in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(512; "Assembled Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(513; "Remaining Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(520; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Lot No.';
            Description = 'SOC-MA 06-26-15';

            trigger OnValidate()
            var
                recItem: Record Item;
            begin

                if "Lot No." <> '' then begin
                    if recItem.Get("Item No.") then begin
                        if recItem."Item Tracking Code" = '' then
                            Error('Item No. %1 does not require a Lot No.', "Item No.");
                    end else begin
                        Error('Item No. is missing');
                    end;
                end;
            end;
        }
        field(521; "Tracking Enabled"; Boolean)
        {
            CalcFormula = Exist (Item WHERE("No." = FIELD("Item No."),
                                            "Item Tracking Code" = FILTER(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        TestField("Assembled Quantity", 0);
    end;

    trigger OnInsert()
    var
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recWO: Record "Work Order";
    begin

        InitRecord;
    end;

    trigger OnModify()
    begin

        TestStatusOpen;
        "Last Date Modified" := Today();
    end;

    trigger OnRename()
    begin

        Error(Text009, TableCaption);
    end;

    var
        AssemblySetup: Record "Assembly Setup";
        Text001: Label '%1 %2 cannot be created, because it already exists or has been posted.', Comment = '%1 = Document Type, %2 = No.';
        Text002: Label '%1 cannot be lower than the %2, which is %3.';
        Text003: Label '%1 cannot be higher than the %2, which is %3.';
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        StockkeepingUnit: Record "Stockkeeping Unit";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        GLSetupRead: Boolean;
        Text005: Label 'Changing %1 or %2 is not allowed when %3 is %4.';
        Text007: Label 'Nothing to handle.';
        Text008: Label 'Item tracking is defined for one or more lines on assembly %1 %2. Do you want to delete the %1 anyway?', Comment = '%1 = Document Type, %2 = No.';
        Text009: Label 'You cannot rename an %1.';
        StatusCheckSuspended: Boolean;
        TestReservationDateConflict: Boolean;
        CurrentFieldNum: Integer;
        Text010: Label 'You have modified %1.';
        Text011: Label 'the %1 from %2 to %3';
        Text012: Label '%1 %2', Comment = 'By design, translate as %1 %2';
        Text013: Label 'Do you want to update %1?';
        Text014: Label '%1 and %2';
        Text015: Label '%1 %2 is before %3 %4.', Comment = '%1 and %3 = Date Captions, %2 and %4 = Date Values';
        PostingDateLaterErr: Label 'Posting Date on Assembly Order %1 must not be later than the Posting Date on Sales Order %2.';
        RowIdx: Option ,MatCost,ResCost,ResOvhd,AsmOvhd,Total;

    [Scope('Internal')]
    procedure RefreshBOM()
    begin

        //AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,0,TRUE,CurrFieldNo,0);
    end;

    [Scope('Internal')]
    procedure InitRecord()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin


        SetDefaultFromWorkOrder;
    end;

    [Scope('Internal')]
    procedure InitRemainingQty()
    begin

        UpdateAssembledQty();   //SOC-MA

        "Remaining Quantity" := Quantity - "Assembled Quantity";
        "Remaining Quantity (Base)" := "Quantity (Base)" - "Assembled Quantity (Base)";
    end;

    [Scope('Internal')]
    procedure InitQtyToAssemble()
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin


        "Quantity to Assemble" := "Remaining Quantity";
        "Quantity to Assemble (Base)" := "Remaining Quantity (Base)";
    end;

    local procedure GetItem()
    begin

        TestField("Item No.");
        if Item."No." <> "Item No." then
            Item.Get("Item No.");
    end;

    local procedure GetLocation(var Location: Record Location; LocationCode: Code[10])
    begin

        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure SetDefaultFromWorkOrder()
    var
        AsmSetup: Record "Assembly Setup";
        recWO: Record "Work Order";
    begin

        if "Work Order No." <> '' then begin
            if recWO.Get("Work Order No.") then begin
                if ("Location Code" = '') or ("Bin Code" = '') then begin
                    if ("Location Code" = '') and (recWO."Location Code" <> '') then
                        "Location Code" := recWO."Location Code";
                    if ("Bin Code" = '') and (recWO."Bin Code" <> '') then
                        "Bin Code" := recWO."Bin Code";
                end;

                if "Creation Date" = 0D then
                    "Creation Date" := Today;

                if "Due Date" = 0D then
                    "Due Date" := recWO."Due Date";
                if "Due Date" = 0D then
                    "Due Date" := WorkDate;

                if "Posting Date" = 0D then
                    "Posting Date" := recWO."Posting Date";
                if "Posting Date" = 0D then
                    "Posting Date" := WorkDate;

                if "Starting Date" = 0D then
                    "Starting Date" := WorkDate;

                if "Ending Date" = 0D then
                    "Ending Date" := WorkDate;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure CalcBaseQty(Qty: Decimal): Decimal
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin

        exit(UOMMgt.CalcBaseQty(Qty, "Qty. per Unit of Measure"));
    end;

    [Scope('Internal')]
    procedure RoundQty(var Qty: Decimal)
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin

        Qty := UOMMgt.RoundQty(Qty);
    end;

    local procedure GetSKU(): Boolean
    begin

        if (StockkeepingUnit."Location Code" = "Location Code") and
           (StockkeepingUnit."Item No." = "Item No.") and
           (StockkeepingUnit."Variant Code" = "Variant Code")
        then
            exit(true);
        if StockkeepingUnit.Get("Location Code", "Item No.", "Variant Code") then
            exit(true);

        exit(false);
    end;

    local procedure CheckBin()
    var
        BinContent: Record "Bin Content";
        Bin: Record Bin;
        Location: Record Location;
    begin

        if "Bin Code" <> '' then begin
            GetLocation(Location, "Location Code");
            if not Location."Directed Put-away and Pick" then
                exit;

            if BinContent.Get(
                 "Location Code", "Bin Code",
                 "Item No.", "Variant Code", "Unit of Measure Code")
            then
                BinContent.CheckWhseClass(false)
            else begin
                Bin.Get("Location Code", "Bin Code");
                Bin.CheckWhseClass("Item No.", false);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetDefaultBin()
    var
        Location: Record Location;
        WMSManagement: Codeunit "WMS Management";
    begin

        if (Quantity * xRec.Quantity > 0) and
           ("Item No." = xRec."Item No.") and
           ("Location Code" = xRec."Location Code") and
           ("Variant Code" = xRec."Variant Code")
        then
            exit;

        if "Bin Code" = '' then begin
            if ("Location Code" <> '') and ("Item No." <> '') then begin
                GetLocation(Location, "Location Code");
                if GetFromAssemblyBin(Location, "Bin Code") then
                    exit;

                if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                    WMSManagement.GetDefaultBin("Item No.", "Variant Code", "Location Code", "Bin Code");
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetFromAssemblyBin(Location: Record Location; var BinCode: Code[20]) BinCodeNotEmpty: Boolean
    begin

        if Location."Bin Mandatory" then
            BinCode := Location."From-Assembly Bin Code";
        BinCodeNotEmpty := BinCode <> '';
    end;

    [Scope('Internal')]
    procedure ValidateBinCode(NewBinCode: Code[20])
    var
        WMSManagement: Codeunit "WMS Management";
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
    begin

        "Bin Code" := NewBinCode;
        TestStatusOpen;

        if "Bin Code" <> '' then begin
            if Quantity < 0 then
                WMSManagement.FindBinContent("Location Code", "Bin Code", "Item No.", "Variant Code", '')
            else
                WMSManagement.FindBin("Location Code", "Bin Code", '');

            WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Assembly Header",
              FieldCaption("Bin Code"),
              "Location Code",
              "Bin Code", 0);
            CheckBin;
        end;
    end;

    [Scope('Internal')]
    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin

        if not Item2.Get(ItemNo) then
            exit(false);
        exit(true);
    end;

    local procedure TestStatusOpen()
    begin

        if StatusCheckSuspended then
            exit;

        if "Line No." = 0 then    //SOC-MA 09-26-15
            exit;                   //SOC-MA 09-26-15

        CalcFields(Status);
        TestField(Status, Status::Open);
    end;

    [Scope('Internal')]
    procedure ShowAvailability()
    var
        TempAssemblyHeader: Record "Assembly Header" temporary;
        TempAssemblyLine: Record "Assembly Line" temporary;
        AsmLineMgt: Codeunit "Assembly Line Management";
    begin
        //delete
        /*
        AsmLineMgt.CopyAssemblyData(Rec,TempAssemblyHeader,TempAssemblyLine);
        AsmLineMgt.ShowAvailability(TRUE,TempAssemblyHeader,TempAssemblyLine);
        */

    end;

    [Scope('Internal')]
    procedure AddBOMLine(BOMComp: Record "BOM Component")
    var
        AsmLine: Record "Assembly Line";
    begin
        //delete
        /*
        AssemblyLineMgt.AddBOMLine(Rec,AsmLine,BOMComp);
        AutoReserveAsmLine(AsmLine);
        */

    end;

    local procedure SetDescriptionsFromItem()
    begin

        GetItem;
        Description := Item.Description;
        "Description 2" := Item."Description 2";
    end;

    [Scope('Internal')]
    procedure UpdateCustomQuantities()
    var
        cduRuppFNMA: Codeunit "Rupp Functions MA";
    begin

        //SOC-MA 08-24-14
        UpdateAssembledQty();   //SOC-MA

        if ("Item No." <> '') then begin
            cduRuppFNMA.GetQtyLUOMandQtyCUOM("Item No.", "Unit of Measure Code", Quantity, "Qty. in Lowest UOM", "Qty. in Common UOM");
            cduRuppFNMA.GetQtyLUOMandQtyCUOM("Item No.", "Unit of Measure Code", "Quantity to Assemble", "Qty. to Assemble in Lowest UOM", "Qty. to Assemble in Common UOM");
            cduRuppFNMA.GetQtyLUOMandQtyCUOM("Item No.", "Unit of Measure Code", "Assembled Quantity", "Assembled Qty. in Lowest UOM", "Assembled Qty. in Common UOM");
            cduRuppFNMA.GetQtyLUOMandQtyCUOM("Item No.", "Unit of Measure Code", "Remaining Quantity", "Remaining Qty. in Lowest UOM", "Remaining Qty. in Common UOM");
        end else begin
            "Qty. in Lowest UOM" := 0;
            "Qty. in Common UOM" := 0;
            "Qty. to Assemble in Lowest UOM" := 0;
            "Qty. to Assemble in Common UOM" := 0;
            "Assembled Qty. in Lowest UOM" := 0;
            "Assembled Qty. in Common UOM" := 0;
            "Remaining Qty. in Lowest UOM" := 0;
            "Remaining Qty. in Common UOM" := 0;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateAssembledQty()
    var
        recPostedAssemblyHeader: Record "Posted Assembly Header";
        dAssembledQty: Decimal;
    begin

        //CALCFIELDS("Assembled Quantity", "Assembled Quantity (Base)");  //SOC-MA
        dAssembledQty := 0;
        recPostedAssemblyHeader.Reset;
        recPostedAssemblyHeader.SetRange("Work Order No.", "Work Order No.");
        recPostedAssemblyHeader.SetRange("Item No.", "Item No.");
        if recPostedAssemblyHeader.FindSet() then begin
            recPostedAssemblyHeader.CalcSums(Quantity);
            dAssembledQty := recPostedAssemblyHeader.Quantity;
        end;

        if "Assembled Quantity" <> dAssembledQty then
            Validate("Assembled Quantity", dAssembledQty);
    end;
}

