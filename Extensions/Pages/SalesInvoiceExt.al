pageextension 60043 SalesInvoiceExt extends "Sales Invoice"
{
    layout
    {
        modify("Work Description")
        {
            Visible = false;
        }
        modify(ShippingOptions)
        {
            Visible = false;
        }
        modify(BillToOptions)
        {
            Visible = false;
        }
        modify(Control202) { Visible = true; }
        modify(Control82) { Visible = true; }
        modify(Control205) { Visible = true; }
        modify(Control85) { Visible = true; }
        modify("Ship-to Code") { Editable = true; }
        modify("Ship-to Name") { Editable = true; }
        modify("Ship-to Address") { Editable = true; }
        modify("Ship-to Address 2") { Editable = true; }
        modify("Ship-to City") { Editable = true; }
        modify("Ship-to County") { Editable = true; }
        modify("Ship-to Post Code") { Editable = true; }
        modify("Ship-to Country/Region Code") { Editable = true; }
        modify("Ship-to UPS Zone") { Editable = true; }
        modify("Ship-to Contact") { Editable = true; }
        modify("Bill-to Name") { Editable = true; Enabled = true; }
        modify("Bill-to Address") { Editable = true; Enabled = true; }
        modify("Bill-to Address 2") { Editable = true; Enabled = true; }
        modify("Bill-to City") { Editable = true; Enabled = true; }
        modify("Bill-to County") { Editable = true; Enabled = true; }
        modify("Bill-to Post Code") { Editable = true; Enabled = true; }
        modify("Bill-to Country/Region Code") { Editable = true; Enabled = true; }
        modify("Bill-to Contact No.") { Editable = true; Enabled = true; }
        modify("Bill-to Contact") { Editable = true; Enabled = true; }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}