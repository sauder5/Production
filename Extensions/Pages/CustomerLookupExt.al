pageextension 60033 CustomerLookupExt extends "Customer Lookup"
{
    layout
    {

    }
    trigger OnOpenPage()
    var
        recUserSetup: Record "User Setup";
    begin
        IF NOT recUserSetup.GET(USERID) THEN
            CLEAR(recUserSetup);

        IF recUserSetup."Show Protected Customers" <> TRUE THEN BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Customer", '<>%1', TRUE);
            FILTERGROUP(0);
        END ELSE BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Customer", '');
            FILTERGROUP(0);
        END;
    end;
}