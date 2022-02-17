report 50032 "Pick Ticket per Purch Ret"
{
    // //Orig: 50018
    // Added Pick No. in the Options page
    // //SOC-SC 07-06-15
    // //RSI-KS 07-20-15
    //   add Payment Method
    // //RSI-KS 10-05-16
    //   add Customer Price group so that dealer pricing wouldn't print on pick ticket - report looks for DLR in the price group code
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PickTicketperPurRet.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Pick Ticket Per Purch Ret';

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING(Type, "No.") WHERE(Type = CONST(Pick));
            RequestFilterFields = "No.";
            dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
            {
                DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING("Activity Type", "No.", "Location Code", "Source Document", "Source No.", "Action Type", "Zone Code") WHERE("Action Type" = FILTER(" " | Take));
                PrintOnlyIfDetail = true;
                column(PickNo; "Warehouse Activity Line"."No.")
                {
                }
                column(WarehouseShipment; "Warehouse Activity Line"."Whse. Document No.")
                {
                }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = FIELD("Location Code");
                    DataItemTableView = SORTING(Code);
                    PrintOnlyIfDetail = true;

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
                dataitem("Purchase Header"; "Purchase Header")
                {
                    DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                    DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
                    PrintOnlyIfDetail = true;
                    RequestFilterFields = "No.", "Sell-to Customer No.";
                    column(Sales_Header_Document_Type; "Document Type")
                    {
                    }
                    column(Sales_Header_No_; "No.")
                    {
                    }
                    column(PickAmount; gdPickAmount)
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
                                column(Sales_Header___No__; "Purchase Header"."No.")
                                {
                                }
                                column(Sales_Header___Order_Date_; "Purchase Header"."Order Date")
                                {
                                }
                                column(Sales_Header___Sell_to_Customer_No__; "Purchase Header"."Pay-to Vendor No.")
                                {
                                }
                                column(ShipPhoneNo; "Purchase Header"."Ship-to Phone No. -CL-")
                                {
                                }
                                column(ShipContact; "Purchase Header"."Pay-to Contact")
                                {
                                }
                                column(SalespersonID; "Purchase Header"."Purchaser Code")
                                {
                                }
                                column(Country; "Purchase Header"."Ship-to Country/Region Code")
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
                                column(Sales_Header___Shipment_Date_; "Purchase Header"."Order Date")
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
                                column(ShipmentMethod_Description; ShipmentAgent.Name)
                                {
                                }
                                column(PaymentTerms_Description; PaymentTerms.Description)
                                {
                                }
                                column(PaymentMethod_Description; PaymentMethod.Description)
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
                                column(Sales_Line__Quantity_Shipped_Caption; "Purchase Line".FieldCaption(Quantity))
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
                                column(Sales_Line__Unit_of_Measure_Caption; "Purchase Line".FieldCaption("Unit of Measure"))
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
                                column(CreatedBy; "Purchase Header"."Created By")
                                {
                                }
                                column(txtReprint; gsReprint)
                                {
                                }
                                column(EmailAddress; gsEmail)
                                {
                                }
                                column(eShipService; "Purchase Header"."E-Ship Agent Service")
                                {
                                }
                                dataitem("Purchase Line"; "Purchase Line")
                                {
                                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                                    DataItemLinkReference = "Purchase Header";
                                    DataItemTableView = SORTING("Document Type", "Document No.", "No.") WHERE(Type = FILTER(Item), "Outstanding Quantity" = FILTER(> 0));
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
                                        DecimalPlaces = 0 : 5;
                                    }
                                    column(Sales_Line__Quantity_Shipped_; "Return Qty. Shipped")
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
                                    column(Sales_Line_LocationCode; "Purchase Line"."Location Code")
                                    {
                                    }
                                    column(Sales_Line_ItemNo; "Purchase Line"."No.")
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
                                    column(PickQty; gdPickQty)
                                    {
                                    }
                                    dataitem("Line Comments"; "Purch. Comment Line")
                                    {
                                        DataItemLink = "No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "Document Line No." = FIELD("Line No.");
                                        DataItemLinkReference = "Purchase Line";
                                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order));
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
                                    dataitem(tmpComments; "Purch. Comment Line")
                                    {
                                        DataItemLink = "No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "Document Line No." = FIELD("Line No.");
                                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order));
                                        UseTemporary = true;
                                        column(tmpOrderNo; tmpComments."No.")
                                        {
                                        }
                                        column(tmpDocLineNo; tmpComments."Document Line No.")
                                        {
                                        }
                                        column(tmpLineNo; tmpComments."Line No.")
                                        {
                                        }
                                        column(tmpComment; tmpComments.Comment)
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
                                    var
                                        recWAL: Record "Warehouse Activity Line";
                                    begin
                                        Item.Get("No.");
                                        if Item."Item Tracking Code" <> '' then
                                            with TrackSpec2 do begin
                                                SetCurrentKey(
                                                  "Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
                                                SetRange("Source Type", DATABASE::"Sales Line");
                                                SetRange("Source Subtype", "Purchase Line"."Document Type");
                                                SetRange("Source ID", "Purchase Line"."Document No.");
                                                SetRange("Source Ref. No.", "Purchase Line"."Line No.");
                                                AnySerialNos := FindFirst;
                                            end
                                        else
                                            AnySerialNos := false;

                                        gdPickQty := 0;
                                        recWAL.Reset();
                                        recWAL.SetRange("Activity Type", "Warehouse Activity Line"."Activity Type");
                                        recWAL.SetRange("No.", "Warehouse Activity Line"."No.");
                                        recWAL.SetRange("Source Type", "Warehouse Activity Line"."Source Type");
                                        recWAL.SetRange("Source Subtype", "Document Type"); //"Warehouse Activity Line"."Source Subtype");
                                        recWAL.SetRange("Source No.", "Document No.");
                                        recWAL.SetRange("Source Line No.", "Line No.");
                                        recWAL.SetFilter("Action Type", '%1|%2', recWAL."Action Type"::" ", recWAL."Action Type"::Take);
                                        if recWAL.FindSet() then begin
                                            recWAL.CalcSums("Qty. Outstanding");
                                            gdPickQty := recWAL."Qty. Outstanding";
                                        end;
                                        //gdPickAmount += gdPickQty * "Unit Price";
                                    end;

                                    trigger OnPreDataItem()
                                    begin
                                        SetRange("Location Code", TempLocation.Code);
                                        //SETRANGE("Line No.", "Warehouse Activity Line"."Source Line No."); //SOC-SC 07-06-15
                                    end;
                                }
                            }
                            dataitem("Purch. Comment Line"; "Purch. Comment Line")
                            {
                                DataItemLink = "No." = FIELD("No."), "Document Type" = FIELD("Document Type");
                                DataItemLinkReference = "Purchase Header";
                                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Line No." = FILTER(0));
                                PrintOnlyIfDetail = true;
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

                            trigger OnAfterGetRecord()
                            begin
                                CurrReport.PageNo := 1;

                                // gdPickAmount := GetTotals("Sales Header"."No.");  //SOC-MA 08-03-15
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
                    var
                        RuppWhseMgt: Codeunit "Rupp Warehouse Mgt";
                    begin
                        GetLineComments("No.");

                        gsCountry := '';

                        if "Purchaser Code" = '' then
                            Clear(SalesPurchPerson)
                        else
                            SalesPurchPerson.Get("Purchaser Code");

                        if "E-Ship Agent Code" = '' then
                            Clear(ShipmentAgent)
                        else
                            if "E-Ship Agent Code" = 'UPS' then
                                ShipmentAgent.Name := "E-Ship Agent Code" + '-' + "E-Ship Agent Service"
                            else
                                ShipmentAgent.Get("E-Ship Agent Code");

                        if "Payment Terms Code" = '' then
                            Clear(PaymentTerms)
                        else
                            PaymentTerms.Get("Payment Terms Code");

                        if "Payment Method Code" = '' then
                            Clear(PaymentMethod)
                        else
                            PaymentMethod.Get("Payment Method Code");


                        recCompanyInfo.Get();

                        FormatAddress.FormatAddr(CompanyAddress, recCompanyInfo.Name, recCompanyInfo."Name 2", '', recCompanyInfo.Address, recCompanyInfo."Address 2",
                                                  recCompanyInfo.City, recCompanyInfo."Post Code", recCompanyInfo.County, recCompanyInfo."Country/Region Code");


                        CompanyAddress[6] := recCompanyInfo."Phone No.";
                        CompanyAddress[7] := recCompanyInfo."Fax No.";
                        CompanyAddress[8] := recCompanyInfo."Home Page";

                        CompressArray(CompanyAddress);

                        FormatAddress.PurchHeaderBuyFrom(Address, "Purchase Header");
                        FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

                        if "Purchase Header"."Ship-to Country/Region Code" = 'CA' then
                            gsCountry := 'CANADA';

                        gsShippingMethod := "Purchase Header"."E-Ship Agent Code" + ' ' + "Purchase Header"."E-Ship Agent Service";
                        PrintFooter := false;
                        CurrReport.PageNo := 1;

                        gdPickAmount := GetTotals("Purchase Header"."No.");
                        gsEmail := GetEmail("Purchase Header");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Source Document" = giPrevSrcDoc) and (gcPrevSrcNo = "Source No.") then begin
                        CurrReport.Skip();
                    end else begin
                        if "Source Document" <> "Source Document"::"Sales Order" then begin
                            CurrReport.Skip();
                        end;
                    end;
                    gcPrevSrcNo := "Source No.";
                    giPrevSrcDoc := "Source Document";

                    TempLocation.Reset();
                    TempLocation.DeleteAll();
                end;

                trigger OnPreDataItem()
                begin
                    if gcSalesHdrNo <> '' then
                        SetRange("Source No.", gcSalesHdrNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not CurrReport.Preview then
                    if "Warehouse Activity Header"."Date of Last Printing" = 0D then begin
                        "Warehouse Activity Header".Validate("Date of Last Printing", Today);
                        "Warehouse Activity Header".Validate("Time of Last Printing", Time);
                        "Warehouse Activity Header".Modify;
                    end else
                        gsReprint := 'REPRINT';
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
        gsReprint := '';
    end;

    var
        ShipmentAgent: Record "Shipping Agent";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
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
        gsPickNo: Text[20];
        giPrevSrcDoc: Integer;
        gcPrevSrcNo: Code[20];
        gcSalesHdrNo: Code[20];
        gsCreditCardAuthNo: Code[30];
        gsCreditCardAuthNoCaption: Text[30];
        gdPickAmount: Decimal;
        gdPickQty: Decimal;
        gsOrderNum: Text;
        gsReprint: Text;
        recSalesLine: Record "Sales Line";
        gsEmail: Text[100];

    [Scope('Internal')]
    procedure AnySalesLinesThisLocation(LocationCode: Code[10]): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        with SalesLine2 do begin
            SetCurrentKey(Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type");
            SetRange("Document Type", "Purchase Header"."Document Type");
            SetRange("Document No.", "Purchase Header"."No.");
            SetRange("Location Code", LocationCode);
            SetRange(Type, Type::Item);
            exit(FindFirst);
        end;
    end;

    [Scope('Internal')]
    procedure SetSalesHdrNo(cSalesHdrNo: Code[20])
    begin
        gcSalesHdrNo := cSalesHdrNo;
    end;

    local procedure GetTotals(OrderNumber: Text) ShipTotal: Decimal
    var
        recSalesLine: Record "Purchase Line";
        recWHActLine: Record "Warehouse Activity Line";
        PickQty: Decimal;
    begin
        recSalesLine.SetFilter("Document No.", OrderNumber);
        if recSalesLine.FindSet() then begin
            repeat
                PickQty := 0;
                recWHActLine.Reset();
                recWHActLine.SetRange("Activity Type", "Warehouse Activity Line"."Activity Type");
                recWHActLine.SetRange("No.", "Warehouse Activity Line"."No.");
                recWHActLine.SetRange("Source Type", "Warehouse Activity Line"."Source Type");
                recWHActLine.SetRange("Source Subtype", recSalesLine."Document Type"); //"Warehouse Activity Line"."Source Subtype");
                recWHActLine.SetRange("Source No.", recSalesLine."Document No.");
                recWHActLine.SetRange("Source Line No.", recSalesLine."Line No.");
                recWHActLine.SetFilter("Action Type", '%1|%2', recWHActLine."Action Type"::" ", recWHActLine."Action Type"::Take);
                if recWHActLine.FindSet() then begin
                    recWHActLine.CalcSums("Qty. Outstanding");
                    PickQty := recWHActLine."Qty. Outstanding";
                end;
                ShipTotal += PickQty * recSalesLine."Unit Price (LCY)";
            until recSalesLine.Next = 0;
        end;
        exit(ShipTotal);
    end;

    local procedure GetLineComments(OrderNum: Code[20])
    var
        LineNo: Integer;
    begin
        tmpComments.DeleteAll;

        recSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        recSalesLine.SetFilter("Document Type", '%1', recSalesLine."Document Type"::Order);
        recSalesLine.SetFilter("Document No.", OrderNum);
        LineNo := 0;

        with recSalesLine do begin
            if FindSet() then begin
                repeat
                    case Type of
                        Type::Item:
                            if ("Outstanding Quantity" > 0) or
                                ("No." = '') then
                                LineNo := "Line No."
                            else
                                LineNo := 0;
                        Type::" ":
                            begin
                                tmpComments.Reset;
                                tmpComments."Document Type" := "Document Type";
                                tmpComments."No." := OrderNum;
                                tmpComments."Line No." := "Line No.";
                                tmpComments.Code := 'Notes';
                                tmpComments.Comment := Description;
                                tmpComments."Document Line No." := LineNo;
                                tmpComments.Insert;
                            end;
                    end;
                until recSalesLine.Next = 0;
            end;
        end;
    end;

    local procedure GetEmail(recHeader: Record "Purchase Header") gsEmail: Text[100]
    var
        recEmail: Record "E-Mail List Entry";
    begin

        Clear(gsEmail);
        recEmail.SetFilter("Table ID", '%1', DATABASE::"Sales Header");
        recEmail.SetFilter(Type, '%1', recHeader."Document Type");
        recEmail.SetFilter(Code, recHeader."No.");

        if recEmail.FindSet then begin
            gsEmail := recEmail."E-Mail";
            exit;
        end;

        recEmail.Reset;
        recEmail.SetFilter("Table ID", '%1', DATABASE::Customer);
        recEmail.SetFilter(Code, recHeader."Sell-to Customer No.");

        if recEmail.FindSet then
            gsEmail := recEmail."E-Mail";
    end;
}

