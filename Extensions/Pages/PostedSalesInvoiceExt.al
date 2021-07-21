pageextension 60132 PostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {
        modify(Control1905396001)
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; "Sell-to Customer Name")
            {
                ApplicationArea = all;
            }
        }
        // Added by TAE 2021-07-20 to support the online customer center and ordering
        addafter("Order No.")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Order Date';
                Visible = false;
            }
        }
        // End
        addafter("PaymentGroup -CL-")
        {
            group(Rupp)
            {
                field("Order Created By"; "Order Created By")
                {
                    ApplicationArea = all;
                }
                field("Order Created Date Time"; "Order Created Date Time")
                {
                    ApplicationArea = all;
                }
                field("Ordered By"; "Ordered By")
                {
                    ApplicationArea = all;
                }
                field("Ordered By Name"; "Ordered By Name")
                {
                    ApplicationArea = all;
                }
                field("Ordered By Date"; "Ordered By Date")
                {
                    ApplicationArea = all;
                }
                field("Requested Ship Date"; "Requested Ship Date")
                {
                    ApplicationArea = all;
                }
                field("Cancelled-SOC"; "Cancelled-SOC")
                {
                    ApplicationArea = all;
                }
                field("Cancelled Reason Code"; "Cancelled Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Order Method"; "Order Method")
                {
                    ApplicationArea = all;
                }
                field("Freight Charges Option"; "Freight Charges Option")
                {
                    ApplicationArea = all;
                }
                field("Region Code"; "Region Code")
                {
                    ApplicationArea = all;
                }
                field("Seasonal Cash Disc Code"; "Seasonal Cash Disc Code")
                {
                    ApplicationArea = all;
                }
                field("Grace Period Days"; "Grace Period Days")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}