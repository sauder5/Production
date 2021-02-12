report 50072 "Order Cancellation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/OrderCancellation.rdlc';
    Caption = 'Order Cancellation';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Product Code", "Inventory Status Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(SalesLineFilter; SalesLineFilter)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter; Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Sales_Line__TABLECAPTION__________SalesLineFilter; "Sales Line".TableCaption + ': ' + SalesLineFilter)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item_Inventory; Inventory)
            {
                DecimalPlaces = 2 : 5;
            }
            column(Item_Location_Filter; "Location Filter")
            {
            }
            column(Item_Variant_Filter; "Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Back_Order_Fill_by_ItemCaption; Back_Order_Fill_by_ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Document_No__Caption; "Sales Line".FieldCaption("Document No."))
            {
            }
            column(Cust_NameCaption; Cust_NameCaptionLbl)
            {
            }
            column(Cust__Phone_No__Caption; Cust__Phone_No__CaptionLbl)
            {
            }
            column(Sales_Line__Shipment_Date_Caption; "Sales Line".FieldCaption("Shipment Date"))
            {
            }
            column(Sales_Line_QuantityCaption; "Sales Line".FieldCaption(Quantity))
            {
            }
            column(Sales_Line__Outstanding_Quantity_Caption; "Sales Line".FieldCaption("Outstanding Quantity"))
            {
            }
            column(OtherBackOrdersCaption; OtherBackOrdersCaptionLbl)
            {
            }
            column(Sales_Line__Sell_to_Customer_No__Caption; "Sales Line".FieldCaption("Sell-to Customer No."))
            {
            }
            column(Item__No__Caption; Item__No__CaptionLbl)
            {
            }
            column(Item_InventoryCaption; FieldCaption(Inventory))
            {
            }
            column(Item_Inventory_StatusCode; "Inventory Status Code")
            {
            }
            column(Item_ProductCode; "Product Code")
            {
            }
            column(Item_ProductCode_Caption; Item_ProductCodeLbl)
            {
            }
            column(Item_InvStatCode_Caption; Item_InvStatCodeLbl)
            {
            }
            column(Item_Description_Caption; Item_DescriptionLbl)
            {
            }
            column(Date_Caption; DateLbl)
            {
            }
            column(Item_BOUM; "Base Unit of Measure")
            {
            }
            column(UOM_Caption; UOMLbl)
            {
            }
            column(Price_Caption; PriceLbl)
            {
            }
            column(InvStatCode_Desc; InvStatCodeDesc)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date") WHERE(Type = CONST(Item), "Document Type" = CONST(Order), "Inventory Status Action" = CONST(Cancel));
                RequestFilterFields = "Sell-to Customer No.";
                RequestFilterHeading = 'Sales Order Line';
                column(Sales_Line__Document_No__; "Document No.")
                {
                }
                column(Cust_Name; Cust.Name)
                {
                }
                column(Cust__Phone_No__; Cust."Phone No.")
                {
                }
                column(Sales_Line__Shipment_Date_; "Shipment Date")
                {
                }
                column(Sales_Line_Quantity; Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(OtherBackOrders; OtherBackOrders)
                {
                }
                column(Sales_Line__Sell_to_Customer_No__; "Sell-to Customer No.")
                {
                }
                column(Text000_________FIELDCAPTION__Outstanding_Quantity__; Text000 + ' ' + FieldCaption(Quantity))
                {
                }
                column(Sales_Line__Outstanding_Quantity__Control26; "Outstanding Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Item__No___Control29; Item."No.")
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
                column(Sales_Line_No_; "No.")
                {
                }
                column(Sales_Line_Location_Code; "Location Code")
                {
                }
                column(Sales_Line_Variant_Code; "Variant Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {
                }
                column(Cust_No; Cust."No.")
                {
                }
                column(Sales_Line_Price; "Line Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Cust.Get("Sell-to Customer No.");

                    /*SalesOrderLine.COPY("Sales Line");
                    SalesOrderLine.SETRANGE("Sell-to Customer No.",Cust."No.");
                    SalesOrderLine.SETFILTER("No.",'<>' + Item."No.");
                    OtherBackOrders := SalesOrderLine.FINDFIRST;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Outstanding Quantity");
                end;
            }
            dataitem("Comment Line"; "Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemLinkReference = Item;
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
                    /*IF giCnt < giTotalSalesLines THEN
                      CurrReport.SKIP();     */

                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CALCFIELDS(Inventory);
                if recInvStateCode.Get(recInvStateCode.Type::"Inventory Status", "Inventory Status Code") then
                    InvStatCodeDesc := recInvStateCode.Description;
            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Date Filter",0D,WORKDATE - 1);
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        ItemFilter := Item.GetFilters;
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        Cust: Record Customer;
        SalesOrderLine: Record "Sales Line";
        CompanyInformation: Record "Company Information";
        OtherBackOrders: Boolean;
        ItemFilter: Text[250];
        SalesLineFilter: Text[250];
        Text000: Label 'Total Item';
        Back_Order_Fill_by_ItemCaptionLbl: Label 'Order Cancellation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Cust_NameCaptionLbl: Label 'Customer Name';
        Cust__Phone_No__CaptionLbl: Label 'Phone No.';
        OtherBackOrdersCaptionLbl: Label 'Other Back Orders';
        Item__No__CaptionLbl: Label 'Item No.';
        Item_ProductCodeLbl: Label 'Product Code';
        Item_InvStatCodeLbl: Label 'Inventory Status Code';
        Item_DescriptionLbl: Label 'Item Description';
        DateLbl: Label 'Date';
        UOMLbl: Label 'UOM';
        PriceLbl: Label 'Price';
        recInvStateCode: Record "Rupp Reason Code";
        InvStatCodeDesc: Text[50];
}

