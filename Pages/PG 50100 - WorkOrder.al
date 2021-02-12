page 50100 "Work Order"
{
    // //SOC-SC 09-05-14
    // //SOC-SC 08-28-15
    //   Validate Status field instead of assigning

    PageType = Document;
    SourceTable = "Work Order";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin

                        /*
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                        */

                    end;
                }
                field(Description; Description)
                {
                }
                field("Created from Template"; "Created from Template")
                {
                }
                field(Template; Template)
                {
                }
                field("Location Code"; "Location Code")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin

                        //CurrPage.SAVERECORD;
                    end;
                }
                field("Bin Code"; "Bin Code")
                {

                    trigger OnValidate()
                    begin

                        //CurrPage.SAVERECORD;
                    end;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Importance = Promoted;
                }
                field("Due Date"; "Due Date")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin

                        CurrPage.SaveRecord;
                    end;
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
                field("Remaining Qty. in Lowest UOM"; "Remaining Qty. in Lowest UOM")
                {
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
                field("Remaining Qty. in Common UOM"; "Remaining Qty. in Common UOM")
                {
                    Visible = false;
                }
            }
            part(Control1000000003; "Work Order Subform - Consumed")
            {
                SubPageLink = "Work Order No." = FIELD("No.");
            }
            part(Control1000000000; "Work Order Subform - Produced")
            {
                SubPageLink = "Work Order No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part(Control1000000023; "Item Warehouse FactBox")
            {
                Provider = Control1000000003;
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Control8; Links)
            {
            }
            systempart(Control9; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Item Availability by")
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;
                Visible = false;
                action("Event")
                {
                    Caption = 'Event';
                    Image = "Event";
                    Visible = false;

                    trigger OnAction()
                    begin

                        //ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByEvent);
                    end;
                }
                action(Period)
                {
                    Caption = 'Period';
                    Image = Period;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByPeriod);
                    end;
                }
                action(Variant)
                {
                    Caption = 'Variant';
                    Image = ItemVariant;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByVariant);
                    end;
                }
                action(Location)
                {
                    Caption = 'Location';
                    Image = Warehouse;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByLocation);
                    end;
                }
                action("BOM Level")
                {
                    Caption = 'BOM Level';
                    Image = BOMLevel;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByBOM);
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';
                Image = AssemblyBOM;
                action("<Page Rupp Comment Sheet>")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rupp Comment Sheet";
                    RunPageLink = "Table ID" = CONST(50020),
                                  "Document No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action("Assembly Orders")
                {
                    Caption = 'Assembly Orders';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Assembly Orders";
                    RunPageLink = "Work Order No." = FIELD("No.");

                    trigger OnAction()
                    var
                        recAssemblyHeader: Record "Assembly Header";
                    begin
                        /*Assembly Orders*/

                        /*
                        recAssemblyHeader.RESET;
                        recAssemblyHeader.SETRANGE("Document Type", recAssemblyHeader."Document Type"::Order);
                        recAssemblyHeader.SETRANGE(recAssemblyHeader."Work Order No.", "No.");
                        PAGE.RUN(902, recAssemblyHeader);
                        */

                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Entries;
                    action("Item Ledger Entries")
                    {
                        Caption = 'Item Ledger Entries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        RunObject = Page "Capacity Ledger Entries";
                    }
                    action("Resource Ledger Entries")
                    {
                        Caption = 'Resource Ledger Entries';
                        Image = ResourceLedger;
                        RunObject = Page "Resource Ledger Entries";
                    }
                    action("Value Entries")
                    {
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                    }
                    action("Warehouse Entries")
                    {
                        Caption = 'Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                    }
                }
                action("Posted Assembly Orders")
                {
                    Caption = 'Posted Assembly Orders';
                    Image = PostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Assembly Orders";
                    RunPageLink = "Work Order No." = FIELD("No.");
                }
            }
            separator(Action52)
            {
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action49)
                {
                }
                action(Finish)
                {
                    Caption = 'Finish';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin

                        //CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",Rec);
                        //MESSAGE('TBD');
                        SkipStatusCheck(true);
                        if Status <> Status::Finished then
                            //Status := Status::Finished;       //SOC-SC 08-28-15 commenting
                            Validate(Status, Status::Finished); //SOC-SC 08-28-15
                        CurrPage.Update;
                        SkipStatusCheck(false);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseAssemblyDoc: Codeunit "Release Assembly Document";
                    begin

                        //ReleaseAssemblyDoc.Reopen(Rec);
                        SkipStatusCheck(true);
                        if Status <> Status::Open then
                            //Status := Status::Open;       //SOC-SC 08-28-15 commenting
                            Validate(Status, Status::Open); //SOC-SC 08-28-15
                        CurrPage.Update;
                        SkipStatusCheck(false);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Create WO Movements")
                {

                    trigger OnAction()
                    var
                        recConsumedItem: Record "Consumed Item";
                        dQtyOnHand: Decimal;
                        UOMMgt: Codeunit "Unit of Measure Management";
                        recItem: Record Item;
                        iLineNo: Integer;
                        recItemReclass: Record "Item Journal Line";
                        iCnt: Integer;
                    begin
                        //SOC-SC 09-05-14
                        //MESSAGE('Opens Item Reclass. Journal with the components that are not available');
                        recConsumedItem.Reset();
                        recConsumedItem.SetRange("Work Order No.", "No.");
                        recConsumedItem.SetRange(Type, recConsumedItem.Type::Item);
                        if recConsumedItem.FindSet() then begin
                            recItemReclass.Reset();
                            recItemReclass.SetRange("Journal Template Name", 'RECLASS');
                            recItemReclass.SetRange("Journal Batch Name", 'DEFAULT');
                            if recItemReclass.FindLast() then begin
                                iLineNo := recItemReclass."Line No.";
                            end;

                            repeat
                                recItem.Get(recConsumedItem."No.");
                                recItem.SetRange("Location Filter", "Location Code");
                                recItem.CalcFields(Inventory);
                                //dQtyOnHand := UOMMgt.CalcQtyFromBase(recItem.Inventory, "Qty. per Unit of Measure"));
                                dQtyOnHand := recItem.Inventory;
                                if dQtyOnHand < recConsumedItem."Quantity (Base)" then begin
                                    iLineNo += 100;
                                    InsertItemReclass(recConsumedItem."No.", -(dQtyOnHand - recConsumedItem."Quantity (Base)"), recConsumedItem."Location Code", iLineNo);
                                    iCnt += 1;
                                end;
                            until recConsumedItem.Next = 0;
                            if iCnt > 0 then begin
                                if recItemReclass.FindSet() then begin
                                    PAGE.Run(393, recItemReclass);
                                end;
                            end;
                        end;
                    end;
                }
                action(ShowAvailability)
                {
                    Caption = 'Show Availability';
                    Image = ItemAvailbyLoc;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //For future, if needed
                        //ShowAvailability;
                    end;
                }
                action("Update Unit Cost")
                {
                    Caption = 'Update Unit Cost';
                    Image = UpdateUnitCost;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //For future, if needed
                        //UpdateUnitCost;
                    end;
                }
                action("Refresh Lines")
                {
                    Caption = 'Refresh Lines';
                    Image = RefreshLines;

                    trigger OnAction()
                    begin

                        //RefreshBOM;
                        //CurrPage.UPDATE;
                    end;
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Image = CopyDocument;
                    Visible = false;

                    trigger OnAction()
                    var
                        CopyAssemblyDocument: Report "Copy Assembly Document";
                    begin
                        /*Copy Document*/
                        //For future, if needed
                        //CopyAssemblyDocument.SetAssemblyHeader(Rec);
                        //CopyAssemblyDocument.RUNMODAL;

                        Message('TBD');

                    end;
                }
                action("Create Assembly Orders")
                {
                    Caption = 'Create Assembly Orders';
                    Image = AssemblyOrder;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        cduWOMgt: Codeunit "Work Order Management";
                    begin
                        /*Create Assembly Orders*/

                        cduWOMgt.CreateAssemblyOrders(Rec);
                        Commit;
                        Message('Process Complete');

                    end;
                }
                separator(Action53)
                {
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        cduWOMgt: Codeunit "Work Order Management";
                        recAssemblyHeader: Record "Assembly Header";
                        recProducedItem: Record "Produced Item";
                        recConsumedItem: Record "Consumed Item";
                    begin
                        /*Post*/

                        //CODEUNIT.RUN(CODEUNIT::"Assembly-Post (Yes/No)",Rec);
                        //MESSAGE('TBD');

                        cduWOMgt.CreateAssemblyOrders(Rec);
                        Commit;

                        recAssemblyHeader.Reset;
                        recAssemblyHeader.SetRange("Work Order No.", "No.");
                        if recAssemblyHeader.FindSet() then
                            REPORT.RunModal(REPORT::"Batch Post Assembly Orders", false, true, recAssemblyHeader);
                        Commit;

                        recProducedItem.Reset;
                        recProducedItem.SetRange("Work Order No.", "No.");
                        recProducedItem.SetFilter("Item No.", '<>%1', '');  //SOC-MA 08-08-15
                        if recProducedItem.FindSet() then begin
                            repeat
                                recProducedItem.Validate("Quantity to Assemble", 0);
                                recProducedItem.Modify;
                            until recProducedItem.Next = 0;
                        end;

                        recConsumedItem.Reset;
                        recConsumedItem.SetRange("Work Order No.", "No.");
                        recConsumedItem.SetFilter(Type, '<>0');             //SOC-MA 08-08-15
                        recConsumedItem.SetFilter("No.", '<>%1', '');       //SOC-MA 08-08-15
                        if recConsumedItem.FindSet() then begin
                            repeat
                                recConsumedItem.Validate("Quantity to Consume", 0);
                                recConsumedItem.Modify;
                            until recConsumedItem.Next = 0;
                        end;


                        CurrPage.Update(false);

                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*Post Batch*/
                        //For future, if needed
                        //REPORT.RUNMODAL(REPORT::"Batch Post Assembly Orders",TRUE,TRUE,Rec);
                        //CurrPage.UPDATE(FALSE);
                        Message('TBD');

                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("Order")
                {
                    Caption = 'Order';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocPrint: Codeunit "Document-Print";
                        recWO: Record "Work Order";
                    begin
                        /*Print*/

                        //DocPrint.PrintAsmHeader(Rec);
                        //MESSAGE('TBD');

                        recWO.Reset;
                        recWO.SetRange("No.", "No.");
                        recWO.FindSet();
                        REPORT.RunModal(50008, true, false, recWO);

                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
    begin

        /*
        TESTFIELD("Assemble to Order",FALSE);
        IF (Quantity <> 0) AND ItemExists("Item No.") THEN BEGIN
          COMMIT;
          IF NOT AssemblyHeaderReserve.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          AssemblyHeaderReserve.DeleteLine(Rec);
        END;
        */

    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    [Scope('Internal')]
    procedure InsertItemReclass(ItemNo: Code[20]; Qty: Decimal; Loc: Code[10]; LineNo: Integer)
    var
        recItemReclass: Record "Item Journal Line";
        iLineNo: Integer;
        recItemJnlBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cDocNo: Code[20];
    begin
        //SOC-SC 09-05-14

        recItemReclass.Init();
        recItemReclass."Journal Template Name" := 'RECLASS';
        recItemReclass."Journal Batch Name" := 'DEFAULT';
        recItemReclass."Line No." := LineNo;
        recItemReclass.Validate("Posting Date", WorkDate);
        recItemJnlBatch.Get(recItemReclass."Journal Template Name", recItemReclass."Journal Batch Name");
        if recItemJnlBatch."No. Series" <> '' then begin
            cDocNo := NoSeriesMgt.GetNextNo(recItemJnlBatch."No. Series", WorkDate, false);
            recItemReclass.Validate("Document No.", cDocNo);
        end;
        recItemReclass.Validate("Entry Type", recItemReclass."Entry Type"::Transfer);
        recItemReclass.Validate("Item No.", ItemNo);
        recItemReclass.Validate(Quantity, Qty);
        recItemReclass.Validate("New Location Code", Loc);
        recItemReclass.Insert();
    end;
}

