page 50102 "Work Order Subform - Consumed"
{
    AutoSplitKey = true;
    Caption = 'Consumed Items';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Consumed Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Avail. Warning"; "Avail. Warning")
                {
                    BlankZero = true;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin

                        ShowAvailabilityWarning;
                    end;
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                    Style = Strong;
                    StyleExpr = "Tracking Enabled";

                    trigger OnValidate()
                    var
                        Item: Record Item;
                        Resource: Record Resource;
                    begin
                        CalcFields("Tracking Enabled");
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
                                        If Item.Get("No.") then;
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
                                        IF Resource.Get("No.") Then;
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

                        // CurrPage.UPDATE(FALSE);
                    end;
                }
                field(Description; Description)
                {
                }
                field("Consume for Screen"; "Consume for Screen")
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Quantity per"; "Quantity per")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Quantity to Consume"; "Quantity to Consume")
                {
                }
                field("Consumed Quantity"; "Consumed Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                    Visible = false;
                }
                field("Resource Usage Type"; "Resource Usage Type")
                {
                    Visible = false;
                }
                field("Lot No."; "Lot No.")
                {

                    trigger OnAssistEdit()
                    var
                        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
                        TrackingSpecification: Record "Tracking Specification" temporary;
                        SearchForSupply: Boolean;
                        CurrentSignFactor: Integer;
                        LookupMode: Option "Serial No.","Lot No.";
                        MaxQuantity: Decimal;
                    begin
                        if Type <> Type::Item then
                            exit;

                        MaxQuantity := "Quantity to Consume (Base)";

                        //"Bin Code" := ForBinCode;
                        TrackingSpecification.Init;
                        TrackingSpecification."Item No." := "No.";
                        TrackingSpecification."Location Code" := "Location Code";
                        TrackingSpecification."Quantity (Base)" := "Quantity to Consume (Base)";
                        TrackingSpecification."Qty. to Handle (Base)" := "Quantity to Consume (Base)";
                        TrackingSpecification."Qty. to Handle" := "Quantity to Consume (Base)";
                        //TrackingSpecification."New Lot No."
                        TrackingSpecification."Lot No." := "Lot No.";
                        TrackingSpecification."Bin Code" := "Bin Code";
                        TrackingSpecification.Insert;

                        ItemTrackingDataCollection.AssistEditTrackingNo(TrackingSpecification, true, 1, 1, MaxQuantity);
                        //"Bin Code" := '';
                        if TrackingSpecification."Lot No." <> '' then
                            "Lot No." := TrackingSpecification."Lot No.";

                        CheckLotAvailability();

                        CurrPage.Update;
                    end;
                }
                field("Tracking Enabled"; "Tracking Enabled")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin

                            //ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin

                            //ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin

                            //ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin

                            //ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin

                            //ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin

                        //ShowReservationEntries(TRUE);
                    end;
                }
                action("Item Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin

                        //OpenItemTrackingLines;
                    end;
                }
                action("Show Warning")
                {
                    Caption = 'Show Warning';
                    Image = ShowWarning;

                    trigger OnAction()
                    begin

                        //ShowAvailabilityWarning;
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin

                        //ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                }
                action(AssemblyBOM)
                {
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;

                    trigger OnAction()
                    begin

                        //ShowAssemblyList;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SelectItemSubstitution)
                {
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin

                        ShowItemSub;
                        CurrPage.Update;
                    end;
                }
                action(ExplodeBOM)
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin

                        /*
                        ExplodeAssemblyList;
                        CurrPage.UPDATE;
                        */

                    end;
                }
                action("&Reserve")
                {
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction()
                    begin

                        //ShowReservation;
                    end;
                }
                action("Order &Tracking")
                {
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin

                        //ShowTracking;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
    begin
        //ToCheck
        /*
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT AssemblyLineReserve.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          AssemblyLineReserve.DeleteLine(Rec);
        END;
        */

    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

