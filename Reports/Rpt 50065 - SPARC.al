report 50065 SPARC
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/SPARC.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Settlement-Prepayment Ticket"; "Settlement-Prepayment Ticket")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Settlement Date", "Generic Name Code", "Vendor No.", "Production Lot No.";
            column(Settlement_No; "Settlement No.")
            {
            }
            column(Vendor_No; "Vendor No.")
            {
            }
            column(Generic_Name_Code; "Generic Name Code")
            {
            }
            column(Settlement_Quantity; "Settlement Quantity")
            {
            }
            column(Settlement_Date; Format("Settlement Date", 0, 1))
            {
            }
            column(Base_Settlement_Price; "Base Settlement Price")
            {
            }
            column(Prepayment_Amount; "Prepayment Amount")
            {
            }
            column(Settlement_Type; "Settlement Type")
            {
            }
            column(Futures_Date; Format("Futures Date", 0, 1))
            {
            }
            column(Deferred_Payment; "Deferred Payment")
            {
            }
            column(Deferred_Date; Format("Deferred Date", 0, 1))
            {
            }
            column(SettlementDateFilter; SettlementDateFilter)
            {
            }
            dataitem("Settlement Applied Amounts"; "Settlement Applied Amounts")
            {
                DataItemLink = "Settlement Ticket No." = FIELD("Settlement No.");
                column(Production_Lot_No; "Production Lot No.")
                {
                }
                column(Settlement_Ticket_No; "Settlement Ticket No.")
                {
                }
                column(Grower_Ticket_No; "Grower Ticket No.")
                {
                }
                column(Quantity_Applied; "Quantity Applied")
                {
                }
                column(Prepay_No; "Prepay No.")
                {
                }
                column(Prepay_Settlement_Consumed; "Prepay Consumed")
                {
                }
                dataitem("Grower Ticket"; "Grower Ticket")
                {
                    DataItemLink = "Grower Ticket No." = FIELD("Grower Ticket No.");
                    column(Scale_Ticket_No; "Scale Ticket No.")
                    {
                    }
                    column(Receipt_Date; Format("Receipt Date", 0, 1))
                    {
                    }
                    column(Posting_Date; "Posting Date")
                    {
                    }
                    column(Gross_Qty_in_Purchase_UOM; "Gross Qty in Purchase UOM")
                    {
                    }
                    column(Shrink_Qty_per_UOM; "Shrink Qty per UOM")
                    {
                    }
                    column(Net_Qty_in_Purchase_UOM; "Net Qty in Purchase UOM")
                    {
                    }
                    column(Total_Premi_Disc_per_UOM; "Total Premi / Disc per UOM")
                    {
                    }
                    column(Settled_Quantity; "Settled Quantity")
                    {
                    }
                    column(Remaining_Quantity; "Remaining Quantity")
                    {
                    }
                    column(Item_No; "Item No.")
                    {
                    }
                    column(Gross_Settlement_Amount; GrossSettlementAmount)
                    {
                    }
                    dataitem("Scale Ticket Header"; "Scale Ticket Header")
                    {
                        DataItemLink = "Scale Ticket No." = FIELD("Scale Ticket No.");
                        column(Paper_Scale_Ticket_No; "Paper Scale Ticket No.")
                        {
                        }
                        column(Moisture_Test_Result; "Moisture Test Result")
                        {
                        }
                        column(Moisture_Discount_per_UOM; "Moisture Discount per UOM")
                        {
                        }
                        column(Shrink_Percent; "Shrink %")
                        {
                        }
                        column(Splits_Test_Result; "Splits Test Result")
                        {
                        }
                        column(Splits_Premium_per_UOM; "Splits Premium per UOM")
                        {
                        }
                        column(Test_Weight_Result; "Test Weight Result")
                        {
                        }
                        column(Test_Weight_Discount_per_UOM; "Test Weight Discount per UOM")
                        {
                        }
                        column(Vomitoxin_Test_Result; "Vomitoxin Test Result")
                        {
                        }
                        column(Vomitoxin_Discount_per_UOM; "Vomitoxin Discount per UOM")
                        {
                        }
                        dataitem("Production Lot"; "Production Lot")
                        {
                            DataItemLink = "Production Lot No." = FIELD("Production Lot No.");
                            column(Purchase_UOM; "Purchase UOM")
                            {
                            }
                            column(Comm_Settle_Premium_per_UOM; "Commodity Premium per UOM")
                            {
                            }
                            column(Cropping_Practice_Code; "Cropping Practice Code")
                            {
                            }
                            column(Cropping_Premium_per_UOM; "Cropping Premium per UOM")
                            {
                            }
                            column(Add_Settle_Premium_per_UOM; "Additional Premium per UOM")
                            {
                            }
                            column(Out_of_Zone_Premium_per_UOM; "Out of Zone Premium per UOM")
                            {
                            }
                            column(Checkoff_Percent; "Check off %")
                            {
                            }
                            column(Checkoff_Amount; CheckoffAmount)
                            {
                            }
                            column(Net_Settlement_Amount; NetSettlementAmount)
                            {
                            }
                            dataitem(Vendor; Vendor)
                            {
                                DataItemLink = "No." = FIELD("Vendor No.");
                                DataItemLinkReference = "Settlement-Prepayment Ticket";
                                PrintOnlyIfDetail = false;
                                column(VendorNo; Vendor."No.")
                                {
                                }
                                column(Vendor_Name; Vendor.Name)
                                {
                                }
                                column(Vendor_Address; Vendor.Address)
                                {
                                }
                                column(Vendor_City; Vendor.City)
                                {
                                }
                                column(Vendor_State; Vendor.County)
                                {
                                }
                                column(Vendor_Zip; Vendor."Post Code")
                                {
                                }
                                dataitem("Company Information"; "Company Information")
                                {
                                    PrintOnlyIfDetail = false;
                                    column(Company_Name; "Company Information".Name)
                                    {
                                    }
                                    column(Company_Address; "Company Information".Address)
                                    {
                                    }
                                    column(Company_City; "Company Information".City)
                                    {
                                    }
                                    column(Company_State; "Company Information".County)
                                    {
                                    }
                                    column(Company_Zip; "Company Information"."Post Code")
                                    {
                                    }
                                }
                            }

                            trigger OnAfterGetRecord()
                            begin
                                GrossSettlementAmount := Round((("Settlement-Prepayment Ticket"."Base Settlement Price" + "Grower Ticket"."Total Premi / Disc per UOM") *
                                                            "Settlement Applied Amounts"."Quantity Applied"), 0.01, '=');
                                CheckoffAmount := Round(("Settlement Applied Amounts"."Quantity Applied" *
                                                            ("Settlement-Prepayment Ticket"."Base Settlement Price" * ("Check off %" / 100))), 0.01, '=');
                                NetSettlementAmount := GrossSettlementAmount - CheckoffAmount;
                            end;
                        }
                    }
                }
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

    trigger OnPreReport()
    begin
        SettlementDateFilter := "Settlement-Prepayment Ticket".GETFILTER("Settlement Date")
    end;

    var
        GrossSettlementAmount: Decimal;
        CheckoffAmount: Decimal;
        NetSettlementAmount: Decimal;
        SettlementDateFilter: Text;
}

