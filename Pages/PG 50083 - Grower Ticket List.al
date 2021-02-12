page 50083 "Grower Ticket List"
{
    // version GroProd

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(VendorNo; gVendorNo)
            {
                Caption = 'Vendor No.';
                TableRelation = Vendor."No.";

                trigger OnValidate();
                var
                    recGrowerTkt: Record "Grower Ticket";
                begin
                    UpdateTotal;
                end;
            }
            field("recVendor.Name"; recVendor.Name)
            {
                Editable = false;
            }
            field(GenericName; gGenericName)
            {
                Caption = 'Generic Name Code';
                TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));

                trigger OnValidate();
                begin
                    UpdateTotal;
                end;
            }
            group(Control1000000005)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field(gOpenTotal; gOpenTotal)
                {
                    Caption = 'Quantity Not Settled';
                    Editable = false;
                }
            }
            part(OpenTickets; "Grower Tickets")
            {
                Caption = 'Open Grower Tickets';
                Editable = false;
                SubPageView = WHERE("Remaining Quantity" = FILTER(> 0),
                                    Status = FILTER(Posted));
                UpdatePropagation = Both;
            }
            part(SettledTickets; "Grower Tickets")
            {
                Caption = 'Settled Grower Tickets';
                Editable = false;
                SubPageView = WHERE("Remaining Quantity" = FILTER(0),
                                    Status = FILTER(Posted));
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(reporting)
        {
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        if gVendorNo = '' then begin
            CurrPage.OpenTickets.PAGE.SetDataFilter('X', 'Y');
            CurrPage.SettledTickets.PAGE.SetDataFilter('X', 'Y');
        end;
    end;

    trigger OnAfterGetRecord();
    var
        recGrowerTkt: Record "Grower Ticket";
    begin
    end;

    trigger OnOpenPage();
    begin
        CurrPage.OpenTickets.PAGE.SetDataFilter('X', 'Y');
        CurrPage.SettledTickets.PAGE.SetDataFilter('X', 'Y');
    end;

    var
        gOpenTotal: Decimal;
        gVendorNo: Code[20];
        recVendor: Record Vendor;
        gGenericName: Code[20];

    local procedure UpdateTotal();
    var
        recGrowerTkt: Record "Grower Ticket";
    begin
        recVendor.GET(gVendorNo);
        gOpenTotal := 0;

        recGrowerTkt.RESET;
        recGrowerTkt.SETFILTER("Vendor No.", recVendor."No.");
        recGrowerTkt.SETFILTER(Status, '%1', recGrowerTkt.Status::Posted);
        recGrowerTkt.SETFILTER("Remaining Quantity", '>0');
        recGrowerTkt.CALCSUMS("Remaining Quantity");
        gOpenTotal := recGrowerTkt."Remaining Quantity";

        CurrPage.OpenTickets.PAGE.SetDataFilter(gVendorNo, gGenericName);
        CurrPage.SettledTickets.PAGE.SetDataFilter(gVendorNo, gGenericName);
        CurrPage.UPDATE;
    end;
}

