page 50024 "Posted Receipt Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "Posted Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Ticket No."; "Ticket No.")
                {
                }
                field("Ratio %"; "Ratio %")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Received; Received)
                {
                }
                field("Purchase Doc Type"; "Purchase Doc Type")
                {
                }
                field("Purchase Doc No."; "Purchase Doc No.")
                {
                }
                field("Purchase Doc Line No."; "Purchase Doc Line No.")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Check-off %"; "Check-off %")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ShowDocument)
            {
                Caption = 'Show &Document';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                var
                    PostedReceiptHdr: Record "Posted Receipt Header";
                begin
                    PostedReceiptHdr.Get("Receipt No.");
                    PAGE.Run(PAGE::"Posted Receipt", PostedReceiptHdr);
                end;
            }
            action("Posted Purchase Receipt Lines")
            {

                trigger OnAction()
                var
                    recPurchrcptLn: Record "Purch. Rcpt. Line";
                begin
                    recPurchrcptLn.Reset();
                    recPurchrcptLn.SetRange("Rcpt No.", "Receipt No.");
                    recPurchrcptLn.SetRange("Rcpt Line No.", "Line No.");
                    if recPurchrcptLn.FindSet() then begin
                        PAGE.Run(528, recPurchrcptLn);
                    end;
                end;
            }
        }
    }
}

