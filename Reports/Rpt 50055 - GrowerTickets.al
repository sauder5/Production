report 50055 "Grower Tickets"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/GrowerTickets.rdlc';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Lot"; "Production Lot")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Add. Annual Prem. per UOM";
            column(Additional_Annual_Premium_per_UOM; "Production Lot"."Add. Annual Prem. per UOM")
            {
            }
            dataitem("Grower Ticket"; "Grower Ticket")
            {
                DataItemLink = "Production Lot No." = FIELD("Production Lot No.");
                DataItemTableView = WHERE(Status = FILTER(<> Canceled));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Vendor No.", "Generic Name Code";
                column(Grower_Ticket_No; "Grower Ticket No.")
                {
                }
                column(Scale_Ticket_No; "Scale Ticket No.")
                {
                }
                column(Production_Lot_No; "Production Lot No.")
                {
                }
                column(Receipt_Date; Format("Receipt Date", 0, 1))
                {
                }
                column(Vendor_No; "Vendor No.")
                {
                }
                column(Generic_Name_Code; "Generic Name Code")
                {
                }
                column(Gross_Qty; "Gross Qty in Purchase UOM")
                {
                }
                column(Net_Qty; "Net Qty in Purchase UOM")
                {
                }
                column(Item_No; "Item No.")
                {
                }
                dataitem("Scale Ticket Header"; "Scale Ticket Header")
                {
                    DataItemLink = "Scale Ticket No." = FIELD("Scale Ticket No.");
                    column(Moisture_Test_Result; "Moisture Test Result")
                    {
                    }
                    column(Test_Weight_Result; "Test Weight Result")
                    {
                    }
                    column(Paper_Scale_Ticket_No; "Paper Scale Ticket No.")
                    {
                    }
                    dataitem(Vendor; Vendor)
                    {
                        DataItemLink = "No." = FIELD("Vendor No.");
                        DataItemLinkReference = "Grower Ticket";
                        column(Vendor_Name; Name)
                        {
                        }
                        column(Vendor_Address; Address)
                        {
                        }
                        column(Vendor_City; City)
                        {
                        }
                        column(Vendor_State; County)
                        {
                        }
                        column(Vendor_Zip; "Post Code")
                        {
                        }
                    }
                }
            }
        }
    }

    requestpage
    {
        SourceTable = "Grower Ticket";

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }
}

