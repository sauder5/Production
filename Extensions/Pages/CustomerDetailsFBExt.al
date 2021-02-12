pageextension 69084 CustomerDetailsFBExt extends "Customer Details Factbox"
{
    layout
    {
        modify("E-Mail")
        {
            Visible = false;
        }
        addafter("Phone No.")
        {
            field(gEmail; gEmail)
            {
                ApplicationArea = all;
                Caption = 'E-Mail';
            }
        }
    }

    actions
    {
    }

    var
        gEmail: Text;
        recEmail: Record "E-Mail List Entry";

    trigger OnAfterGetRecord()
    begin
        //RSI-KS
        CLEAR(gEmail);
        WITH recEMail DO BEGIN
            SETFILTER("Table ID", '%1', 18);
            SETFILTER(Type, '%1', 0);
            SETFILTER(Code, "No.");
            IF FINDSET THEN
                gEmail := "E-Mail";
        END;
        //RSI-KS

    end;
}