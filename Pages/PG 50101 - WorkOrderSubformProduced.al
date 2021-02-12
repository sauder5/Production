page 50101 "Work Order Subform - Produced"
{
    // RSI-KS 11-05-15
    //   Bold produced items that require a lot

    AutoSplitKey = true;
    Caption = 'Produced Items';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Produced Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    Style = Strong;
                    StyleExpr = "Tracking Enabled";

                    trigger OnValidate()
                    var
                        Item: Record Item;
                        Resource: Record Resource;
                    begin
                        CalcFields("Tracking Enabled");

                        if "Item No." = '' then
                            Init
                        else begin
                            //  "Due Date" := AssemblyHeader."Starting Date";
                            if Item.get("Item No.") then;
                            Item.TestField("Inventory Posting Group");
                            GetDefaultBin;
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            //        ItemExists := GetUnitCost;
                            Validate("Unit of Measure Code", Item."Base Unit of Measure");
                            Validate(Quantity);
                            //        VALIDATE("Quantity to Consume", MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                        end;

                        // CurrPage.UPDATE(FALSE);
                    end;
                }
                field(Description; Description)
                {
                }
                field(Screen; Screen)
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
                field(Quantity; Quantity)
                {
                }
                field("Quantity to Assemble"; "Quantity to Assemble")
                {
                }
                field("Assembled Quantity"; "Assembled Quantity")
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
                    Visible = false;
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                    Visible = false;
                }
                field("Qty. in Lowest UOM"; "Qty. in Lowest UOM")
                {
                    Visible = false;
                }
                field("Qty. to Assemble in Lowest UOM"; "Qty. to Assemble in Lowest UOM")
                {
                    Visible = false;
                }
                field("Assembled Qty. in Lowest UOM"; "Assembled Qty. in Lowest UOM")
                {
                    Visible = false;
                }
                field("Qty. in Common UOM"; "Qty. in Common UOM")
                {
                    Visible = false;
                }
                field("Qty. to Assemble in Common UOM"; "Qty. to Assemble in Common UOM")
                {
                    Visible = false;
                }
                field("Assembled Qty. in Common UOM"; "Assembled Qty. in Common UOM")
                {
                    Visible = false;
                }
                field("Bag Item No."; "Bag Item No.")
                {
                }
                field("Bag Quantity"; "Bag Quantity")
                {
                }
                field("Tracking Enabled"; "Tracking Enabled")
                {
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

                        //ShowItemSub;
                        //CurrPage.UPDATE;
                    end;
                }
                action(ExplodeBOM)
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin

                        //ExplodeAssemblyList;
                        //CurrPage.UPDATE;
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
        ReservationStatusField: Option ,Partial,Full;

    [Scope('Internal')]
    procedure ReserveItem()
    begin
        /*
        IF Type <> Type::Item THEN
          EXIT;
        
        IF ("Remaining Quantity (Base)" <> xRec."Remaining Quantity (Base)") OR
           ("No." <> xRec."No.") OR
           ("Location Code" <> xRec."Location Code") OR
           ("Variant Code" <> xRec."Variant Code") OR
           ("Due Date" <> xRec."Due Date") OR
           ((Reserve <> xRec.Reserve) AND ("Remaining Quantity (Base)" <> 0))
        THEN
          IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
          END;
        
        ReservationStatusField := ReservationStatus;
        */

    end;
}

