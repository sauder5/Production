table 50045 "Production Lot"
{
    // version GroProd


    fields
    {
        field(10; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Vendor Number"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate();
            var
                recVendor: Record Vendor;
                recProdGrowers: Record "Production Grower";
            begin
                CLEAR(recVendor);
                if recVendor.GET("Vendor Number") then
                    VALIDATE("Vendor Name", recVendor.Name);

                recProdGrowers.RESET;
                recProdGrowers.SETFILTER("Production Lot No.", "Production Lot No.");
                if not recProdGrowers.FINDSET then begin
                    recProdGrowers."Production Lot No." := "Production Lot No.";
                    recProdGrowers."Vendor No." := "Vendor Number";
                    recProdGrowers."Vendor Name" := "Vendor Name";
                    recProdGrowers."Grower Share" := 100;
                    recProdGrowers.INSERT;
                end;
            end;
        }
        field(30; "Vendor Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Farm No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Farm."Farm No." WHERE(Vendor = FIELD("Vendor Number"));

            trigger OnValidate();
            var
                recFarm: Record Farm;
            begin
                CLEAR(recFarm);
                if recFarm.GET("Farm No.") then
                    VALIDATE("Farm Name", recFarm."Farm Name");
            end;
        }
        field(50; "Farm Name"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(60; "Farm Field No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Farm Field"."Farm Field No." WHERE("Farm No." = FIELD("Farm No."));

            trigger OnValidate();
            var
                recFarmField: Record "Farm Field";
            begin
                CLEAR(recFarmField);
                if recFarmField.GET("Farm Field No.") then begin
                    VALIDATE("Field Name", recFarmField."Farm Field Name");
                    VALIDATE("Farm Field Acreage", recFarmField.Acreage);
                end;
            end;
        }
        field(70; "Field Name"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                recFarmField: Record "Farm Field";
            begin
            end;
        }
        field(75; "Farm Field Acreage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

            trigger OnValidate();
            var
                recItem: Record Item;
                recCommodity: Record "Commodity Settings";
            begin
                CLEAR(recItem);
                if recItem.GET("Item No.") then begin
                    VALIDATE("Check off %", recItem."Checkoff %");
                    VALIDATE("Item Description", recItem.Description);
                    VALIDATE("Generic Name Code", recItem."Generic Name Code");
                    VALIDATE("Purchase UOM", recItem."Purch. Unit of Measure");
                    VALIDATE("Purchase UOM in LBS", recItem."Gross Weight");
                    VALIDATE("Commodity  Code", recItem."Quality Premium Code");
                    if not recCommodity.GET("Commodity  Code") then
                        CLEAR(recCommodity);
                    "Estimated Qty" := "Farm Field Acreage" * recCommodity."Estimated Yield per Acre";
                end;
            end;
        }
        field(90; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(100; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));

            trigger OnValidate();
            var
                recGrowerTkt: Record "Grower Ticket";
            begin
                if "Generic Name Code" <> xRec."Generic Name Code" then begin
                    recGrowerTkt.RESET;
                    recGrowerTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                    recGrowerTkt.MODIFYALL("Generic Name Code", "Generic Name Code");
                end;
            end;
        }
        field(110; "Estimated Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(120; "Purchase UOM"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(125; "Purchase UOM in LBS"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(130; "Prod. Lot Entry Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(140; "First Receipt Date"; Date)
        {
            CalcFormula = Min ("Scale Ticket Header"."Receipt Date" WHERE("Production Lot No." = FIELD("Production Lot No."),
                                                                          Status = FILTER(Posted | Closed)));
            Description = 'FF';
            FieldClass = FlowField;
        }
        field(150; "Last Receipt Date"; Date)
        {
            CalcFormula = Max ("Scale Ticket Header"."Receipt Date" WHERE("Production Lot No." = FIELD("Production Lot No."),
                                                                          Status = FILTER(Posted | Closed)));
            Description = 'FF';
            FieldClass = FlowField;
        }
        field(160; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Closed,Canceled';
            OptionMembers = Open,Closed,Canceled;

            trigger OnValidate();
            begin
                if Status = Status::Closed then
                    VALIDATE("Closed Date", TODAY)
                else
                    CLEAR("Closed Date");
            end;
        }
        field(170; "Closed Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(180; "Commodity  Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Commodity Settings".Code;

            trigger OnValidate();
            var
                recPremium: Record "Commodity Settings";
            begin
                CLEAR(recPremium);
                if recPremium.GET("Commodity  Code") then begin
                    VALIDATE("Commodity Premium per UOM", recPremium."Seed Unit Premium");
                    VALIDATE("Comm. Annual Prem. Per UOM", recPremium."Comm. Annual Prem per UOM");
                end;
            end;
        }
        field(190; "Commodity Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(200; "Cropping Practice Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Cropping Practice".Code;

            trigger OnValidate();
            var
                recIncentive: Record "Cropping Practice";
            begin
                CLEAR(recIncentive);
                if recIncentive.GET("Cropping Practice Code") then
                    VALIDATE("Cropping Premium per UOM", recIncentive."Cropping Premium per UOM");
            end;
        }
        field(210; "Cropping Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(220; "Additional Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(230; "Out of Zone Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(240; "Check off %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(250; "Quantity Received"; Decimal)
        {
            CalcFormula = Sum ("Grower Ticket"."Net Qty in Purchase UOM" WHERE("Production Lot No." = FIELD("Production Lot No."),
                                                                               Status = FILTER(Posted)));
            Description = 'FF';
            FieldClass = FlowField;
        }
        field(260; "Quantity Settled"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(270; "Amount Settled"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(280; "Quantity Pending Settlement"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(290; "Deferred Payment"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(300; "Deferred Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(310; "Acres Planted"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(320; "Seed Lot # Planted"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(330; "Date of Planting"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(340; "Row Spacing"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = '" ,6"" to 13"",14"" or Greater,Broadcast"';
            OptionMembers = ,"6"" to 13""","14"" or Greater",Broadcast;
        }
        field(350; "Previous Crop"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));
        }
        field(360; "If same crop, what Variety"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(370; Class; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = '" ,Certified,Identity Preserved,Info Only,Foundation,Noxious Weed Free,Quality Assurance,Registered,Source Identified"';
            OptionMembers = ,Certified,"Identity Preserved","Info Only",Foundation,"Noxious Weed Free","Quality Assurance",Registered,"Source Identified";
        }
        field(380; "Application #"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(390; "Comm. Annual Prem. Per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(391; "Add. Annual Prem. per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(400; "Production Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Production Lot No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        recScaleTkt: Record "Scale Ticket Header";
    begin
        recScaleTkt.RESET;
        recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
        if recScaleTkt.FINDSET then
            ERROR('Production Lot cannot be deleted. There are %1 scale tickets entered against this record.', recScaleTkt.COUNT);
    end;

    trigger OnInsert();
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        "Production Lot No." := NoSeriesMgt.GetNextNo('R_PRODLOT', TODAY(), true);
        VALIDATE("Prod. Lot Entry Date", TODAY());
    end;
}

