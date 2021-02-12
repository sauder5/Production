report 50018 "Picking List by Order Rupp"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PickingListbyOrderRupp.rdlc';
    Caption = 'Picking List by Order';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Location; Location)
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                TempLocation := Location;
                TempLocation.Insert;
            end;

            trigger OnPreDataItem()
            begin
                TempLocation.Code := '';
                TempLocation.Name := Text000;
                TempLocation.Insert;
                if not ReadPermission then
                    CurrReport.Break;
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            dataitem(LocationLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(CopyNo; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    dataitem(PageLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(CompanyInfo2_Picture; CompanyInfo2.Picture)
                        {
                        }
                        column(CompanyInfo1_Picture; CompanyInfo1.Picture)
                        {
                        }
                        column(CompanyInfo_Picture; CompanyInfo.Picture)
                        {
                        }
                        column(CompanyAddress1; CompanyAddress[1])
                        {
                        }
                        column(CompanyAddress2; CompanyAddress[2])
                        {
                        }
                        column(CompanyAddress3; CompanyAddress[3])
                        {
                        }
                        column(CompanyAddress4; CompanyAddress[4])
                        {
                        }
                        column(CompanyAddress5; CompanyAddress[5])
                        {
                        }
                        column(CompanyAddress6; CompanyAddress[6])
                        {
                        }
                        column(CompanyAddress7; CompanyAddress[7])
                        {
                        }
                        column(CompanyAddress8; CompanyAddress[8])
                        {
                        }
                        column(CurrReport_PAGENO; CurrReport.PageNo)
                        {
                        }
                        column(Sales_Header___No__; "Sales Header"."No.")
                        {
                        }
                        column(Sales_Header___Order_Date_; "Sales Header"."Order Date")
                        {
                        }
                        column(Sales_Header___Sell_to_Customer_No__; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipPhoneNo; "Sales Header"."Ship-to Phone No. -CL-")
                        {
                        }
                        column(ShipContact; "Sales Header"."Ship-to Contact")
                        {
                        }
                        column(PurchaseOrderNo; "Sales Header"."External Document No.")
                        {
                        }
                        column(SalespersonID; "Sales Header"."Salesperson Code")
                        {
                        }
                        column(Country; "Sales Header"."Ship-to Country/Region Code")
                        {
                        }
                        column(ShippingMethod; gsShippingMethod)
                        {
                        }
                        column(Canada; gsCountry)
                        {
                        }
                        column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                        {
                        }
                        column(ShipToAddress_1_; ShipToAddress[1])
                        {
                        }
                        column(ShipToAddress_2_; ShipToAddress[2])
                        {
                        }
                        column(ShipToAddress_3_; ShipToAddress[3])
                        {
                        }
                        column(ShipToAddress_4_; ShipToAddress[4])
                        {
                        }
                        column(ShipToAddress_5_; ShipToAddress[5])
                        {
                        }
                        column(ShipToAddress_6_; ShipToAddress[6])
                        {
                        }
                        column(ShipToAddress_7_; ShipToAddress[7])
                        {
                        }
                        column(Sales_Header___Shipment_Date_; "Sales Header"."Shipment Date")
                        {
                        }
                        column(Address_1_; Address[1])
                        {
                        }
                        column(Address_2_; Address[2])
                        {
                        }
                        column(Address_3_; Address[3])
                        {
                        }
                        column(Address_4_; Address[4])
                        {
                        }
                        column(Address_5_; Address[5])
                        {
                        }
                        column(Address_6_; Address[6])
                        {
                        }
                        column(Address_7_; Address[7])
                        {
                        }
                        column(ShipmentMethod_Description; ShipmentMethod.Description)
                        {
                        }
                        column(PaymentTerms_Description; PaymentTerms.Description)
                        {
                        }
                        column(TempLocation_Code; TempLocation.Code)
                        {
                        }
                        column(myCopyNo; CopyNo.Number)
                        {
                        }
                        column(LocationLoop_Number; LocationLoop.Number)
                        {
                        }
                        column(PageLoop_Number; Number)
                        {
                        }
                        column(EmptyStringCaption; EmptyStringCaptionLbl)
                        {
                        }
                        column(Sales_Header___Order_Date_Caption; Sales_Header___Order_Date_CaptionLbl)
                        {
                        }
                        column(Sales_Header___No__Caption; Sales_Header___No__CaptionLbl)
                        {
                        }
                        column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                        {
                        }
                        column(Sales_Line__Outstanding_Quantity_Caption; Sales_Line__Outstanding_Quantity_CaptionLbl)
                        {
                        }
                        column(Sales_Line__Quantity_Shipped_Caption; "Sales Line".FieldCaption("Quantity Shipped"))
                        {
                        }
                        column(Sales_Header___Sell_to_Customer_No__Caption; Sales_Header___Sell_to_Customer_No__CaptionLbl)
                        {
                        }
                        column(Sales_Header___Shipment_Date_Caption; Sales_Header___Shipment_Date_CaptionLbl)
                        {
                        }
                        column(SalesPurchPerson_NameCaption; SalesPurchPerson_NameCaptionLbl)
                        {
                        }
                        column(Sales_Line_QuantityCaption; Sales_Line_QuantityCaptionLbl)
                        {
                        }
                        column(Ship_To_Caption; Ship_To_CaptionLbl)
                        {
                        }
                        column(Sales_Line__Unit_of_Measure_Caption; "Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Picking_List_by_OrderCaption; Picking_List_by_OrderCaptionLbl)
                        {
                        }
                        column(Sales_Line__No__Caption; Sales_Line__No__CaptionLbl)
                        {
                        }
                        column(ShipmentMethod_DescriptionCaption; ShipmentMethod_DescriptionCaptionLbl)
                        {
                        }
                        column(PaymentTerms_DescriptionCaption; PaymentTerms_DescriptionCaptionLbl)
                        {
                        }
                        column(Item__Shelf_No__Caption; Item__Shelf_No__CaptionLbl)
                        {
                        }
                        column(TempLocation_CodeCaption; TempLocation_CodeCaptionLbl)
                        {
                        }
                        column(Sold_To_Caption; Sold_To_CaptionLbl)
                        {
                        }
                        dataitem("Sales Line"; "Sales Line")
                        {
                            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                            DataItemLinkReference = "Sales Header";
                            DataItemTableView = SORTING("Document Type", "Document No.", "No.") WHERE(Type = CONST(Item), "Outstanding Quantity" = FILTER(<> 0));
                            RequestFilterFields = "Shipment Date";
                            column(Item__Shelf_No__; Item."Shelf No.")
                            {
                            }
                            column(Sales_Line__No__; "No.")
                            {
                            }
                            column(Sales_Line__Unit_of_Measure_; "Unit of Measure")
                            {
                            }
                            column(Sales_Line_Quantity; Quantity)
                            {
                                DecimalPlaces = 2 : 5;
                            }
                            column(Sales_Line__Quantity_Shipped_; "Quantity Shipped")
                            {
                                DecimalPlaces = 2 : 5;
                            }
                            column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
                            {
                                DecimalPlaces = 2 : 5;
                            }
                            column(Sales_Line_Description; Description)
                            {
                            }
                            column(Sales_Line_LocationCode; "Sales Line"."Location Code")
                            {
                            }
                            column(Sales_Line_ItemNo; "Sales Line"."No.")
                            {
                            }
                            column(ItemType; Item."Generic Name Code")
                            {
                            }
                            column(ItemDesc; Item.Description)
                            {
                            }
                            column(EmptyString; '')
                            {
                            }
                            column(Sales_Line__Variant_Code_; "Variant Code")
                            {
                            }
                            column(myAnySerialNos; AnySerialNos)
                            {
                            }
                            column(Sales_Line_Document_Type; "Document Type")
                            {
                            }
                            column(Sales_Line_Document_No_; "Document No.")
                            {
                            }
                            column(Sales_Line_Line_No_; "Line No.")
                            {
                            }
                            dataitem("Line Comments"; "Sales Comment Line")
                            {
                                DataItemLink = "No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "Document Line No." = FIELD("Line No.");
                                DataItemLinkReference = "Sales Line";
                                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order), "Print On Pick Ticket" = CONST(true));
                                column(Line_Comment; Comment)
                                {
                                }
                                column(Line_Document_Type; "Document Type")
                                {
                                }
                                column(Line_No_; "No.")
                                {
                                }
                                column(Document_Line_No_; "Document Line No.")
                                {
                                }
                                column(Line_Line_No_; "Line No.")
                                {
                                }
                            }
                            dataitem("Tracking Specification"; "Tracking Specification")
                            {
                                DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                                DataItemTableView = SORTING("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.") WHERE("Source Type" = CONST(37), "Source Subtype" = CONST("1"));
                                column(Tracking_Specification__Serial_No__; "Serial No.")
                                {
                                }
                                column(Tracking_Specification_Entry_No_; "Entry No.")
                                {
                                }
                                column(Tracking_Specification_Source_ID; "Source ID")
                                {
                                }
                                column(Tracking_Specification_Source_Ref__No_; "Source Ref. No.")
                                {
                                }
                                column(Tracking_Specification__Serial_No__Caption; FieldCaption("Serial No."))
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    if "Serial No." = '' then
                                        "Serial No." := "Lot No.";
                                end;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                Item.Get("No.");
                                if Item."Item Tracking Code" <> '' then
                                    with TrackSpec2 do begin
                                        SetCurrentKey(
                                          "Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
                                        SetRange("Source Type", DATABASE::"Sales Line");
                                        SetRange("Source Subtype", "Sales Line"."Document Type");
                                        SetRange("Source ID", "Sales Line"."Document No.");
                                        SetRange("Source Ref. No.", "Sales Line"."Line No.");
                                        AnySerialNos := FindFirst;
                                    end
                                else
                                    AnySerialNos := false;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange("Location Code", TempLocation.Code);
                            end;
                        }
                        dataitem("Sales Comment Line"; "Sales Comment Line")
                        {
                            DataItemLink = "No." = FIELD("No.");
                            DataItemLinkReference = "Sales Header";
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order), "Print On Pick Ticket" = CONST(true), "Document Line No." = CONST(0));
                            column(Sales_Comment_Line_Comment; Comment)
                            {
                            }
                            column(Sales_Comment_Line_Document_Type; "Document Type")
                            {
                            }
                            column(Sales_Comment_Line_No_; "No.")
                            {
                            }
                            column(Sales_Comment_Line_Document_Line_No_; "Document Line No.")
                            {
                            }
                            column(Sales_Comment_Line_Line_No_; "Line No.")
                            {
                            }
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.PageNo := 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, 1 + Abs(NoCopies));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempLocation.Find('-')
                    else
                        TempLocation.Next;

                    if not AnySalesLinesThisLocation(TempLocation.Code) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempLocation.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gsCountry := '';

                if "Salesperson Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Salesperson Code");

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else
                    ShipmentMethod.Get("Shipment Method Code");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else
                    PaymentTerms.Get("Payment Terms Code");

                recCompanyInfo.Get();

                FormatAddress.FormatAddr(CompanyAddress, recCompanyInfo.Name, recCompanyInfo."Name 2", '', recCompanyInfo.Address, recCompanyInfo."Address 2",
                                          recCompanyInfo.City, recCompanyInfo."Post Code", recCompanyInfo.County, recCompanyInfo."Country/Region Code");


                CompanyAddress[6] := recCompanyInfo."Phone No.";
                CompanyAddress[7] := recCompanyInfo."Fax No.";
                CompanyAddress[8] := recCompanyInfo."Home Page";

                CompressArray(CompanyAddress);

                FormatAddress.SalesHeaderBillTo(Address, "Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");

                if "Sales Header"."Ship-to Country/Region Code" = 'CA' then
                    gsCountry := 'CANADA';

                gsShippingMethod := "Sales Header"."Shipping Agent Code" + ' ' + "Sales Header"."E-Ship Agent Service";

                PrintFooter := false;
                CurrReport.PageNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                        MaxValue = 9;
                        MinValue = 0;
                    }
                }
            }
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
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo.Get;
                    CompanyInfo.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        Item: Record Item;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempLocation: Record Location temporary;
        TrackSpec2: Record "Tracking Specification";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        Address: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        PrintFooter: Boolean;
        AnySerialNos: Boolean;
        NoCopies: Integer;
        Text000: Label 'No Location Code';
        EmptyStringCaptionLbl: Label 'Picked';
        Sales_Header___Order_Date_CaptionLbl: Label 'Order Date:';
        Sales_Header___No__CaptionLbl: Label 'Order Number:';
        CurrReport_PAGENOCaptionLbl: Label 'Page:';
        Sales_Line__Outstanding_Quantity_CaptionLbl: Label 'Back Ordered';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No:';
        Sales_Header___Shipment_Date_CaptionLbl: Label 'Shipment Date:';
        SalesPurchPerson_NameCaptionLbl: Label 'Salesperson:';
        Sales_Line_QuantityCaptionLbl: Label 'Quantity Ordered';
        Ship_To_CaptionLbl: Label 'Ship To:';
        Picking_List_by_OrderCaptionLbl: Label 'Picking List by Order';
        Sales_Line__No__CaptionLbl: Label 'Item No.';
        ShipmentMethod_DescriptionCaptionLbl: Label 'Ship Via:';
        PaymentTerms_DescriptionCaptionLbl: Label 'Terms:';
        Item__Shelf_No__CaptionLbl: Label 'Shelf/Bin No.';
        TempLocation_CodeCaptionLbl: Label 'Location:';
        Sold_To_CaptionLbl: Label 'Sold To:';
        recCompanyInfo: Record "Company Information";
        CompanyAddress: array[8] of Text[50];
        gsShippingMethod: Text[100];
        gsCountry: Text[20];

    [Scope('Internal')]
    procedure AnySalesLinesThisLocation(LocationCode: Code[10]): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        with SalesLine2 do begin
            SetCurrentKey(Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type");
            SetRange("Document Type", "Sales Header"."Document Type");
            SetRange("Document No.", "Sales Header"."No.");
            SetRange("Location Code", LocationCode);
            SetRange(Type, Type::Item);
            exit(FindFirst);
        end;
    end;
}

