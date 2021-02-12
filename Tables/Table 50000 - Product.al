table 50000 Product
{
    // //RSI-KS 05-26-16
    //   Remove Future POs from Qty on PO Calculation

    DrillDownPageID = Products;
    LookupPageID = Products;

    fields
    {
        field(1; "Code"; Code[17])
        {
            Description = 'PK';
        }
        field(10; Description; Text[50])
        {
        }
        field(11; "Generic Name Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code WHERE ("Attribute Type" = FILTER ("Generic Name"));
        }
        field(12; Maturity; Text[20])
        {
        }
        field(14; "Treatment Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code WHERE ("Attribute Type" = CONST (Treatment));
        }
        field(15; "Item Group Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code WHERE ("Attribute Type" = FILTER ("Item Group"));
        }
        field(16; "Variety Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code WHERE ("Attribute Type" = FILTER (Variety));
        }
        field(17; "Seed Size"; Option)
        {
            OptionMembers = " ",Small,Large;
        }
        field(20; "Item Template Code"; Code[10])
        {
            TableRelation = "Config. Template Header".Code WHERE ("Table ID" = FILTER (27));
        }
        field(25; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(31; "Qty. on Purchase Orders"; Decimal)
        {
            CalcFormula = Sum ("Purchase Line"."Outstanding Qty. in Common UOM" WHERE ("Document Type" = CONST (Order),
                                                                                      Type = CONST (Item),
                                                                                      "Product Code" = FIELD (Code),
                                                                                      "Expected Receipt Date" = FIELD ("Date Filter"),
                                                                                      "Future PO" = FILTER (false)));
            Description = 'FF: Qty. on Purchase Orders in Common UOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Qty. on Sales Orders"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Outstanding Qty. in Common UOM" WHERE ("Document Type" = CONST (Order),
                                                                                   Type = CONST (Item),
                                                                                   "Product Code" = FIELD (Code),
                                                                                   "Shipment Date" = FIELD ("Date Filter")));
            Description = 'FF: Qty. on Sales Orders in Common UOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Qty. Available"; Decimal)
        {
            Description = 'Calculated: QOH - Q on SO - Q on PO';
            Editable = false;
        }
        field(50; "Planting Season"; Option)
        {
            OptionMembers = Spring,Summer,Fall,Winter;
        }
        field(51; "Seasonal Cash Disc Code"; Code[20])
        {
            TableRelation = "Season Code";
        }
        field(60; "Checkoff %"; Decimal)
        {
        }
        field(61; "Quality Premium Code"; Code[20])
        {
            TableRelation = "Commodity Settings";
        }
        field(70; "Lowest UOM Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(71; "Common UOM Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(72; "LowestUOM Qty. per CommonUOM"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(73; "Qty. on Hand in Lowest UOM"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Lowest UOM" WHERE ("Product Code" = FIELD (Code),
                                                                              "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD ("Location Filter"),
                                                                              "Lot No." = FIELD ("Lot No. Filter"),
                                                                              "Serial No." = FIELD ("Serial No. Filter")));
            Description = 'FF: Qty. on Hand in Lowest UOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Qty. on Hand"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Common UOM" WHERE ("Product Code" = FIELD (Code),
                                                                              "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD ("Location Filter"),
                                                                              "Lot No." = FIELD ("Lot No. Filter"),
                                                                              "Serial No." = FIELD ("Serial No. Filter")));
            Description = 'FF: Qty. on Hand in Common UOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(81; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(82; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(83; "Lot No. Filter"; Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(84; "Serial No. Filter"; Code[20])
        {
            Caption = 'Serial No. Filter';
            FieldClass = FlowFilter;
        }
        field(90; "Inventory Status Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE (Type = CONST ("Inventory Status"));

            trigger OnValidate()
            var
                CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
            begin
                CancelSubMgt.InventoryStatusValidateFromProduct(Rec);
                if "Inventory Status Code" <> '' then begin
                    "Inventory Status Modified Date" := WorkDate;
                end else begin
                    "Inventory Status Modified Date" := 0D;
                end;
            end;
        }
        field(91; "Inventory Status Modified Date"; Date)
        {
            Editable = false;
        }
        field(100; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(101; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(102; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                recItemCategory: Record "Item Category";
                recGenProdPostingGrp: Record "Gen. Product Posting Group";
                //                recProductGrp: Record "Product Group";
            begin
                if "Item Category Code" <> xRec."Item Category Code" then begin
                    if recItemCategory.Get("Item Category Code") then begin
                        //IF "Gen. Prod. Posting Group" = '' THEN
                        if recItemCategory."Def. Gen. Prod. Posting Group" <> '' then
                            Validate("Gen. Prod. Posting Group", recItemCategory."Def. Gen. Prod. Posting Group");
                        if ("VAT Prod. Posting Group" = '') or
                           (recGenProdPostingGrp.ValidateVatProdPostingGroup(recGenProdPostingGrp, "Gen. Prod. Posting Group") and
                            ("Gen. Prod. Posting Group" = recItemCategory."Def. Gen. Prod. Posting Group") and
                            ("VAT Prod. Posting Group" = recGenProdPostingGrp."Def. VAT Prod. Posting Group"))
                        then
                            Validate("VAT Prod. Posting Group", recItemCategory."Def. VAT Prod. Posting Group");
                        //IF "Inventory Posting Group" = '' THEN
                        if recItemCategory."Def. Inventory Posting Group" <> '' then
                            Validate("Inventory Posting Group", recItemCategory."Def. Inventory Posting Group");
                        //IF "Tax Group Code" = '' THEN
                        if recItemCategory."Def. Tax Group Code" <> '' then
                            Validate("Tax Group Code", recItemCategory."Def. Tax Group Code");
                        Validate("Costing Method", recItemCategory."Def. Costing Method");
                    end;
                end;
            end;
        }
        field(103; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(104; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(105; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(106; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(107; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(108; "Costing Method"; Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(109; "Rupp Product Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rupp Product Group"."Rupp Product Group Code";
        }
        field(120; "Sale Item"; Boolean)
        {
            Description = 'PM1.0';
        }
        field(121; "Purchase Item"; Boolean)
        {
            Description = 'PM1.0';
        }
        field(130; "Shipping On Hold"; Boolean)
        {
        }
        field(140; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                recVendor: Record Vendor;
            begin
                if recVendor.Get("Vendor No.") then
                    "Vendor Name" := recVendor.Name
                else
                    "Vendor Name" := '';

                Modify();
            end;
        }
        field(141; "Vendor Name"; Text[50])
        {
        }
        field(142; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "Code", Description, "Generic Name Code")
        {
        }
    }

    var
        cduProdMgt: Codeunit "Product Management";

    [Scope('Internal')]
    procedure GetQuantityAvailableInCommonUOM() RetQty: Decimal
    begin
        //SOC-MA

        RetQty := cduProdMgt.GetProductQuantityAvailableInCommonUOM(Rec);
    end;

    [Scope('Internal')]
    procedure UpdateCalculatedQuantities()
    var
        RuppFunc: Codeunit "Rupp Functions";
        dQtyPerLUOM: Decimal;
    begin
        //SOC-MA

        cduProdMgt.UpdateProductCalculatedQuantities(Rec);
    end;
}

