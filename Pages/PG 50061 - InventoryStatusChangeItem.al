page 50061 "Inventory Status Change -Item"
{
    // //SOC-SC 10-13-15
    //   Added <Product Availability>
    // 
    // //RSI-TAE 10-16-18
    //   Changed local variable sSearchDesc text length from 30 to 50 so support the longer corn description that includes the seed grade/size

    PageType = Document;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                grid(Item)
                {
                    Caption = 'Item';
                    GridLayout = Rows;
                    group(Control1000000002)
                    {
                        ShowCaption = false;
                        field("No."; "No.")
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
                        field(Inventory; Inventory)
                        {
                        }
                        field("Qty. on Pick"; "Qty. on Pick")
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
                                if gsSubstituteItemNo = "No." then
                                    Error('Please select a different item to substitute');

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
            action("Enter Notes To Print")
            {

                trigger OnAction()
                var
                    recCommentLn: Record "Comment Line";
                begin
                    recCommentLn.Reset();
                    recCommentLn.SetRange("Table Name", recCommentLn."Table Name"::Item);
                    recCommentLn.SetRange("No.", "No.");
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
                    recItem.SetRange("No.", "No.");
                    recItem.FindSet();
                    REPORT.RunModal(50023, true, false, recItem);
                end;
            }
            action("Order Cancellaton Customer List")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    recItem: Record Item;
                begin
                    recItem.Reset();
                    recItem.SetRange("No.", "No.");
                    recItem.FindSet();
                    REPORT.RunModal(50022, true, false, recItem);
                end;
            }
        }
        area(navigation)
        {
            action("Product Availability")
            {
                Caption = 'Product Availability';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recItem: Record Item;
                    sSearchDesc: Text[50];
                begin
                    //RSI-TAE 10-16-18
                    //SOC-SC 10-22-14
                    if "No." <> '' then begin
                        recItem.Get("No.");
                        sSearchDesc := recItem."Search Description";

                        recItem.Reset();
                        recItem.SetRange("Search Description", sSearchDesc);
                        recItem.FindSet();
                        PAGE.RunModal(50003, recItem);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields(Inventory, "Qty. on Sales Order");
        gdQtyAvail := Inventory - "Qty. on Sales Order";
    end;

    trigger OnClosePage()
    begin
        CurrPage.InvtStatusSubpage.PAGE.Reset_InProcessUserID();
    end;

    trigger OnOpenPage()
    begin
        CurrPage.InvtStatusSubpage.PAGE.SetItemNo("No.");
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

