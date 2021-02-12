page 50075 "Rupp - Item List Omit Non-Sale"
{
    // //POPN6.2  Add menu items to Item Button
    //         Add global variables
    // 
    // //PM1.0
    //   Added button <Product Availability>
    //   Added columns "Product Code" and "Product Qty."
    // //SOC-SC 08-09-14
    //   Added <Quality Premium List>
    //   Added column "Quality Premium Code"
    //   Added 'Compliance Groups'
    //   Added 'Inventory' column
    //   Added "Sale Item" and "Purchase Item"
    // //SOC-SC 08-23-14
    //   Added 'Create New Items'
    //   Added 'Attributes'
    //   "Generic Name"
    // //SOC-MA
    // 
    // //SOC-SC 09-25-14
    //   Added report 'Items to Produce'
    // 
    // //SOC-SC 05-26-15
    //   Added Actions -> Cancel-Substitute

    Caption = 'Item List';
    CardPageID = "BC O365 Item Card";
    Editable = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("Product Code"; "Product Code")
                {
                }
                field("Product Qty. in Lowest UOM"; "Product Qty. in Lowest UOM")
                {
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        recILE: Record "Item Ledger Entry";
                    begin

                        cduProdMgt.ItemProductQtyOnDrillDown(Rec);  //SOC-MA 09-09-14

                        /*
                        //SOC-MA
                        recILE.RESET;
                        recILE.SETFILTER("Product Code", '<>%1&%2', '', "Product Code");
                        IF "Global Dimension 1 Filter" <> '' THEN
                          recILE.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Filter");
                        IF "Global Dimension 2 Filter" <> '' THEN
                          recILE.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Filter");
                        IF "Location Filter" <> '' THEN
                          recILE.SETRANGE("Location Code", "Location Filter");
                        IF "Drop Shipment Filter" <> FALSE THEN
                          recILE.SETRANGE("Drop Shipment", "Drop Shipment Filter");
                        IF "Variant Filter" <> '' THEN
                          recILE.SETRANGE("Variant Code", "Variant Filter");
                        IF "Lot No. Filter" <> '' THEN
                          recILE.SETRANGE("Lot No.", "Lot No. Filter");
                        IF "Serial No. Filter" <> '' THEN
                          recILE.SETRANGE("Serial No.", "Serial No. Filter");
                        PAGE.RUN(0, recILE);
                        //SOC-MA
                        */

                    end;
                }
                field("Product Qty. in Common UOM"; "Product Qty. in Common UOM")
                {

                    trigger OnDrillDown()
                    begin

                        cduProdMgt.ItemProductQtyOnDrillDown(Rec);  //SOC-MA 09-09-14
                    end;
                }
                field("Product Qty. in Base UOM"; "Product Qty. in Base UOM")
                {
                }
                field("Qty. Available to Pick"; "Qty. Available to Pick")
                {
                }
                field("Qty. can be Produced"; "Qty. can be Produced")
                {
                }
                field("Created From Nonstock Item"; "Created From Nonstock Item")
                {
                    Visible = false;
                }
                field("Substitutes Exist"; "Substitutes Exist")
                {
                }
                field("Stockkeeping Unit Exists"; "Stockkeeping Unit Exists")
                {
                    Visible = false;
                }
                field("Assembly BOM"; "Assembly BOM")
                {
                    Visible = false;
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                    Visible = false;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                }
                field("Routing No."; "Routing No.")
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("Shelf No."; "Shelf No.")
                {
                    Visible = false;
                }
                field("Costing Method"; "Costing Method")
                {
                    Visible = false;
                }
                field("Cost is Adjusted"; "Cost is Adjusted")
                {
                    Visible = false;
                }
                field("Standard Cost"; "Standard Cost")
                {
                    Visible = false;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    Visible = false;
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                    Visible = false;
                }
                field("Price/Profit Calculation"; "Price/Profit Calculation")
                {
                    Visible = false;
                }
                field("Profit %"; "Profit %")
                {
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    Visible = false;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                    Visible = false;
                }
                field("Tariff No."; "Tariff No.")
                {
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Overhead Rate"; "Overhead Rate")
                {
                    Visible = false;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Visible = false;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Visible = false;
                }
                field("Product Group Code"; "Rupp Product Group Code")
                {
                    Visible = false;
                    Caption = 'Product Group Code';
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                    Visible = false;
                }
                field("Replenishment System"; "Replenishment System")
                {
                    Visible = false;
                }
                field("Purch. Unit of Measure"; "Purch. Unit of Measure")
                {
                    Visible = false;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Manufacturing Policy"; "Manufacturing Policy")
                {
                    Visible = false;
                }
                field("Flushing Method"; "Flushing Method")
                {
                    Visible = false;
                }
                field("Assembly Policy"; "Assembly Policy")
                {
                    Visible = false;
                }
                field("Item Tracking Code"; "Item Tracking Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Inventory Status Code"; "Inventory Status Code")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control26; "Social Listening FactBox")
            {
                SubPageLink = "Source Type" = CONST (Item),
                              "Source No." = FIELD ("No.");
                Visible = SocialListeningVisible;
            }
            part(Control3; "Social Listening Setup FactBox")
            {
                SubPageLink = "Source Type" = CONST (Item),
                              "Source No." = FIELD ("No.");
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                SubPageLink = "No." = FIELD ("No."),
                              "Date Filter" = FIELD ("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD ("Location Filter"),
                              "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                              "Bin Filter" = FIELD ("Bin Filter"),
                              "Variant Filter" = FIELD ("Variant Filter"),
                              "Lot No. Filter" = FIELD ("Lot No. Filter"),
                              "Serial No. Filter" = FIELD ("Serial No. Filter");
                Visible = true;
            }
            part(Control1903326807; "Item Replenishment FactBox")
            {
                SubPageLink = "No." = FIELD ("No."),
                              "Date Filter" = FIELD ("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD ("Location Filter"),
                              "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                              "Bin Filter" = FIELD ("Bin Filter"),
                              "Variant Filter" = FIELD ("Variant Filter"),
                              "Lot No. Filter" = FIELD ("Lot No. Filter"),
                              "Serial No. Filter" = FIELD ("Serial No. Filter");
                Visible = false;
            }
            part(Control1906840407; "Item Planning FactBox")
            {
                SubPageLink = "No." = FIELD ("No."),
                              "Date Filter" = FIELD ("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD ("Location Filter"),
                              "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                              "Bin Filter" = FIELD ("Bin Filter"),
                              "Variant Filter" = FIELD ("Variant Filter"),
                              "Lot No. Filter" = FIELD ("Lot No. Filter"),
                              "Serial No. Filter" = FIELD ("Serial No. Filter");
                Visible = true;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = FIELD ("No."),
                              "Date Filter" = FIELD ("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD ("Location Filter"),
                              "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                              "Bin Filter" = FIELD ("Bin Filter"),
                              "Variant Filter" = FIELD ("Variant Filter"),
                              "Lot No. Filter" = FIELD ("Lot No. Filter"),
                              "Serial No. Filter" = FIELD ("Serial No. Filter");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Availability)
            {
                Caption = 'Availability';
                Image = Item;
                action("Product Availability")
                {

                    trigger OnAction()
                    var
                        recItem: Record Item;
                    begin
                        //PM1.0
                        if "Product Code" = '' then begin
                            Message('Item %1 does not have a Product Code', "No.");
                        end else begin
                            recItem.Reset();
                            recItem.SetRange("Product Code", "Product Code");
                            recItem.FindSet();
                            PAGE.RunModal(50003, recItem);
                        end;
                    end;
                }
                action("Items b&y Location")
                {
                    AccessByPermission = TableData Location = R;
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        ItemsByLocation.SetRecord(Rec);
                        ItemsByLocation.Run;
                    end;
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("<Action5>")
                    {
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action("BOM Level")
                    {
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                    action(Timeline)
                    {
                        Caption = 'Timeline';
                        Image = Timeline;

                        trigger OnAction()
                        begin
                            ShowTimelineFromItem(Rec);
                        end;
                    }
                }
            }
            group("Master Data")
            {
                Caption = 'Master Data';
                Image = DataEntry;
                action("&Units of Measure")
                {
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("Va&riants")
                {
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                group(Attributes)
                {
                    action(Varieties)
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE ("Attribute Type" = CONST (Variety));
                    }
                    action(Treatments)
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE ("Attribute Type" = CONST (Treatment));
                    }
                    action("Item Group")
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE ("Attribute Type" = CONST ("Item Group"));
                    }
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST (27),
                                      "No." = FIELD ("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            Item: Record Item;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Item);
                            DefaultDimMultiple.SetMultiItem(Item);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("Substituti&ons")
                {
                    Caption = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page "Item Cross Reference Entries";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("E&xtended Text")
                {
                    Caption = 'E&xtended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = FIELD ("No."),
                                  "Variant Code" = CONST ('');
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Item Picture";
                    RunPageLink = "No." = FIELD ("No."),
                                  "Date Filter" = FIELD ("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                  "Location Filter" = FIELD ("Location Filter"),
                                  "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                  "Variant Filter" = FIELD ("Variant Filter");
                }
                action(Identifiers)
                {
                    Caption = 'Identifiers';
                    Image = BarCode;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.", "Variant Code", "Unit of Measure Code");
                }
                action("Barcode Conversion")
                {
                    Caption = 'Barcode Conversion';
                    RunObject = Page "Barcode Conversions";
                    RunPageLink = Type = CONST (Item),
                                  "Item No." = FIELD ("No.");
                }
                action("Customer Package UOM")
                {
                    Caption = 'Customer Package UOM';
                    RunObject = Page "Customer Package Unit of Meas.";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                separator(Action1000000002)
                {
                }
                action("<Action1100768002>")
                {
                    Caption = 'Pop-Up Note Entry';
                    Image = Note;

                    trigger OnAction()
                    begin
                        if greNote.FindLast then
                            EntryNo := greNote."Entry No." + 1
                        else
                            EntryNo := 1;

                        NotesT.Init;
                        NotesT."Entry No." := EntryNo;
                        NotesT."User ID Insert" := UserId;
                        NotesT.Insert;
                        NotesT.Type := NotesT.Type::Item;
                        NotesT."Vend/Cust No." := '';
                        NotesT."No." := "No.";
                        NotesT."Creation Date" := Today;
                        NotesT.Validate("Effective Date", Today);
                        NotesT."Sales Documents" := true;
                        NotesT."Purchase Documents" := true;
                        NotesT."Service Documents" := true;
                        NotesT.Modify;
                        Commit;
                        if PAGE.RunModal(PAGE::"Note Card", NotesT) = ACTION::LookupCancel then
                            NotesT.Delete;
                    end;
                }
                action("<Action1100768003>")
                {
                    Caption = 'Pop-&Up Notes';
                    Image = Note;
                    RunObject = Page "Note Display";
                    RunPageLink = "No." = FIELD ("No.");
                    RunPageView = SORTING (Type, "Vend/Cust No.", "No.", Effective, Expired, "Sales Documents", "Purchase Documents")
                                  WHERE (Type = FILTER (Customer | Vendor | Item),
                                        Effective = CONST (true),
                                        Expired = CONST (false));
                }
            }
            group("Assembly/Production")
            {
                Caption = 'Assembly/Production';
                Image = Production;
                action("Items to Produce")
                {
                    Image = PlanningWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Items to Produce";
                }
                action(Structure)
                {
                    Caption = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction()
                    var
                        BOMStructure: Page "BOM Structure";
                    begin
                        BOMStructure.InitItem(Rec);
                        BOMStructure.Run;
                    end;
                }
                action("Cost Shares")
                {
                    Caption = 'Cost Shares';
                    Image = CostBudget;

                    trigger OnAction()
                    var
                        BOMCostShares: Page "BOM Cost Shares";
                    begin
                        BOMCostShares.InitItem(Rec);
                        BOMCostShares.Run;
                    end;
                }
                group("Assemb&ly")
                {
                    Caption = 'Assemb&ly';
                    Image = AssemblyBOM;
                    action("<Action32>")
                    {
                        Caption = 'Assembly BOM';
                        Image = BOM;
                        RunObject = Page "Assembly BOM";
                        RunPageLink = "Parent Item No." = FIELD ("No.");
                    }
                    action("Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = Track;
                        RunObject = Page "Where-Used List";
                        RunPageLink = Type = CONST (Item),
                                      "No." = FIELD ("No.");
                        RunPageView = SORTING (Type, "No.");
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.", true);
                        end;
                    }
                    action("Calc. Unit Price")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Calc. Unit Price';
                        Image = SuggestItemPrice;

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcAssemblyItemPrice("No.");
                        end;
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    Image = Production;
                    action("Production BOM")
                    {
                        Caption = 'Production BOM';
                        Image = BOM;
                        RunObject = Page "Production BOM";
                        RunPageLink = "No." = FIELD ("No.");
                    }
                    action(Action29)
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Where-Used';
                        Image = "Where-Used";

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate);
                            ProdBOMWhereUsed.RunModal;
                        end;
                    }
                    action(Action24)
                    {
                        AccessByPermission = TableData "Production BOM Header" = R;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.", false);
                        end;
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("&Reservation Entries")
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = CONST (Reservation),
                                      "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.", "Variant Code", "Location Code", "Reservation Status");
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                    }
                    action("&Value Entries")
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                    }
                    action("&Warehouse Entries")
                    {
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action16)
                    {
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal;
                        end;
                    }
                    action("Entry Statistics")
                    {
                        Caption = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Date Filter" = FIELD ("Date Filter"),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action("T&urnover")
                    {
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST (Item),
                                  "No." = FIELD ("No.");
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type = CONST (Item),
                                  Code = FIELD ("No.");
                    RunPageView = SORTING (Type, Code);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Returns Orders")
                {
                    Caption = 'Returns Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Compliance Groups")
                {
                    RunObject = Page "Compliance Group Items";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                group("E-Ship")
                {
                    Caption = 'E-Ship';
                    action("International Shipping")
                    {
                        Caption = 'International Shipping';
                        RunObject = Page "Item Int. Shipping Card";
                        RunPageLink = "No." = FIELD ("No.");
                    }
                    action("E-Ship Agent Options")
                    {
                        Caption = 'E-Ship Agent Options';

                        trigger OnAction()
                        var
                            Shipping: Codeunit Shipping;
                        begin
                            Shipping.ShowOptPageItemResource(DATABASE::Item, "No.");
                        end;
                    }
                    action("Required Shipping Agents")
                    {
                        Caption = 'Required Shipping Agents';
                        RunObject = Page "Required Shipping Agents";
                        RunPageLink = Type = CONST (Item),
                                      Code = FIELD ("No.");
                    }
                    action("E-Ship Hazardous Material Card")
                    {
                        Caption = 'E-Ship Hazardous Material Card';
                        RunObject = Page "SE Hazardous Material";
                        RunPageLink = Type = CONST (Item),
                                      "No." = FIELD ("No.");
                        RunPageView = SORTING (Type, "No.")
                                      ORDER(Ascending);
                    }
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                Image = Purchasing;
                action("Ven&dors")
                {
                    Caption = 'Ven&dors';
                    Image = Vendor;
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Action39)
                {
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Action42)
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Action125)
                {
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action(Action40)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                }
                separator(Action1000000003)
                {
                }
                action("Quality Premium List")
                {
                    Caption = 'Quality Premium List';
                    RunObject = Page "Quality Premium List";
                    RunPageLink = Code = FIELD ("Quality Premium Code");
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("&Bin Contents")
                {
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Item Bin Contents";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action("Stockkeepin&g Units")
                {
                    Caption = 'Stockkeepin&g Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Ser&vice Items")
                {
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Troubleshooting)
                {
                    AccessByPermission = TableData "Service Header" = R;
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;

                    trigger OnAction()
                    var
                        TroubleshootingHeader: Record "Troubleshooting Header";
                    begin
                        TroubleshootingHeader.ShowForItem(Rec);
                    end;
                }
                action("Troubleshooting Setup")
                {
                    Caption = 'Troubleshooting Setup';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Image = Resource;
                group("R&esource")
                {
                    Caption = 'R&esource';
                    Image = Resource;
                    action("Resource &Skills")
                    {
                        Caption = 'Resource &Skills';
                        Image = ResourceSkills;
                        RunObject = Page "Resource Skills";
                        RunPageLink = Type = CONST (Item),
                                      "No." = FIELD ("No.");
                    }
                    action("Skilled R&esources")
                    {
                        AccessByPermission = TableData "Service Header" = R;
                        Caption = 'Skilled R&esources';
                        Image = ResourceSkills;

                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            Clear(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item, "No.", Description);
                            SkilledResourceList.RunModal;
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Create Stockkeeping Unit")
                {
                    AccessByPermission = TableData "Stockkeeping Unit" = R;
                    Caption = '&Create Stockkeeping Unit';
                    Image = CreateSKU;

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", "No.");
                        REPORT.RunModal(REPORT::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action("C&alculate Counting Period")
                {
                    AccessByPermission = TableData "Phys. Invt. Item Selection" = R;
                    Caption = 'C&alculate Counting Period';
                    Image = CalculateCalendar;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        CurrPage.SetSelectionFilter(Item);
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
                    end;
                }
            }
            action("Create New Items")
            {
                Image = NewItem;

                trigger OnAction()
                var
                    PMMgt: Codeunit "Product Management";
                begin
                    PMMgt.OpenItemCreationWksh(''); //SOC-SC 08-23-14
                end;
            }
            action("Sales Prices")
            {
                Caption = 'Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Prices";
                RunPageLink = "Item No." = FIELD ("No.");
                RunPageView = SORTING ("Item No.");
            }
            action("Sales Line Discounts")
            {
                Caption = 'Sales Line Discounts';
                Image = SalesLineDisc;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Line Discounts";
                RunPageLink = Type = CONST (Item),
                              Code = FIELD ("No.");
                RunPageView = SORTING (Type, Code);
            }
            action("Requisition Worksheet")
            {
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Req. Worksheet";
            }
            action("Item Journal")
            {
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
            }
            action("Item Reclassification Journal")
            {
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
            }
            action("Item Tracing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Tracing";
            }
            action("Adjust Item Cost/Price")
            {
                Caption = 'Adjust Item Cost/Price';
                Image = AdjustItemCost;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report "Adjust Item Costs/Prices";
            }
            action("Adjust Cost - Item Entries")
            {
                Caption = 'Adjust Cost - Item Entries';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Adjust Cost - Item Entries";
            }
            action("Cancel-Substitute")
            {

                trigger OnAction()
                var
                    CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                begin
                    //CancelSubMgt.InventoryStatusValidateFromItem(Rec);
                    //SOC-SC 05-26-15
                    PAGE.Run(50061, Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Inventory - List")
            {
                Caption = 'Inventory - List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item List";
            }
            action("Item/Vendor Catalog")
            {
                Caption = 'Item/Vendor Catalog';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
            }
            action("Phys. Inventory List")
            {
                Caption = 'Phys. Inventory List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Phys. Inventory List";
            }
            action("Price List")
            {
                Caption = 'Price List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "List Price Sheet";
            }
            action("Inventory Cost and Price List")
            {
                Caption = 'Inventory Cost and Price List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item Cost and Price List";
            }
            action("Inventory - Top 10 List")
            {
                Caption = 'Inventory - Top 10 List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Top __ Inventory Items";
            }
            action("Where-Used (Top Level)")
            {
                Caption = 'Where-Used (Top Level)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Where-Used (Top Level)";
            }
            action("Quantity Explosion of BOM")
            {
                Caption = 'Quantity Explosion of BOM';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Quantity Explosion of BOM";
            }
            action("Compare List")
            {
                Caption = 'Compare List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Compare List";
            }
            action("Item Register - Quantity")
            {
                Caption = 'Item Register - Quantity';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Register";
            }
            action("Inventory - Transaction Detail")
            {
                Caption = 'Inventory - Transaction Detail';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Transaction Detail";
            }
            action("Back Order Fill by Item")
            {
                Caption = 'Back Order Fill by Item';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Back Order Fill by Item";
            }
            action("Issue History")
            {
                Caption = 'Issue History';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Issue History";
            }
            action("Picking List by Item")
            {
                Caption = 'Picking List by Item';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Picking List by Item";
            }
            action("Purchase Advice")
            {
                Caption = 'Purchase Advice';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Purchase Advice";
            }
            action("Sales Order Status")
            {
                Caption = 'Sales Order Status';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Sales Order Status";
            }
            action("Inventory Purchase Orders")
            {
                Caption = 'Inventory Purchase Orders';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Purchase Order Status";
            }
            action("Inventory - Sales Statistics")
            {
                Caption = 'Inventory - Sales Statistics';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Sales Statistics";
            }
            action("Assemble to Order - Sales")
            {
                Caption = 'Assemble to Order - Sales';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Assemble to Order - Sales";
            }
            action("Inventory - Customer Sales")
            {
                Caption = 'Inventory - Customer Sales';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Sales by Customer";
            }
            action("Inventory - Vendor Purchases")
            {
                Caption = 'Inventory - Vendor Purchases';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Vendor/Item Statistics";
            }
            action("Inventory - Reorders")
            {
                Caption = 'Inventory - Reorders';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Reorders";
            }
            action("Inventory - Sales Back Orders")
            {
                Caption = 'Inventory - Sales Back Orders';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Sales Back Orders";
            }
            action("Nonstock Item Sales")
            {
                Caption = 'Nonstock Item Sales';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Catalog Item Sales";
            }
            action("Inventory - Cost Variance")
            {
                Caption = 'Inventory - Cost Variance';
                Image = ItemCosts;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Cost Variance";
            }
            action("Inventory Valuation")
            {
                Caption = 'Inventory Valuation';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Valuation";
            }
            action("Invt. Valuation - Cost Spec.")
            {
                Caption = 'Invt. Valuation - Cost Spec.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Invt. Valuation - Cost Spec.";
            }
            action("Inventory Valuation - WIP")
            {
                Caption = 'Inventory Valuation - WIP';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Valuation - WIP";
            }
            action("Item Register - Value")
            {
                Caption = 'Item Register - Value';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Register - Value";
            }
            action("Item Charges - Specification")
            {
                Caption = 'Item Charges - Specification';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Charges - Specification";
            }
            action("Item Age Composition - Qty.")
            {
                Caption = 'Item Age Composition - Qty.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Age Composition - Qty.";
            }
            action("Item Age Composition - Value")
            {
                Caption = 'Item Age Composition - Value';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Age Composition - Value";
            }
            action("Item Expiration - Quantity")
            {
                Caption = 'Item Expiration - Quantity';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Expiration - Quantity";
            }
            action("Cost Shares Breakdown")
            {
                Caption = 'Cost Shares Breakdown';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Shares Breakdown";
            }
            action("Detailed Calculation")
            {
                Caption = 'Detailed Calculation';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Detailed Calculation";
            }
            action("Rolled-up Cost Shares")
            {
                Caption = 'Rolled-up Cost Shares';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Rolled-up Cost Shares";
            }
            action("Single-Level Cost Shares")
            {
                Caption = 'Single-Level Cost Shares';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Single-level Cost Shares";
            }
            action("Inventory to G/L Reconcile")
            {
                Caption = 'Inventory to G/L Reconcile';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory to G/L Reconcile";
            }
            action("Inventory Availability")
            {
                Caption = 'Inventory Availability';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Availability Status";
            }
            action("Availability Projection")
            {
                Caption = 'Availability Projection';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Availability Projection";
            }
            action(Action1908000106)
            {
                Caption = 'Item Charges - Specification';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Charges - Specification";
            }
            action("Item Turnover")
            {
                Caption = 'Item Turnover';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Turnover";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetSocialListeningFactboxVisibility
    end;

    trigger OnAfterGetRecord()
    begin
        SetSocialListeningFactboxVisibility;
        UpdateCalculatedQuantities;   //SOC-MA 09-09-14
    end;

    trigger OnOpenPage()
    begin
        SetRange("Sales Blocked", false);
    end;

    var
        SkilledResourceList: Page "Skilled Resource List";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        cduProdMgt: Codeunit "Product Management";
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        "--POPN--": Integer;
        greNote: Record Note;
        EntryNo: Integer;
        NotesT: Record Note;

    [Scope('Internal')]
    procedure GetSelectionFilter(): Text
    var
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Item);
        exit(SelectionFilterManagement.GetSelectionFilterForItem(Item));
    end;

    [Scope('Internal')]
    procedure SetSelection(var Item: Record Item)
    begin
        CurrPage.SetSelectionFilter(Item);
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        SocialListeningMgt.GetItemFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;
}

