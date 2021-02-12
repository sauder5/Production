pageextension 60300 ShipToAddressExt extends "Ship-to Address"
{
    layout
    {
        addafter("Service Zone Code")
        {
            field("EShip Agent Service"; "E-Ship Agent Service")
            {
                ApplicationArea = all;
            }
            field("Region Code"; "Region Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Customer No.")
        {
            field("Freight Charges Option"; "Freight Charges Option")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("E-&Mail List")
        {
            action(Compliances)
            {
                ApplicationArea = all;
                RunObject = page Compliances;
                RunPageLink = "Customer No." = field("Customer No."), "Ship-to Code" = field(Code);
            }
        }
        addafter("Shipping Charge Markups")
        {
            action("Copy from Customer")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    recCust: Record Customer;
                begin
                    TESTFIELD(Code);
                    IF NOT CONFIRM('Do you want to copy fields from Customer card?', FALSE) THEN
                        EXIT;
                    ;

                    recCust.GET("Customer No.");
                    Name := recCust.Name;
                    ;
                    "Name 2" := recCust."Name 2";
                    Address := recCust.Address;
                    "Address 2" := recCust."Address 2";
                    City := recCust.City;
                    Contact := recCust.Contact;
                    "Phone No." := recCust."Phone No.";
                    "Shipment Method Code" := recCust."Shipment Method Code";
                    "Shipping Agent Code" := recCust."Shipping Agent Code";
                    "Place of Export" := recCust."Place of Export";
                    "Country/Region Code" := recCust."Country/Region Code";
                    "Location Code" := recCust."Location Code";
                    "Fax No." := recCust."Fax No.";
                    "Post Code" := recCust."Post Code";
                    County := recCust.County;
                    "E-Mail" := recCust."E-Mail";
                    "Home Page" := recCust."Home Page";
                    "Tax Area Code" := recCust."Tax Area Code";
                    "Tax Liable" := recCust."Tax Liable";
                    "UPS Zone" := recCust."UPS Zone";
                    "Region Code" := recCust."Region Code";
                    "E-Ship Agent Service" := recCust."E-Ship Agent Service";
                    "Free Freight" := recCust."Free Freight";
                    "Residential Delivery" := recCust."Residential Delivery";
                    "Blind Shipment" := recCust."Blind Shipment";
                    "Double Blind Shipment" := recCust."Double Blind Shipment";
                    "No Free Freight Lines on Order" := recCust."No Free Freight Lines on Order";
                    "Shipping Payment Type" := recCust."Shipping Payment Type";
                    "Shipping Insurance" := recCust."Shipping Insurance";
                    CurrPage.UPDATE();

                end;
            }
        }
    }
}