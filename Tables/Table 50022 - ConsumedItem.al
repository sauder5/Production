table 50022 "Consumed Item"
{
    // //SOC-SC 08-28-15
    //   Changed field Status from Flowfield to Normal
    //   Added field
    //     600; Template; Boolean
    //   Added key:Type,No.,Variant Code,Location Code,Due Date,Template,Status and SIF
    // 
    // //SOC-SC 09-28-15
    //   Update Consumed Quantity (Base)

    DrillDownPageID = "Consumed Item List";
    LookupPageID = "Consumed Item List";

    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Work Order"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
            Editable = false;
        }
        field(10; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            OptionCaption = ' ,Item,Resource';
            OptionMembers = " ",Item,Resource;

            trigger OnValidate()
            begin

                TestField("Consumed Quantity", 0);
                TestStatusOpen;

                "No." := '';
                "Variant Code" := '';
                "Location Code" := '';
                "Bin Code" := '';
                InitResourceUsageType;
                //"Inventory Posting Group" := '';
                //"Gen. Prod. Posting Group" := '';
                //CLEAR(FindLine);
            end;
        }
        field(11; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            TableRelation = IF (Type = CONST (Item)) Item WHERE (Type = CONST (Inventory))
            ELSE
            IF (Type = CONST (Resource)) Resource;

            trigger OnValidate()
            begin

                TestField("Consumed Quantity", 0);

                if "No." <> '' then
                    CheckItemAvailable(FieldNo("No."));
                TestStatusOpen;

                if "No." <> xRec."No." then begin
                    "Variant Code" := '';
                    InitResourceUsageType;
                end;

                if "No." = '' then
                    Init
                else begin
                    //  "Due Date" := AssemblyHeader."Starting Date";
                    case Type of
                        Type::Item:
                            begin
                                //        "Location Code" := AssemblyHeader."Location Code";
                                GetItemResource;
                                Item.TestField("Inventory Posting Group");
                                GetDefaultBin;
                                Description := Item.Description;
                                "Description 2" := Item."Description 2";
                                //        ItemExists := GetUnitCost;
                                Validate("Unit of Measure Code", Item."Base Unit of Measure");
                                Validate(Quantity);
                                //        VALIDATE("Quantity to Consume", MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                            end;
                        Type::Resource:
                            begin
                                GetItemResource;
                                Resource.TestField("Gen. Prod. Posting Group");
                                Description := Resource.Name;
                                "Description 2" := Resource."Name 2";
                                //        ItemExists := GetUnitCost;
                                Validate("Unit of Measure Code", Resource."Base Unit of Measure");
                                Validate(Quantity);
                                //        VALIDATE("Quantity to Consume", MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                            end;
                    end
                end;
            end;
        }
        field(12; "Variant Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST (Item)) "Item Variant".Code WHERE ("Item No." = FIELD ("No."),
                                                                             Code = FIELD ("Variant Code"));

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin

                TestField(Type, Type::Item);
                TestField("Consumed Quantity", 0);
                CheckItemAvailable(FieldNo("Variant Code"));
                TestStatusOpen;

                if "Variant Code" = '' then begin
                    GetItemResource;
                    Description := Item.Description;
                    "Description 2" := Item."Description 2"
                end else begin
                    ItemVariant.Get("No.", "Variant Code");
                    Description := ItemVariant.Description;
                    "Description 2" := ItemVariant."Description 2";
                end;

                GetDefaultBin;
            end;
        }
        field(13; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(14; "Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }
        field(19; "Resource Usage Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Usage Type';
            OptionCaption = ' ,Direct,Fixed';
            OptionMembers = " ",Direct,"Fixed";

            trigger OnValidate()
            begin
                if "Resource Usage Type" = xRec."Resource Usage Type" then
                    exit;

                if Type = Type::Resource then
                    TestField("Resource Usage Type")
                else
                    TestField("Resource Usage Type", "Resource Usage Type"::" ");
            end;
        }
        field(20; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
            TableRelation = Location WHERE ("Use As In-Transit" = CONST (false));

            trigger OnValidate()
            begin

                TestField(Type, Type::Item);

                CheckItemAvailable(FieldNo("Location Code"));
                TestStatusOpen;

                GetDefaultBin;

                CheckLotAvailability(); //SOC-MA
            end;
        }
        field(23; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE ("Location Code" = FIELD ("Location Code"));

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin

                TestField(Type, Type::Item);
                if Quantity > 0 then
                    BinCode := WMSManagement.BinContentLookUp("Location Code", "No.", "Variant Code", '', "Bin Code")
                else
                    BinCode := WMSManagement.BinLookUp("Location Code", "No.", "Variant Code", '');

                if BinCode <> '' then
                    Validate("Bin Code", BinCode);
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
                WhseIntegrationMgt: Codeunit "Whse. Integration Management";
            begin

                TestStatusOpen;
                TestField(Type, Type::Item);
                if "Bin Code" <> '' then begin
                    TestField("Location Code");
                    WMSManagement.FindBin("Location Code", "Bin Code", '');
                    WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Assembly Line",
                      FieldCaption("Bin Code"),
                      "Location Code",
                      "Bin Code", 0);
                    CheckBin;
                end;

                CheckLotAvailability(); //SOC-MA
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

                RoundQty(Quantity);

                UpdateConsumedQty();    //SOC-MA

                "Quantity (Base)" := CalcBaseQty(Quantity);
                InitRemainingQty;
                InitQtyToConsume;
                Validate("Quantity to Consume");
            end;
        }
        field(41; "Quantity (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
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
        field(44; "Consumed Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Consumed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(45; "Consumed Quantity (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Consumed Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(46; "Quantity to Consume"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Consume';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin

                RoundQty("Quantity to Consume");

                CheckLotAvailability(); //SOC-MA

                InitRemainingQty();  //SOC-MA

                RoundQty("Remaining Quantity");
                if "Quantity to Consume" > "Remaining Quantity" then
                    Error(Text003,
                      FieldCaption("Quantity to Consume"), FieldCaption("Remaining Quantity"), "Remaining Quantity");

                Validate("Quantity to Consume (Base)", CalcBaseQty("Quantity to Consume"));
            end;
        }
        field(47; "Quantity to Consume (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Consume (Base)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(50; "Avail. Warning"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Avail. Warning';
            Editable = false;
        }
        field(51; "Substitution Available"; Boolean)
        {
            CalcFormula = Exist ("Item Substitution" WHERE (Type = CONST (Item),
                                                           "Substitute Type" = CONST (Item),
                                                           "No." = FIELD ("No."),
                                                           "Variant Code" = FIELD ("Variant Code")));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }
        field(60; "Quantity per"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin

                TestStatusOpen;

                if Type = Type::" " then
                    Error(Text99000002, FieldCaption("Quantity per"), FieldCaption(Type), Type::" ");
                RoundQty("Quantity per");

                /*
                VALIDATE(Quantity,CalcQuantity("Quantity per",AssemblyHeader.Quantity));
                VALIDATE("Quantity to Consume", MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                */

            end;
        }
        field(61; "Qty. per Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST (Item)) "Item Unit of Measure".Code WHERE ("Item No." = FIELD ("No."))
            ELSE
            IF (Type = CONST (Resource)) "Resource Unit of Measure".Code WHERE ("Resource No." = FIELD ("No."));

            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin

                TestStatusOpen;

                GetItemResource;
                case Type of
                    Type::Item:
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                    Type::Resource:
                        "Qty. per Unit of Measure" := UOMMgt.GetResQtyPerUnitOfMeasure(Resource, "Unit of Measure Code");
                    else
                        "Qty. per Unit of Measure" := 1;
                end;

                CheckItemAvailable(FieldNo("Unit of Measure Code"));
                Validate(Quantity);
            end;
        }
        field(120; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionCaption = 'Open,Finished';
            OptionMembers = Open,Finished;
        }
        field(150; "Consume for Screen"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(500; "Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(501; "Qty. to Consume in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Consume';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin

                RoundQty("Quantity to Consume");
                RoundQty("Remaining Quantity");
                if "Quantity to Consume" > "Remaining Quantity" then
                    Error(Text003,
                      FieldCaption("Quantity to Consume"), FieldCaption("Remaining Quantity"), "Remaining Quantity");

                Validate("Quantity to Consume (Base)", CalcBaseQty("Quantity to Consume"));
            end;
        }
        field(502; "Consumed Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Consumed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(503; "Remaining Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(510; "Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(511; "Qty. to Consume in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity to Consume';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin

                RoundQty("Quantity to Consume");
                RoundQty("Remaining Quantity");
                if "Quantity to Consume" > "Remaining Quantity" then
                    Error(Text003,
                      FieldCaption("Quantity to Consume"), FieldCaption("Remaining Quantity"), "Remaining Quantity");

                Validate("Quantity to Consume (Base)", CalcBaseQty("Quantity to Consume"));
            end;
        }
        field(512; "Consumed Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Consumed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(513; "Remaining Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(520; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Lot No.';

            trigger OnValidate()
            begin

                TestField(Type, Type::Item);
                CheckLotAvailability();
            end;
        }
        field(521; "Tracking Enabled"; Boolean)
        {
            CalcFormula = Exist (Item WHERE ("No." = FIELD ("No."),
                                            "Item Tracking Code" = FILTER (<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(530; "Is a Bag"; Boolean)
        {
            CalcFormula = Exist ("Produced Item" WHERE ("Work Order No." = FIELD ("Work Order No."),
                                                       "Bag Item No." = FIELD ("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(600; Template; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Work Order No.", Type, "No.", "Variant Code", "Location Code", "Due Date")
        {
            SumIndexFields = "Remaining Quantity (Base)", "Consumed Quantity (Base)";
        }
        key(Key3; Type, "No.")
        {
        }
        key(Key4; Type, "No.", "Variant Code", "Location Code", "Due Date", Template, Status)
        {
            SumIndexFields = "Remaining Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        WhseAssemblyRelease: Codeunit "Whse.-Assembly Release";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
    begin

        TestStatusOpen;

        //TESTFIELD("Consumed Quantity", 0);
    end;

    trigger OnInsert()
    begin

        TestStatusOpen;
        UpdateHeaderFields();
    end;

    trigger OnModify()
    begin

        TestStatusOpen;
    end;

    trigger OnRename()
    begin

        Error(Text002, TableCaption);
    end;

    var
        Item: Record Item;
        Resource: Record Resource;
        Text001: Label 'Automatic reservation is not possible.\Do you want to reserve items manually?';
        Text002: Label 'You cannot rename an %1.';
        Text003: Label '%1 cannot be higher than the %2, which is %3.';
        Text029: Label 'must be positive', Comment = 'starts with "Quantity"';
        Text042: Label 'When posting the Applied to Ledger Entry, %1 will be opened first.';
        Text99000002: Label 'You cannot change %1 when %2 is ''%3''.';
        StockkeepingUnit___: Record "Stockkeeping Unit";
        GLSetup: Record "General Ledger Setup";
        ItemSubstMgt: Codeunit "Item Subst.";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        StatusCheckSuspended: Boolean;
        SkipVerificationsThatChangeDatabase: Boolean;
        Text049: Label '%1 cannot be later than %2 because the %3 is set to %4.';
        Text050: Label 'Due Date %1 is before work date %2.';

    [Scope('Internal')]
    procedure Refresh(NewQuantity: Decimal)
    begin
        Validate(Quantity, NewQuantity);
    end;

    [Scope('Internal')]
    procedure InitRemainingQty()
    begin

        UpdateConsumedQty();    //SOC-MA

        "Remaining Quantity" := Quantity - "Consumed Quantity";                 //MaxValue(Quantity - "Consumed Quantity",0);
        "Remaining Quantity (Base)" := "Quantity (Base)" - "Consumed Quantity (Base)";  //MaxValue("Quantity (Base)" - "Consumed Quantity (Base)",0);
    end;

    [Scope('Internal')]
    procedure InitQtyToConsume()
    begin

        //"Quantity to Consume"        := 0;
        //"Quantity to Consume (Base)" := 0;

        "Quantity to Consume" := "Remaining Quantity";
        "Quantity to Consume (Base)" := "Remaining Quantity (Base)";
    end;

    [Scope('Internal')]
    procedure MaxQtyToConsume(): Decimal
    begin

        exit("Remaining Quantity");
    end;

    [Scope('Internal')]
    procedure MaxQtyToConsumeBase(): Decimal
    begin

        exit("Remaining Quantity (Base)");
    end;

    procedure CheckItemAvailable(CalledByFieldNo: Integer)
    var
        AssemblySetup: Record "Assembly Setup";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
    begin
        //ToDO
        /*
        IF NOT UpdateAvailWarning THEN
          EXIT;
        
        IF "Document Type" <> "Document Type"::Order THEN
          EXIT;
        
        AssemblySetup.GET;
        IF NOT AssemblySetup."Stockout Warning" THEN
          EXIT;
        
        IF Reserve = Reserve::Always THEN
          EXIT;
        
        IF (CalledByFieldNo = CurrFieldNo) OR
           ((CalledByFieldNo = FIELDNO("No.")) AND (CurrFieldNo <> 0)) OR
           ((CalledByFieldNo = FIELDNO(Quantity)) AND (CurrFieldNo = FIELDNO("Quantity per")))
        THEN
          IF ItemCheckAvail.AssemblyLineCheck(Rec) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
        */

    end;

    [Scope('Internal')]
    procedure ShowAvailabilityWarning()
    var
        ItemCheckAvail: Codeunit "Item-Check Avail.";
    begin
        //ToDo
        /*
        TESTFIELD(Type,Type::Item);
        
        IF "Due Date" = 0D THEN BEGIN
          GetHeader;
          IF AssemblyHeader."Due Date" <> 0D THEN
            VALIDATE("Due Date",AssemblyHeader."Due Date")
          ELSE
            VALIDATE("Due Date",WORKDATE);
        END;
        
        ItemCheckAvail.AssemblyLineCheck(Rec);
        */

    end;

    procedure CalcBaseQty(Qty: Decimal): Decimal
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin

        exit(UOMMgt.CalcBaseQty(Qty, "Qty. per Unit of Measure"));
    end;

    procedure CalcQtyFromBase(QtyBase: Decimal): Decimal
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin

        exit(UOMMgt.CalcQtyFromBase(QtyBase, "Qty. per Unit of Measure"));
    end;

    procedure GetItemResource()
    begin

        if Type = Type::Item then
            if Item."No." <> "No." then
                Item.Get("No.");
        if Type = Type::Resource then
            if Resource."No." <> "No." then
                Resource.Get("No.");
    end;

    procedure GetLocation(var Location: Record Location; LocationCode: Code[10])
    begin

        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    [Scope('Internal')]
    procedure TypeToID(Type: Option " ",Item,Resource): Integer
    begin

        case Type of
            Type::" ":
                exit(0);
            Type::Item:
                exit(DATABASE::Item);
            Type::Resource:
                exit(DATABASE::Resource);
        end;
    end;

    [Scope('Internal')]
    procedure ShowItemSub()
    begin

        //ItemSubstMgt.ItemAssemblySubstGet(Rec);
    end;

    [Scope('Internal')]
    procedure CalcQuantityPer(Qty: Decimal): Decimal
    begin

        //AssemblyHeader.TESTFIELD(Quantity);

        /*
        IF FixedUsage THEN
          EXIT(Qty);
        
        EXIT(Qty / AssemblyHeader.Quantity);
        */

    end;

    [Scope('Internal')]
    procedure CalcQuantityFromBOM(LineType: Option; QtyPer: Decimal; HeaderQty: Decimal; HeaderQtyPerUOM: Decimal; LineResourceUsageType: Option): Decimal
    begin

        //ToCheck
        /*
        IF FixedUsage2(LineType,LineResourceUsageType) THEN
          EXIT(QtyPer);
        
        EXIT(QtyPer * HeaderQty * HeaderQtyPerUOM);
        */

    end;

    [Scope('Internal')]
    procedure CalcQuantity(LineQtyPer: Decimal; HeaderQty: Decimal): Decimal
    begin
        //ToCheck

        /*
        EXIT(CalcQuantityFromBOM(Type,LineQtyPer,HeaderQty,1,"Resource Usage Type"));
        */

    end;

    procedure GetEarliestAvailDate(GrossRequirement: Decimal; ExcludeQty: Decimal; ExcludeDate: Date): Date
    var
        CompanyInfo: Record "Company Information";
        AvailableToPromise: Codeunit "Available to Promise";
        QtyAvailable: Decimal;
    begin

        //ToCheck
        /*
        CompanyInfo.GET;
        GetItemResource;
        SetItemFilter(Item);
        
        EXIT(
          AvailableToPromise.EarliestAvailabilityDate(
            Item,
            GrossRequirement,
            "Due Date",
            ExcludeQty,
            ExcludeDate,
            QtyAvailable,
            CompanyInfo."Check-Avail. Time Bucket",
            CompanyInfo."Check-Avail. Period Calc."));
        */

    end;

    procedure CalcAvailQuantities(var Item: Record Item; var GrossRequirement: Decimal; var ScheduledReceipt: Decimal; var ExpectedInventory: Decimal; var AvailableInventory: Decimal; var EarliestDate: Date)
    var
        AssemblyLine: Record "Assembly Line";
        AvailableToPromise: Codeunit "Available to Promise";
        ReservedReceipt: Decimal;
        ReservedRequirement: Decimal;
    begin
        //ToCheck

        /*
        SetItemFilter(Item);
        AvailableInventory := AvailableToPromise.CalcAvailableInventory(Item);
        ScheduledReceipt := AvailableToPromise.CalcScheduledReceipt(Item);
        GrossRequirement := AvailableToPromise.CalcGrossRequirement(Item);
        ReservedReceipt := AvailableToPromise.CalcReservedReceipt(Item);
        ReservedRequirement := AvailableToPromise.CalcReservedRequirement(Item);
        ExpectedInventory :=
          CalcExpectedInventory(AvailableInventory,ScheduledReceipt - ReservedReceipt,GrossRequirement - ReservedRequirement);
        
        IF NOT OrderLineExists(AssemblyLine) THEN
          EarliestDate := GetEarliestAvailDate("Remaining Quantity (Base)",0,0D)
        ELSE BEGIN
          GrossRequirement -= AssemblyLine."Remaining Quantity (Base)";
          ExpectedInventory :=
            CalcExpectedInventory(AvailableInventory,ScheduledReceipt - ReservedReceipt,GrossRequirement - ReservedRequirement);
          EarliestDate :=
            GetEarliestAvailDate("Remaining Quantity (Base)",AssemblyLine."Remaining Quantity (Base)",AssemblyLine."Due Date")
        END;
        
        AvailableInventory := CalcQtyFromBase(AvailableInventory);
        GrossRequirement := CalcQtyFromBase(GrossRequirement);
        ScheduledReceipt := CalcQtyFromBase(ScheduledReceipt);
        ExpectedInventory := CalcQtyFromBase(ExpectedInventory);
        */

    end;

    procedure CalcExpectedInventory(Inventory: Decimal; ScheduledReceipt: Decimal; GrossRequirement: Decimal): Decimal
    begin
        //ToCheck
        exit(Inventory + ScheduledReceipt - GrossRequirement);
    end;

    [Scope('Internal')]
    procedure CalcAvailToAssemble(AssemblyHeader: Record "Assembly Header"; var Item: Record Item; var GrossRequirement: Decimal; var ScheduledReceipt: Decimal; var ExpectedInventory: Decimal; var AvailableInventory: Decimal; var EarliestDate: Date; var AbleToAssemble: Decimal)
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        //ToCheck
        /*
        TESTFIELD("Quantity per");
        
        AbleToAssemble := 0;
        CalcAvailQuantities(
          Item,
          GrossRequirement,
          ScheduledReceipt,
          ExpectedInventory,
          AvailableInventory,
          EarliestDate);
        
        IF ExpectedInventory < "Remaining Quantity (Base)" THEN BEGIN
          IF ExpectedInventory < 0 THEN
            AbleToAssemble := 0
          ELSE
            AbleToAssemble := ROUND(ExpectedInventory / "Quantity per",UOMMgt.QtyRndPrecision,'<')
        END ELSE BEGIN
          AbleToAssemble := AssemblyHeader."Remaining Quantity";
          EarliestDate := 0D;
        END;
        */

    end;

    procedure MaxValue(Value: Decimal; Value2: Decimal): Decimal
    begin

        if Value < Value2 then
            exit(Value2);

        exit(Value);
    end;

    procedure MinValue(Value: Decimal; Value2: Decimal): Decimal
    begin

        if Value < Value2 then
            exit(Value);

        exit(Value2);
    end;

    local procedure RoundQty(var Qty: Decimal)
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin

        Qty := UOMMgt.RoundQty(Qty);
    end;

    [Scope('Internal')]
    procedure ResourceUsageTypeFromBOM(BOMComponent: Record "BOM Component"): Integer
    begin

        /*
        IF BOMComponent.Type = BOMComponent.Type::Resource THEN
          CASE BOMComponent."Resource Usage Type" OF
            BOMComponent."Resource Usage Type"::Direct:
              EXIT("Resource Usage Type"::Direct);
            BOMComponent."Resource Usage Type"::Fixed:
              EXIT("Resource Usage Type"::Fixed);
          END;
        
        EXIT("Resource Usage Type"::" ");
        */

    end;

    procedure InitResourceUsageType()
    begin

        case Type of
            Type::" ", Type::Item:
                "Resource Usage Type" := "Resource Usage Type"::" ";
            Type::Resource:
                "Resource Usage Type" := "Resource Usage Type"::Direct;
        end;
    end;

    [Scope('Internal')]
    procedure SignedXX(Value: Decimal): Decimal
    begin

        /*
        CASE "Work Order No." OF
          "Work Order No."::"0",
          "Work Order No."::"1",
          "Work Order No."::"4":
            EXIT(-Value);
        END;
        */

    end;

    procedure CheckBin()
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
                 "No.", "Variant Code", "Unit of Measure Code")
            then
                BinContent.CheckWhseClass(false)
            else begin
                Bin.Get("Location Code", "Bin Code");
                Bin.CheckWhseClass("No.", false);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetDefaultBin()
    begin

        TestField(Type, Type::Item);
        if (Quantity * xRec.Quantity > 0) and
           ("No." = xRec."No.") and
           ("Location Code" = xRec."Location Code") and
           ("Variant Code" = xRec."Variant Code")
        then
            exit;

        Validate("Bin Code", FindBin);
    end;

    [Scope('Internal')]
    procedure FindBin() NewBinCode: Code[20]
    var
        Location: Record Location;
        WMSManagement: Codeunit "WMS Management";
    begin

        if ("Location Code" <> '') and ("No." <> '') then begin
            GetLocation(Location, "Location Code");
            NewBinCode := Location."From-Assembly Bin Code";
            if NewBinCode <> '' then
                exit;

            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", NewBinCode);
        end;
    end;

    procedure TestStatusOpen()
    begin
        /*
        IF StatusCheckSuspended THEN
          EXIT;
        GetHeader;
        IF Type IN [Type::Item,Type::Resource] THEN
          AssemblyHeader.TESTFIELD(Status,AssemblyHeader.Status::Open);
        */

        if StatusCheckSuspended then
            exit;

        //CALCFIELDS(Status); //SOC-SC 08-28-15 commenting (as field is changed from Flowfield to Normal)
        TestField(Status, Status::Open);

    end;

    [Scope('Internal')]
    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin

        if Type <> Type::Item then
            exit(false);

        if not Item2.Get(ItemNo) then
            exit(false);
        exit(true);
    end;

    [Scope('Internal')]
    procedure UpdateConsumedQty()
    var
        recPostedAssemblyLine: Record "Posted Assembly Line";
        dConsumedQty: Decimal;
    begin

        //SOC-MA

        dConsumedQty := 0;
        recPostedAssemblyLine.Reset;
        recPostedAssemblyLine.SetRange("Work Order No.", "Work Order No.");
        //recPostedAssemblyLine.SETRANGE(Type, Type);
        //recPostedAssemblyLine.SETRANGE("No.", "No.");
        recPostedAssemblyLine.SetRange("Consumed Item Line No.", "Line No.");
        if recPostedAssemblyLine.FindSet() then begin
            recPostedAssemblyLine.CalcSums(Quantity);
            dConsumedQty := recPostedAssemblyLine.Quantity;
        end;

        if "Consumed Quantity" <> dConsumedQty then
            Validate("Consumed Quantity", dConsumedQty);

        //SOC-SC 09-28-15
        if "Consumed Quantity (Base)" <> "Consumed Quantity" then begin
            "Consumed Quantity (Base)" := "Consumed Quantity";
        end;
        //SOC-SC 09-28-15 //to check
    end;

    [Scope('Internal')]
    procedure CheckLotAvailability()
    var
        recILE: Record "Item Ledger Entry";
        dAvailableQty: Decimal;
        recBinContent: Record "Bin Content";
        recConsumedItem: Record "Consumed Item";
        dDemandQty: Decimal;
        cduWOMgt: Codeunit "Work Order Management";
    begin

        cduWOMgt.CheckLotAvailability(Rec);
    end;

    procedure UpdateHeaderFields()
    var
        recWO: Record "Work Order";
    begin
        if recWO.Get("Work Order No.") then begin
            Template := recWO.Template;
            Status := recWO.Status;
        end;
    end;
}

