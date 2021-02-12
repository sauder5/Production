pageextension 66631 SalesReturnOrderSubformExt extends "Sales Return Order Subform"
{
    layout
    {
        addbefore(Control1)
        {
            grid(Totals)
            {
                GridLayout = Rows;
                group(TotalAmt)
                {
                    field("Total Amount"; gdTotalAmt)
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                }
            }
        }
        addafter("Unit Price")
        {
            field("Unit Price Reason Code"; "Unit Price Reason Code")
            {
                ApplicationArea = all;
            }
        }
        modify(Control37)
        {
            Visible = false;
        }
    }

    actions
    {
    }

    var
        gdTotalAmt: Decimal;

    trigger OnAfterGetRecord()
    begin
        gdTotalAmt := GetTotalAmt();
    end;

    procedure GetTotalAmt() retTotalAmt: Decimal
    var
        recSL: Record "Sales Line";
    begin
        retTotalAmt := 0;
        recSL.RESET();
        recSL.SETRANGE("Document Type", "Document Type");
        recSL.SETRANGE("Document No.", "Document No.");
        IF recSL.FINDSET() THEN BEGIN
            recSL.CALCSUMS("Line Amount");
            retTotalAmt := recSL."Line Amount";
        end;
    end;
}