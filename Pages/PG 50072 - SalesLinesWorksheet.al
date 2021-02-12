page 50072 "Sales Lines Worksheet"
{
    // //Orig: 516

    Caption = 'Sales Lines';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Reserve; Reserve)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        SalesHeader.Get("Document Type", "Document No.");
                        case "Document Type" of
                            "Document Type"::Quote:
                                PAGE.Run(PAGE::"Sales Quote", SalesHeader);
                            "Document Type"::Order:
                                PAGE.Run(PAGE::"Sales Order", SalesHeader);
                            "Document Type"::Invoice:
                                PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                            "Document Type"::"Return Order":
                                PAGE.Run(PAGE::"Sales Return Order", SalesHeader);
                            "Document Type"::"Credit Memo":
                                PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                            "Document Type"::"Blanket Order":
                                PAGE.Run(PAGE::"Blanket Sales Order", SalesHeader);
                        end;
                    end;
                }
                action("Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        ShortcutDimCode: array[8] of Code[20];
}

