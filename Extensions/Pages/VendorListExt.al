pageextension 60027 "VendorListExt" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field(County; County)
            {
                Caption = 'State';
                ApplicationArea = all;
            }
            field(Address; Address)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

    }
    trigger OnOpenPage()
    var
        recUserSetup: Record "User Setup";
    begin
        IF NOT recUserSetup.GET(USERID) THEN
            CLEAR(recUserSetup);

        IF recUserSetup."Show Protected Vendors" <> TRUE THEN BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Vendor", '<>%1', TRUE);
            FILTERGROUP(0);
        END ELSE BEGIN
            FILTERGROUP(10);
            SETFILTER("Protected Vendor", '');
            FILTERGROUP(0);
        END;

    end;

}