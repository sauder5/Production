report 50009 "Contract Pricing Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/ContractPricingConfirmation.rdlc';
    ProcessingOnly = false;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Contract Header"; "Purchase Contract Header")
        {
            column(ContractNo; "Purchase Contract Header"."No.")
            {
            }
            column(VendorNo; "Purchase Contract Header"."Vendor No.")
            {
            }
            column(ItemNo; "Purchase Contract Header"."Item No.")
            {
            }
            column(ItemDescription; "Purchase Contract Header"."Item Description")
            {
            }
            column(ItemInfo; "Purchase Contract Header"."Item Description")
            {
            }
            column(ContractQty; "Purchase Contract Header".Quantity)
            {
            }
            column(ContractDate; "Purchase Contract Header"."Contract Date")
            {
            }
            column(DeliveryStartDate; "Purchase Contract Header"."Delivery Start Date")
            {
            }
            column(DeliveryEndDate; "Purchase Contract Header"."Delivery End Date")
            {
            }
            column(DeliveryPeriod; gsDeliveryPeriod)
            {
            }
            column(CompanyInfo1; gsCompanyInfo[1])
            {
            }
            column(CompanyInfo2; gsCompanyInfo[2])
            {
            }
            column(CompanyInfo3; gsCompanyInfo[3])
            {
            }
            column(CompanyInfo4; gsCompanyInfo[4])
            {
            }
            column(CompanyInfo5; gsCompanyInfo[5])
            {
            }
            column(CompanyInfo6; gsCompanyInfo[6])
            {
            }
            column(CompanyInfo7; gsCompanyInfo[7])
            {
            }
            column(CompanyInfo8; gsCompanyInfo[8])
            {
            }
            column(VendorAddress1; gsVendorAddress[1])
            {
            }
            column(VendorAddress2; gsVendorAddress[2])
            {
            }
            column(VendorAddress3; gsVendorAddress[3])
            {
            }
            column(VendorAddress4; gsVendorAddress[4])
            {
            }
            column(VendorAddress5; gsVendorAddress[5])
            {
            }
            column(VendorAddress6; gsVendorAddress[6])
            {
            }
            column(VendorAddress7; gsVendorAddress[7])
            {
            }
            column(VendorAddress8; gsVendorAddress[8])
            {
            }
            dataitem("Purchase Contract Line"; "Purchase Contract Line")
            {
                DataItemLink = "Contract No." = FIELD("No.");
                DataItemTableView = WHERE("Transaction Type" = CONST(Settlement));
                column(LineContractNo; "Purchase Contract Line"."Contract No.")
                {
                }
                column(LineNo; "Purchase Contract Line"."Line No.")
                {
                }
                column(PriceDate; "Purchase Contract Line"."Posting Date")
                {
                }
                column(Qty; "Purchase Contract Line".Quantity)
                {
                }
                column(LItemNo; "Purchase Contract Line"."Item No.")
                {
                }
                column(LVendorNo; "Purchase Contract Line"."Vendor No.")
                {
                }
                column(Price; "Purchase Contract Line"."Settlement Unit Cost")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                recCompanyInfo: Record "Company Information";
                recVendor: Record Vendor;
                cuFormatAddress: Codeunit "Format Address";
            begin
                recCompanyInfo.Get();

                cuFormatAddress.FormatAddr(gsCompanyInfo, recCompanyInfo.Name, recCompanyInfo."Name 2", '', recCompanyInfo.Address, recCompanyInfo."Address 2",
                                          recCompanyInfo.City, recCompanyInfo."Post Code", recCompanyInfo.County, recCompanyInfo."Country/Region Code");

                CompressArray(gsCompanyInfo);

                recVendor.Get("Vendor No.");

                cuFormatAddress.FormatAddr(gsVendorAddress, recVendor.Name, recVendor."Name 2", recVendor.Contact, recVendor.Address, recVendor."Address 2",
                                              recVendor.City, recVendor."Post Code", recVendor.County, recCompanyInfo."Country/Region Code");

                CompressArray(gsVendorAddress);

                gsDeliveryPeriod := Format("Delivery Start Date", 0) + ' To ' + Format("Delivery End Date", 0);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        gsCompanyInfo: array[8] of Text[50];
        gsVendorAddress: array[8] of Text[50];
        gsDeliveryPeriod: Text[50];
}

