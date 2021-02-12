pageextension 60025 CustLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.")
        {
            field("Customer Name"; "Customer Name")
            {
                applicationarea = all;
            }
            field("Ship-to Name"; gsShipToName)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {

    }

    var
        gsShipToName: Text[50];

    trigger OnAfterGetRecord()
    begin
        GetShipToName();
    end;

    procedure GetShipToName()
    var
        recSIH: Record "Sales Invoice Header";
    begin
        gsShipToName := '';
        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            IF recSIH.GET("Document No.") THEN BEGIN
                gsShipToName := recSIH."Ship-to Name";
            END;
        END;
    end;
}