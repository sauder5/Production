pageextension 60050 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field(gPhone; gPhone)
            {
                ApplicationArea = all;
                Caption = 'Phone #';
                Editable = false;
            }
        }
        addafter("Assigned User ID")
        {
            field("Receiving Address Code"; "Receiving Address Code")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Posting Description"; "Buy-from Address")
        moveafter("Buy-from Address"; "Buy-from Address 2")
        moveafter("Buy-from Address 2"; "Buy-from City")
        moveafter("Buy-from City"; "Buy-from County")
        moveafter("Buy-from County"; "Buy-from Post Code")
        moveafter("Buy-from Post Code"; "Buy-from Country/Region Code")
        moveafter("Buy-from Country/Region Code"; "Buy-from Contact No.")
        moveafter("Buy-from Contact No."; "Buy-from Contact")
        moveafter("Buy-from Contact"; "Document Date")
        moveafter("Document Date"; "Posting Date")
        moveafter("Posting Date"; "Due Date")
        moveafter("Due Date"; "Vendor Invoice No.")
        moveafter("Vendor Invoice No."; "Purchaser Code")
        moveafter("Purchaser Code"; "No. of Archived Versions")
        moveafter("No. of Archived Versions"; "Order Date")
        moveafter("Order Date"; "Quote No.")
        moveafter("Quote No."; "Vendor Order No.")
        moveafter("Vendor Order No."; "Order Address Code")
        moveafter("Order Address Code"; "Responsibility Center")
        moveafter("Responsibility Center"; "Assigned User ID")
        moveafter("Assigned User ID"; "Location Code")
        moveafter("Location Code"; Status)
        moveafter(Status; "Job Queue Status")
        moveafter("Receiving Address Code"; "Location Code")

        modify("Pay-to County")
        {
            Caption = 'State';
        }
        modify("Buy-from County")
        {
            Caption = 'Buy-From State';
        }
        addafter("Job Queue Status")
        {
            field("Future PO"; "Future PO")
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to UPS Zone")
        {
            field("E-Ship Agent Code"; "E-Ship Agent Code")
            {
                ApplicationArea = all;
            }
            field("E-Ship Agent Service"; "E-Ship Agent Service")
            {
                ApplicationArea = all;
            }
        }
        modify(Control101) { Visible = true; }
        modify(Control124) { Visible = true; }
        modify(Control95) { Visible = true; }
        modify(Control123) { Visible = true; }
        addbefore("Ship-to Name")
        {
            field("ReceivingAddressCode"; "Receiving Address Code") { ApplicationArea = all; }
        }
        modify("Ship-to Name") { Editable = true; ApplicationArea = all; }
        modify("Ship-to Address") { Editable = true; ApplicationArea = all; }
        modify("Ship-to Address 2") { Editable = true; ApplicationArea = all; }
        modify("Ship-to City") { Editable = true; ApplicationArea = all; }
        modify("Ship-to County") { Editable = true; ApplicationArea = all; }
        modify("Ship-to Post Code") { Editable = true; ApplicationArea = all; }
        modify("Ship-to Country/Region Code") { Editable = true; ApplicationArea = all; }
        modify("Ship-to Contact") { Editable = true; ApplicationArea = all; }
        modify("Ship-to UPS Zone") { Editable = true; ApplicationArea = all; }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        gPhone: Text[30];

    trigger OnAfterGetRecord()
    var
        recVendor: Record Vendor;
    begin
        Clear(gPhone);
        if recVendor.Get("Buy-from Vendor No.") then
            gPhone := recVendor."Phone No.";
    end;

}