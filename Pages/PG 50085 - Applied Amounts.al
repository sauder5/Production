page 50085 "Applied Amounts"
{
    // version GroProd

    PageType = ListPart;
    SourceTable = "Settlement Applied Amounts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production Lot No."; "Production Lot No.")
                {
                }
                field("Settlement Ticket No."; "Settlement Ticket No.")
                {
                }
                field("Grower Ticket No."; "Grower Ticket No.")
                {
                }
                field("Quantity Applied"; "Quantity Applied")
                {
                }
                field("recSettlement.""Base Settlement Price"""; recSettlement."Base Settlement Price")
                {
                    Caption = 'Base Price';
                }
                field("recSettlement.""Settlement Type"""; recSettlement."Settlement Type")
                {
                    Caption = 'Settlement Type';
                }
                field("recSettlement.""Settlement Date"""; recSettlement."Settlement Date")
                {
                    Caption = 'Settlement Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        recSettlement.RESET;
        if not recSettlement.GET("Settlement Ticket No.") then
            CLEAR(recSettlement);
    end;

    var
        recSettlement: Record "Settlement-Prepayment Ticket";
}

