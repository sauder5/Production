query 50020 "ShipToAddressesAPI"
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'addresses';
    APIVersion = 'beta';
    EntityName = 'shiptoaddress';
    EntitySetName = 'shiptoaddresses';
    TopNumberOfRows = 100;
    OrderBy = ascending(shipToCounty, shipToCity, shipToAddress);

    elements
    {
        dataitem(shipToAddresses; "Ship-to Address")
        {
            column(shipToCustomerNo; "Customer No.")
            {
                Caption = 'Ship-to Customer No.', Locked = true;
            }
            column(shipToCode; "Code")
            {
                Caption = 'Ship-to Code', Locked = true;
            }
            column(shipToContact; Contact)
            {
                Caption = 'Ship-to Contact', Locked = true;
            }
            column(shipToName; Name)
            {
                Caption = 'Ship-to Name', Locked = true;
            }
            column(shipToName2; "Name 2")
            {
                Caption = 'Ship-to Name 2', Locked = true;
            }
            column(shipToAddress; Address)
            {
                Caption = 'Ship-to Address', Locked = true;
            }
            column(shipToAddress2; "Address 2")
            {
                Caption = 'Ship-to Address 2', Locked = true;
            }
            column(shipToCity; City)
            {
                Caption = 'Ship-to City', Locked = true;
            }
            column(shipToCounty; County)
            {
                Caption = 'Ship-to State', Locked = true;
            }
            column(shipToPostCode; "Post Code")
            {
                Caption = 'Ship-to Post Code', Locked = true;
            }
            column(shipToCountryRegionCode; "Country/Region Code")
            {
                Caption = 'Ship-to Country Code', Locked = true;
            }
            column(shipToPhoneNo; "Phone No.")
            {
                Caption = 'Ship-to Phone No.', Locked = true;
            }
            column(shipToRegionCode; "Region Code")
            {
                Caption = 'Ship-to Region Code', Locked = true;
            }
            column(shipToFreightChargesOption; "Freight Charges Option")
            {
                Caption = 'Ship-to Freight Charges Option', Locked = true;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}