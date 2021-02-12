page 50071 "Shipment Planning Worksheet"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Shipment Planning Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(CurrentBatchName; CurrentBatchName)
            {
                Caption = 'Batch Name';

                trigger OnLookup(var Text: Text): Boolean
                var
                    recShptPlanningBatch: Record "Shipment Planning Batch";
                begin
                    CurrPage.SaveRecord;
                    Commit;
                    recShptPlanningBatch.Reset();
                    recShptPlanningBatch."Batch Name" := CurrentBatchName;//rec.GETRANGEMAX("Batch Name");
                    if PAGE.RunModal(0, recShptPlanningBatch) = ACTION::LookupOK then begin
                        CurrentBatchName := recShptPlanningBatch."Batch Name";
                        FilterGroup := 2;
                        SetRange("Batch Name", CurrentBatchName);
                        FilterGroup := 0;
                        if Find('-') then;
                    end;

                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                var
                    ShptPlanningBatch: Record "Shipment Planning Batch";
                begin
                    ShptPlanningBatch.Get(CurrentBatchName);
                    CurrentBatchNameOnAfterVali();
                end;
            }
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sales Document Type"; "Sales Document Type")
                {
                }
                field("Sales Document No."; "Sales Document No.")
                {
                }
                field("Sales Document Line No."; "Sales Document Line No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Pick Qty."; "Pick Qty.")
                {
                }
                field("Gross Weight"; "Gross Weight")
                {
                }
                field("Net Weight"; "Net Weight")
                {
                }
                field("Oustanding Quantity"; "Oustanding Quantity")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Product Code"; "Product Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Qty. Available"; "Qty. Available")
                {
                }
                field("Qty. on Hand"; "Qty. on Hand")
                {
                }
                field("Qty. on Order"; "Qty. on Order")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Pick Exists"; "Pick Exists")
                {
                }
                field("Pick No."; "Pick No.")
                {
                }
                field(State; State)
                {
                }
                field("Shipment Method"; "Shipment Method")
                {
                }
                field("Pick Created Date"; "Pick Created Date")
                {
                }
                field(Waivers; Waivers)
                {
                }
                field("Expiration date"; "Expiration date")
                {
                }
                field("Credit Limit"; "Credit Limit")
                {
                }
                field(Manufacturer; Manufacturer)
                {
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("Weight (Lbs)"; "Weight (Lbs)")
                {
                }
                field("Weight (G)"; "Weight (G)")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Suggest Planning Lines")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recShptPlanningLine: Record "Shipment Planning Line";
                    repShptPlWksh: Report "Suggest Shipment Planning Line";
                begin
                    recShptPlanningLine.Reset();
                    recShptPlanningLine.SetRange("Batch Name", CurrentBatchName);
                    if recShptPlanningLine.FindFirst() then begin
                        //ERROR('Please delete lines from the journal and try again');
                        if not Confirm('There are lines in the journal. Do you want to refresh the journal?', true) then begin
                            exit;
                        end;
                    end;

                    recShptPlanningLine.FindSet();
                    recShptPlanningLine.DeleteAll();
                    Commit;
                    Clear(repShptPlWksh);
                    repShptPlWksh.SetPlanningBatchName(CurrentBatchName);
                    repShptPlWksh.RunModal();
                    //REPORT.RUNMODAL(50017, TRUE, FALSE);
                    Clear(repShptPlWksh);
                end;
            }
            action("Sales Order")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Order";
                RunPageLink = "Document Type" = FIELD("Sales Document Type"),
                              "No." = FIELD("Sales Document No.");
            }
            action("Sales Line")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Lines Worksheet";
                RunPageLink = "Document Type" = FIELD("Sales Document Type"),
                              "Document No." = FIELD("Sales Document No."),
                              "Line No." = FIELD("Sales Document Line No.");
            }
            action("Sales Order Shipping")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales Order Shipment";
                RunPageLink = "Document Type" = FIELD("Sales Document Type"),
                              "No." = FIELD("Sales Document No.");
            }
        }
        area(reporting)
        {
            action("Picking List by Order")
            {
                Visible = false;

                trigger OnAction()
                var
                    recSH: Record "Sales Header";
                begin
                    if "Sales Document Type" = "Sales Document Type"::Order then begin
                        recSH.Reset();
                        recSH.SetRange("Document Type", "Sales Document Type");
                        recSH.SetRange("No.", "Sales Document No.");
                        recSH.FindSet();
                        REPORT.RunModal(10153, true, false, recSH);
                    end;
                end;
            }
            action("Pick Ticket")
            {
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    cuRuppFun: Codeunit "Rupp Functions";
                    recSH: Record "Sales Header";
                begin
                    cuRuppFun.PrintPickTTicketForSO("Sales Document No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        recShptPlanningBatch: Record "Shipment Planning Batch";
    begin
        OpenedFromBatch := "Batch Name" <> '';
        if OpenedFromBatch then begin
            CurrentBatchName := "Batch Name";
            FilterGroup := 2;
            SetRange("Batch Name", CurrentBatchName);
            FilterGroup := 0;
            exit;
        end else begin
            recShptPlanningBatch.Reset();
            if recShptPlanningBatch.FindFirst() then begin
                CurrentBatchName := recShptPlanningBatch."Batch Name";
                FilterGroup := 2;
                SetRange("Batch Name", CurrentBatchName);
                FilterGroup := 0;
            end;
        end;
    end;

    var
        OpenedFromBatch: Boolean;
        CurrentBatchName: Code[10];

    local procedure CurrentBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        FilterGroup := 2;
        SetRange("Batch Name", CurrentBatchName);
        FilterGroup := 0;
        if Find('-') then;
        CurrPage.Update(false);
    end;
}

