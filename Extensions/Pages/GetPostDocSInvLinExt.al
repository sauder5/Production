pageextension 65852 GetPostDocSInvLinExt extends "Get Post.Doc - S.InvLn Subform"
{
    layout
    {
        addafter("Document No.")
        {
            field("Posting Date"; SalesInvHeader."Posting Date")
            {
                applicationarea = all;
            }
        }
        addafter(LineAmount)
        {
            field("Currency Code"; SalesInvHeader."Currency Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Prices Including VAT"; SalesInvHeader."Prices Including VAT")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Ship-to Code"; SalesInvHeader."Ship-to Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    var
        SalesInvHeader: Record "Sales Invoice Header";

    trigger OnAfterGetRecord()
    begin
        if not SalesInvHeader.Get(Rec."Document No.") then
            Clear(SalesInvHeader);
    end;
}