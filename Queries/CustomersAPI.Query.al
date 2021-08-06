query 50016 "CustomersAPI"
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'customers';
    APIVersion = 'beta';
    EntityName = 'customer';
    EntitySetName = 'customers';
    TopNumberOfRows = 10;
    OrderBy = ascending(customerNumber);

    elements
    {
        dataitem(Customer; Customer)
        {
            column(customerNumber; "No.")
            {
                Caption = 'Customer Number', Locked = true;
            }
            column(customerName; Name)
            {
                Caption = 'Customer Name', Locked = true;
            }
            column(cutomerName2; "Name 2")
            {
                Caption = 'Customer Name 2', Locked = true;
            }
            column(customerAddress; Address)
            {
                Caption = 'Customer Address', Locked = true;
            }
            column(customerAddress2; "Address 2")
            {
                Caption = 'Customer Address 2', Locked = true;
            }
            column(customerCity; City)
            {
                Caption = 'Customer City', Locked = true;
            }
            column(customerContact; Contact)
            {
                Caption = 'Customer Contact', Locked = true;
            }
            column(customerPhoneNumber; "Phone No.")
            {
                Caption = 'Customer Phone Number', Locked = true;
            }
            column(customerPostingGroup; "Customer Posting Group")
            {
                Caption = 'Customer Posting Group', Locked = true;
            }
            column(customerPriceGroup; "Customer Price Group")
            {
                Caption = 'Customer Price Group', Locked = true;
            }
            column(customerCountryCode; "Country/Region Code")
            {
                Caption = 'Customer Country Code', Locked = true;
            }
            column(customerBlocked; Blocked)
            {
                Caption = 'Customer Blocked', Locked = true;
            }
            column(customerPostCode; "Post Code")
            {
                Caption = 'Customer Post Code', Locked = true;
            }
            column(customerCounty; County)
            {
                Caption = 'Customer County', Locked = true;
            }
            column(customerEmail; "E-Mail")
            {
                Caption = 'Customer Email', Locked = true;
            }
            column(customerPrimaryContactNumber; "Primary Contact No.")
            {
                Caption = 'Customer Primary Contact Number', Locked = true;
            }
            column(customerCreditLimit; "Credit Limit (LCY)")
            {
                Caption = 'Customer Credit Limit', Locked = true;
            }
            column(defaultShipToCode; "Default Ship-to Code")
            {
                Caption = 'Default Ship-to Code', Locked = true;
            }
            column(balanceDueLcy; "Balance Due (LCY)")
            {
                Caption = 'Balance ($)', Locked = true;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}