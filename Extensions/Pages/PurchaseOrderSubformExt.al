pageextension 60054 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Control1)
        {
            Group(TotalGrid)
            {
                Caption = '';
                grid(GridTot)
                {
                    Caption = '';
                    GridLayout = Rows;
                    Group(Totals)
                    {
                        field(gdTotal; gdTotal)
                        {
                            ApplicationArea = all;
                            Caption = 'Total Amount';
                        }
                    }
                }

            }
        }
        addafter("Reserved Quantity")
        {
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                ApplicationArea = all;
            }
        }
        modify(Control43)
        {
            Visible = false;
        }
    }

    actions
    {
    }
    var
        gdTotal: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        gdTotal := getTotal();
    end;

    local procedure getTotal() retTotalAmt: Decimal;
    var
        recPl: Record "Purchase Line";
    begin
        retTotalAmt := 0;
        recPl.RESET;
        recPl.SETRANGE("Document Type", "Document Type");
        recPl.SETRANGE("Document No.", "Document No.");
        IF recPl.FINDSET() THEN BEGIN
            recPl.CALCSUMS(Amount);
            retTotalAmt := recPl.Amount;
        END;
    end;
}