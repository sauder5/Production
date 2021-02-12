page 50020 "Receipt Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "Receipt Line";

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
                field(Quantity; Quantity)
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Ticket No."; "Ticket No.")
                {
                    Visible = false;
                }
                field("Receipt Date"; "Receipt Date")
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
                    ReceiptHdr: Record "Receipt Header";
                begin
                    ReceiptHdr.Get("Receipt No.");
                    PAGE.Run(PAGE::Receipt, ReceiptHdr);
                end;
            }
        }
    }
}

