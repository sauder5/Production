page 50029 "CustomerCreditCardsAPI"
{
    PageType = API;
    Caption = 'Customer Credit Cards API';
    APIPublisher = 'rupp';
    APIGroup = 'creditCards';
    APIVersion = 'beta';
    EntityName = 'creditCard';
    EntitySetName = 'creditCards';
    SourceTable = "Customer Credit Card -CL-";
    DelayedInsert = true;
    ODataKeyFields = "Link Type", "No.", "Line No.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(linkType; "Link Type")
                {
                    Caption = 'Link Type', Locked = true;
                }
                field(customerNumber; "No.")
                {
                    Caption = 'Customer Number', Locked = true;
                }
                field(lineNumber; "Line No.")
                {
                    Caption = 'Line Number', Locked = true;
                }
                field(accountNumber; "Account Number")
                {
                    Caption = 'Account Number', Locked = true;
                }
                field(expirationMonth; "Expiration Month")
                {
                    Caption = 'Expiration Month', Locked = true;
                }
                field(expirationYear; "Expiration Year")
                {
                    Caption = 'Expiration Year', Locked = true;
                }
                field(description; Description)
                {
                    Caption = 'Description', Locked = true;
                }
                field(blocked; Blocked)
                {
                    Caption = 'Blocked', Locked = true;
                }
                field(validThroughDate; "Valid Through Date")
                {
                    Caption = 'Valid Through Date', Locked = true;
                }
            }
        }
    }
}
