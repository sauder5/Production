// Added by TAE 2021-07-20 to support the online customer center and ordering
page 50056 PatchSalesOrderAPI
{
    PageType = API;
    Caption = 'PatchSalesOrderAPI';
    APIPublisher = 'rupp';
    APIGroup = 'salesOrder';
    APIVersion = 'beta';
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    SourceTable = "Sales Header";
    DelayedInsert = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("documentType"; "Document Type")
                {
                    Caption = 'Document Type';
                }
                field("sellToCustomerNo"; "Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field("no"; "No.")
                {
                    Caption = 'No.';
                }
                field("onHold"; "On Hold")
                {
                    Caption = 'On Hold';
                }
                field("accountNumberCL"; "Account Number -CL-")
                {
                    Caption = 'Account Number -CL-';
                }
                field("expirationMonthCL"; "Expiration Month -CL-")
                {
                    Caption = 'Expiration Month -CL-';
                }
                field("expirationYearCL"; "Expiration Year -CL-")
                {
                    Caption = 'Expiration Year -CL-';
                }
                field("accountTypeCL"; "Account Type -CL-")
                {
                    Caption = 'Account Type -CL-';
                    Enabled = true;
                    Editable = true;
                }
                field("eftCustomerLinkTypeCL"; "EFT Customer Link Type -CL-")
                {
                    Caption = 'EFT Customer Link Type -CL-';
                }
                field("eftCustomerLinkNoCL"; "EFT Customer Link No. -CL-")
                {
                    Caption = 'EFT Customer Link No. -CL-';
                }
                field("eftCustLinkLineNoCL"; "EFT Cust. Link Line No. -CL-")
                {
                    Caption = 'EFT Cust. Link Line No. -CL-';
                }
                field("preventAccNumEntryCL"; "Prevent Acc. Num. Entry -CL-")
                {
                    Caption = 'Prevent Acc. Num. Entry -CL-';
                }
                field("eftTenderTypeCL"; "EFT Tender Type -CL-")
                {
                    Caption = 'EFT Tender Type -CL-';
                }
            }
        }
    }
}