page 50060 "Inventory Status Change -Prod"
{
    PageType = Document;
    SourceTable = Product;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                grid(Product)
                {
                    Caption = 'Product';
                    GridLayout = Rows;
                    group(Control1000000002)
                    {
                        ShowCaption = false;
                        field("Code"; Code)
                        {
                            Editable = false;
                        }
                        field(Description; Description)
                        {
                            Editable = false;
                        }
                        field("Inventory Status Code"; "Inventory Status Code")
                        {
                            Editable = false;
                        }
                    }
                    group(Control1000000011)
                    {
                        ShowCaption = false;
                        field("Qty. on Hand"; "Qty. on Hand")
                        {
                        }
                        field(gdQtyAvail; gdQtyAvail)
                        {
                            Caption = 'Qty. Available';
                            Editable = false;
                        }
                    }
                }
                grid("Substitute Item")
                {
                    Caption = 'Substitute Item';
                    GridLayout = Rows;
                    group(Control1000000010)
                    {
                        ShowCaption = false;
                        field(gsSubstituteItemNo; gsSubstituteItemNo)
                        {
                            Caption = 'Substitute Item No.';
                            TableRelation = Item WHERE(Blocked = FILTER(false),
                                                        "Inventory Status Code" = FILTER(''));

                            trigger OnValidate()
                            var
                                recItem: Record Item;
                                CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                            begin
                                recItem.Get(gsSubstituteItemNo);
                                if recItem."Inventory Status Code" <> '' then
                                    Error('Inventory Status Code for item %1 is %2', recItem."No.", recItem."Inventory Status Code");

                                gsSubstituteItemDesc := recItem.Description;
                                recItem.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Pick");
                                gdSubQOH := recItem.Inventory;
                                gdSubQtyonPick := recItem."Qty. on Pick";
                                gdSubQtyAvail := recItem.Inventory - recItem."Qty. on Sales Order";
                                gsSubInventoryStatus := recItem."Inventory Status Code";
                                //CancelSubMgt.UpdateSubstituteItemNo(Rec, gsSubstituteItemNo);
                                CurrPage.InvtStatusSubpage.PAGE.UpdateSubsItemNo(gsSubstituteItemNo);
                            end;
                        }
                        field(gsSubstituteItemDesc; gsSubstituteItemDesc)
                        {
                            Caption = 'Substitute Item Description';
                            Editable = false;
                        }
                        field(gsSubInventoryStatus; gsSubInventoryStatus)
                        {
                            Caption = 'Substitute Item Invt. Status';
                            Editable = false;
                        }
                    }
                    group(Control1000000015)
                    {
                        ShowCaption = false;
                        field(gdSubQOH; gdSubQOH)
                        {
                            Caption = 'Substitute Item Qty. on Hand';
                            Editable = false;
                        }
                        field(gdSubQtyonPick; gdSubQtyonPick)
                        {
                            Caption = 'Substitute Item Qty. on Pick';
                            Editable = false;
                        }
                        field(gdSubQtyAvail; gdSubQtyAvail)
                        {
                            Caption = 'Substitute Item Qty. Available';
                            Editable = false;
                        }
                    }
                }
            }
            part(InvtStatusSubpage; "Invt. Status Change Subpage")
            {
                SubPageLink = Type = CONST(Item);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Substitute/ Cancel")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.InvtStatusSubpage.PAGE.Substitute_Cancel();
                end;
            }
            action("Reopen Order")
            {
            }
            action("Release Order")
            {
            }
            action("Enter Notes To Print-old")
            {
                Enabled = false;
                Visible = false;

                trigger OnAction()
                var
                    recCommentLnTmp: Record "Comment Line" temporary;
                    pgNotesForCancellationNotice: Page "Notes for Cancellation Notice";
                begin
                    recCommentLnTmp.Reset();
                    Clear(pgNotesForCancellationNotice);
                    Clear(recCommentLnTmp);

                    //recCommentLnTmp.SETRANGE("Table Name", recCommentLnTmp."Table Name"::Item);
                    //recCommentLnTmp.SETRANGE("No.", '');//"No.");
                    //recCommentLnTmp.SETRANGE("Print on Cancellation Notice", TRUE);
                    //IF recCommentLnTmp.FINDSET() THEN ;
                    pgNotesForCancellationNotice.SetInventoryStatusCode("Inventory Status Code");
                    pgNotesForCancellationNotice.SetTableView(recCommentLnTmp);
                    //pgNotesForCancellationNotice.SETRECORD(recCommentLnTmp);
                    if pgNotesForCancellationNotice.RunModal() = ACTION::OK then begin
                        recCommentLnTmp.SetRange("Table Name", recCommentLnTmp."Table Name"::Item);
                        recCommentLnTmp.SetRange(Code, "Inventory Status Code");
                        Message('No. of comment lines: %1', recCommentLnTmp.Count);
                    end;
                    Clear(pgNotesForCancellationNotice);
                    Clear(recCommentLnTmp);
                    /*
                    IF PAGE.RUNMODAL(50063, recCommentLn) = ACTION::LookupOK THEN BEGIN
                      recCommentLn.SETRANGE(Code, "Inventory Status Code");
                      MESSAGE('No. of comment lines: %1', recCommentLn.COUNT);
                    END;
                    */

                end;
            }
            action("Enter Notes To Print")
            {

                trigger OnAction()
                var
                    recCommentLn: Record "Comment Line" temporary;
                begin
                    recCommentLn.Reset();
                    recCommentLn.SetRange("Table Name", recCommentLn."Table Name"::Item);
                    recCommentLn.SetRange("No.", '');//"No.");
                    recCommentLn.SetRange("Print on Cancellation Notice", true);
                    if recCommentLn.FindSet() then;
                    if PAGE.RunModal(50063, recCommentLn) = ACTION::LookupOK then begin
                        recCommentLn.SetRange(Code, "Inventory Status Code");
                        Message('No. of comment lines: %1', recCommentLn.Count);
                    end;
                end;
            }
            action("Autofill Substitute All")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.InvtStatusSubpage.PAGE.AutofillSubstituteAll();
                end;
            }
            action("Autofill Cancel All")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.InvtStatusSubpage.PAGE.AutofillCancelAll();
                end;
            }
            action("Reset Action All")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.InvtStatusSubpage.PAGE.ResetActionAll();
                end;
            }
            action("Order Cancellation")
            {
                Image = Form;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    recItem: Record Item;
                begin
                    recItem.Reset();
                    recItem.SetRange("Product Code", Code);
                    recItem.FindSet();
                    REPORT.RunModal(50023, true, false, recItem);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Qty. on Hand", "Qty. on Sales Orders");
        gdQtyAvail := "Qty. on Hand" - "Qty. on Sales Orders";
    end;

    trigger OnClosePage()
    begin
        CurrPage.InvtStatusSubpage.PAGE.Reset_InProcessUserID();
    end;

    trigger OnOpenPage()
    begin
        CurrPage.InvtStatusSubpage.PAGE.SetProductNo(Code);
        CurrPage.InvtStatusSubpage.PAGE.SetInventoryStatus("Inventory Status Code");
    end;

    var
        gsSubstituteItemNo: Code[20];
        gsSubstituteItemDesc: Text[50];
        gdQtyAvail: Decimal;
        gdSubQOH: Decimal;
        gdSubQtyonPick: Decimal;
        gdSubQtyAvail: Decimal;
        gsSubInventoryStatus: Code[20];
}

