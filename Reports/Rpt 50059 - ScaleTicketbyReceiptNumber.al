report 50059 "Scale Ticket by Receipt Number"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/ScaleTicketbyReceiptNumber.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Contract Header"; "Purchase Contract Header")
        {
            PrintOnlyIfDetail = true;
            column(hVendorNo; "Purchase Contract Header"."Vendor No.")
            {
            }
            column(hItemNo; "Purchase Contract Header"."Item No.")
            {
            }
            column(hDeliveryStartDate; "Purchase Contract Header"."Delivery Start Date")
            {
            }
            column(hDeliveryEndDate; "Purchase Contract Header"."Delivery End Date")
            {
            }
            column(hContractNo; "Purchase Contract Header"."No.")
            {
            }
            dataitem("Purchase Contract Line"; "Purchase Contract Line")
            {
                DataItemLink = "Contract No." = FIELD("No.");
                DataItemTableView = WHERE("Transaction Type" = FILTER(Receipt));
                column(lReceiptNo; "Purchase Contract Line"."Receipt No.")
                {
                }
                column(lReceiptDate; "Purchase Contract Line"."Receipt Date")
                {
                }
                column(lVendorNum; "Purchase Contract Line"."Vendor No.")
                {
                }
                column(lItemNo; "Purchase Contract Line"."Item No.")
                {
                }
                column(lGrossQty; "Purchase Contract Line"."Recd. Gross Qty.")
                {
                }
                column(lNetQty; "Purchase Contract Line"."Recd. Net Qty.")
                {
                }
                column(CustomerName; recVendor.Name)
                {
                }
                column(lMoisture; "Purchase Contract Line".Moisture)
                {
                }
                column(lTestWgt; "Purchase Contract Line"."Test Weight")
                {
                }
                column(lSplits; "Purchase Contract Line".Splits)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not recVendor.Get("Purchase Contract Line"."Vendor No.") then
                        Clear(recVendor);
                end;
            }
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
        gCustomerName: Text;
        recVendor: Record Vendor;
        DateRange: Date;
        ReceiptNum: Text;
        Item: Text;
        Customer: Text;
}

