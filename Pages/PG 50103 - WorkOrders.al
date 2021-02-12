page 50103 "Work Orders"
{
    CardPageID = "Work Order";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Work Order";
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
                field(Status; Status)
                {
                }
                field(Template; Template)
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Created By"; "Created By")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                Caption = 'RecordLinks';
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                Image = Line;
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Entries;
                    action("Item Ledger Entries")
                    {
                        Caption = 'Item Ledger E&ntries';
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
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                    }
                }
                action("Show Order")
                {
                    Caption = 'Show Order';
                    Image = ViewOrder;
                    RunObject = Page "Work Order";
                    ShortCutKey = 'Shift+F7';
                }
                action(Comments)
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Enabled = false;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Enabled = false;
                    Image = ReOpen;
                    Visible = false;

                    trigger OnAction()
                    var
                        ReleaseAssemblyDoc: Codeunit "Release Assembly Document";
                    begin
                        //ReleaseAssemblyDoc.Reopen(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                Visible = false;
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Enabled = false;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //CODEUNIT.RUN(CODEUNIT::"Assembly-Post (Yes/No)",Rec);
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Enabled = false;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //REPORT.RUNMODAL(REPORT::"Batch Post Assembly Orders",TRUE,TRUE,Rec);
                        CurrPage.Update(false);
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
            group(Process)
            {
                Caption = 'Process';
                action("Veg Labels")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Vegetable Label List";
                }
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

