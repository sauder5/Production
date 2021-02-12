report 50023 "Order Cancellation-Rupp"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/OrderCancellationRupp.rdlc';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE("Inventory Status Code" = FILTER(<> ' '));
            column(ItemNo; Item."No.")
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            dataitem(CustGrouping; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Sell-to Customer No.", "Shipment No.") WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Outstanding Quantity" = FILTER(> 0), "Drop Shipment" = CONST(false), "Inventory Status Action" = CONST(Cancel));
                column(CustNo; "Sell-to Customer No.")
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(SalesLineItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Sell-to Customer No." = FIELD("Sell-to Customer No."), "No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Sell-to Customer No.", "Shipment No.") WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Outstanding Quantity" = FILTER(> 0), "Drop Shipment" = CONST(false), "Inventory Status Action" = CONST(Cancel));
                    column(OrderNo; "Sales Line"."Document No.")
                    {
                    }
                    column(ShipmentDate; "Sales Line"."Shipment Date")
                    {
                    }
                    column(OutstandingQty; "Sales Line"."Outstanding Quantity")
                    {
                    }
                    column(UOMCode; "Sales Line"."Unit of Measure Code")
                    {
                    }
                    column(UnitPrice; "Sales Line"."Unit Price")
                    {
                    }
                    column(ReasonCode; "Sales Line"."Cancelled Reason Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        recSH: Record "Sales Header";
                        FormatAddr: Codeunit "Format Address";
                        recSL: Record "Sales Line";
                    begin
                        /*IF "Sell-to Customer No." <> gsPrevCustNo THEN BEGIN
                          recSL.RESET();
                          recSL.COPYFILTERS("Sales Line");
                          recSL.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
                          giTotalSalesLinesForCust :=recSL.COUNT();
                        
                          giCnt := 0;
                          gsPrevCustNo := "Sell-to Customer No.";
                        END;
                        
                        giCnt +=1;
                        */

                    end;

                    trigger OnPreDataItem()
                    begin
                        giCnt := 0;
                    end;
                }
                dataitem("Comment Line"; "Comment Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = CustGrouping;
                    DataItemTableView = SORTING("Table Name", "No.", "Line No.") WHERE("Table Name" = CONST(Item), "Print on Cancellation Notice" = CONST(true));
                    column(CommentTableNo; "Comment Line"."Table Name")
                    {
                    }
                    column(CommentNo; "Comment Line"."No.")
                    {
                    }
                    column(CommentLineNo; "Comment Line"."Line No.")
                    {
                    }
                    column(Comment; "Comment Line".Comment)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        //IF giCnt < giTotalSalesLinesForCust THEN
                        //  CurrReport.BREAK();
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    recSH: Record "Sales Header";
                    FormatAddr: Codeunit "Format Address";
                begin
                    if "Sell-to Customer No." <> gsPrevCustNo then begin

                        gsPrevCustNo := "Sell-to Customer No.";
                        recSH.Get("Document Type", "Document No.");
                        FormatAddr.FormatAddr(CustAddr, recSH."Sell-to Customer Name", recSH."Sell-to Customer Name 2", recSH."Sell-to Contact",
                            recSH."Sell-to Address", recSH."Sell-to Address 2", recSH."Sell-to City", recSH."Sell-to Post Code",
                            recSH."Sell-to County", recSH."Sell-to Country/Region Code");

                    end else begin
                        CurrReport.Skip();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    gsPrevCustNo := '';
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

    trigger OnPreReport()
    var
        FormatAddr: Codeunit "Format Address";
        recCompanyInfo: Record "Company Information";
    begin
        recCompanyInfo.Get();
        FormatAddr.FormatAddr(CompanyAddr, recCompanyInfo.Name, recCompanyInfo."Name 2", '',
            recCompanyInfo.Address, recCompanyInfo."Address 2", recCompanyInfo.City, recCompanyInfo."Post Code",
            recCompanyInfo.County, recCompanyInfo."Country/Region Code");
    end;

    var
        giCnt: Integer;
        giTotalSalesLinesForCust: Integer;
        gsPrevCustNo: Code[20];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
}

