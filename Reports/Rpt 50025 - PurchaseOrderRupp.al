report 50025 "Purchase Order-Rupp"
{
    // //SOC-SC 08-04-15
    //   Blanked out "Buy-from Contact" and "Ship-to Contact";
    //   Added Vendor Phone No.; Show Purchaser's Phone No. if available, instead of the Company Phone No.
    //   Show Item No. on a line below, indented under description column, if there's a Cross-Reference No. entered on the PL.
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PurchaseOrderRupp.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Purchase Order';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";
            column(No_PurchaseHeader; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
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
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BuyFromAddress1; BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2; BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3; BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4; BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5; BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6; BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7; BuyFromAddress[7])
                    {
                    }
                    column(ExptRecptDt_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BuyfrVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchaseHeader; "Purchase Header"."No.")
                    {
                    }
                    column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8; BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(CompanyInformationPhoneNo; gsPhoneNo)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(VendTaxIdentificationType; Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ReceiveByCaption; ReceiveByCaptionLbl)
                    {
                    }
                    column(VendorIDCaption; VendorIDCaptionLbl)
                    {
                    }
                    column(ConfirmToCaption; ConfirmToCaptionLbl)
                    {
                    }
                    column(BuyerCaption; BuyerCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(ToCaption1; ToCaption1Lbl)
                    {
                    }
                    column(PurchOrderCaption; PurchOrderCaptionLbl)
                    {
                    }
                    column(PurchOrderNumCaption; PurchOrderNumCaptionLbl)
                    {
                    }
                    column(PurchOrderDateCaption; PurchOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(VendorPhoneNo; gsVendorPhoneNo)
                    {
                    }
                    column(ReqShipDate; "Purchase Header"."Requested Receipt Date")
                    {
                    }
                    column(ShipContact; ShipAddress.Contact)
                    {
                    }
                    column(ShipPhone; ShipAddress."Phone No.")
                    {
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), "No." = FILTER(<> 'FREIGHT'));
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint; ItemNumberToPrint)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine; "Unit of Measure")
                        {
                        }
                        column(Quantity_PurchaseLine; Quantity)
                        {
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(Description_PurchaseLine; Description)
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(InvDiscountAmt_PurchaseLine; "Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(LineAmtTaxAmtInvDiscountAmt; "Line Amount" + TaxAmount - "Inv. Discount Amount")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(DocumentNo_PurchaseLine; "Document No.")
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvDiscCaption; InvDiscCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(ItemNo; gcItemNo)
                        {
                        }
                        column(ItemDescription; gsItemDesc)
                        {
                        }
                        column(CrossReferenceNo; "Purchase Line"."Cross-Reference No.")
                        {
                        }
                        column(LineType; Type)
                        {
                        }
                        column(ShipMethod; gsShipMethod)
                        {
                        }
                        column(PmtTerms; gsTerms)
                        {
                        }
                        column(RequestedDate; "Purchase Line"."Requested Receipt Date")
                        {
                        }
                        column(ReqDateLabel; ReqDateLbl)
                        {
                        }
                        column(GenericName; gsGeneric)
                        {
                        }
                        dataitem("Purch. Comment Line"; "Purch. Comment Line")
                        {
                            DataItemLink = "No." = FIELD("Document No.");
                            DataItemLinkReference = "Purchase Line";
                            DataItemTableView = WHERE("Document Type" = CONST(Order), "Document Line No." = CONST(0));
                            column(CommentDate; Date)
                            {
                            }
                            column(CommentCode; Code)
                            {
                            }
                            column(Comment; Comment)
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        var
                            recItemCrossReference: Record "Item Cross Reference";
                            recItem: Record Item;
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            if ("Purchase Header"."Tax Area Code" <> '') and not UseExternalTaxEngine then
                                SalesTaxCalc.AddPurchLine("Purchase Line");

                            //SOC-MD
                            /*
                            IF "Vendor Item No." <> '' THEN
                              ItemNumberToPrint := "Vendor Item No."
                            ELSE
                              ItemNumberToPrint := "No.";
                            */
                            gcItemNo := '';
                            gsItemDesc := '';
                            gsGeneric := '';
                            if recItem.Get("No.") then begin
                                gsItemDesc := recItem.Description;
                                gsGeneric := recItem."Generic Name Code";
                            end;
                            if "Vendor Item No." <> '' then begin
                                ItemNumberToPrint := "Vendor Item No.";
                                gcItemNo := "No.";
                            end else begin
                                ItemNumberToPrint := "No.";
                            end;

                            //SOC-MD
                            /*
                            gcCrossRefNo    :=  '';
                            gsCrossRefDesc  :=  '';
                            
                            IF Type = "Purchase Line".Type::Item THEN BEGIN
                              recItemCrossReference.reset();
                              recItemCrossReference.setrange("Item No.","No.");
                              recItemCrossReference.setrange("Variant Code","Variant Code");
                              recItemCrossReference.setrange("Unit of Measure","Unit of Measure Code");
                              recItemCrossReference.setrange("Cross-Reference Type",recItemCrossReference."Cross-Reference Type"::Vendor);
                              recItemCrossReference.setrange("Cross-Reference Type No.","Purchase Line"."Buy-from Vendor No.");
                            
                                IF recItemCrossReference.FINDFIRST() THEN BEGIN
                                  gcCrossRefNo    :=  recItemCrossReference."Cross-Reference No.";
                                  gsCrossRefDesc  :=  recItemCrossReference.Description;
                                END;
                            END;
                            */
                            //SOC-MD
                            if Type = 0 then begin
                                ItemNumberToPrint := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                            end;

                            AmountExclInvDisc := "Line Amount";

                            if Quantity = 0 then
                                UnitPriceToPrint := 0 // so it won't print
                            else
                                UnitPriceToPrint := Round(AmountExclInvDisc / Quantity, 0.00001);

                            if OnLineNumber = NumberOfLines then begin
                                PrintFooter := true;

                                if "Purchase Header"."Tax Area Code" <> '' then begin
                                    if UseExternalTaxEngine then
                                        SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header", true)
                                    else
                                        SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                                    BrkIdx := 0;
                                    PrevPrintOrder := 0;
                                    PrevTaxPercent := 0;
                                    TaxAmount := 0;
                                    with TempSalesTaxAmtLine do begin
                                        Reset;
                                        SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                                        if Find('-') then
                                            repeat
                                                if ("Print Order" = 0) or
                                                   ("Print Order" <> PrevPrintOrder) or
                                                   ("Tax %" <> PrevTaxPercent)
                                                then begin
                                                    BrkIdx := BrkIdx + 1;
                                                    if BrkIdx > 1 then begin
                                                        if TaxArea."Country/Region" = TaxArea."Country/Region"::CA then
                                                            BreakdownTitle := Text006
                                                        else
                                                            BreakdownTitle := Text003;
                                                    end;
                                                    if BrkIdx > ArrayLen(BreakdownAmt) then begin
                                                        BrkIdx := BrkIdx - 1;
                                                        BreakdownLabel[BrkIdx] := Text004;
                                                    end else
                                                        BreakdownLabel[BrkIdx] := StrSubstNo("Print Description", "Tax %");
                                                end;
                                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                                                TaxAmount := TaxAmount + "Tax Amount";
                                            until Next = 0;
                                    end;
                                    if BrkIdx = 1 then begin
                                        Clear(BreakdownLabel);
                                        Clear(BreakdownAmt);
                                    end;
                                end;
                            end;

                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
                            NumberOfLines := Count;
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;
                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview then
                            PurchasePrinted.Run("Purchase Header");
                        CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                    TaxAmount := 0;

                    Clear(BreakdownTitle);
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
                    TotalTaxLabel := Text008;
                    if "Purchase Header"."Tax Area Code" <> '' then begin
                        TaxArea.Get("Purchase Header"."Tax Area Code");
                        case TaxArea."Country/Region" of
                            TaxArea."Country/Region"::US:
                                TotalTaxLabel := Text005;
                            TaxArea."Country/Region"::CA:
                                TotalTaxLabel := Text007;
                        end;
                        UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                        SalesTaxCalc.StartSalesTaxCalculation;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                recVendor: Record Vendor;
            begin
                if PrintCompany then
                    if RespCenter.Get("Responsibility Center") then begin
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    end;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if "Purchaser Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Purchaser Code");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    gsTerms := PaymentTerms.Description;
                end;

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    gsShipMethod := ShipmentMethod.Description;
                end;

                //SOC-SC 08-04-15
                gsPhoneNo := CompanyInformation."Phone No.";
                if SalesPurchPerson."Phone No." <> '' then begin
                    gsPhoneNo := SalesPurchPerson."Phone No.";
                end;
                "Purchase Header"."Buy-from Contact" := '';
                "Purchase Header"."Ship-to Contact" := '';
                gsVendorPhoneNo := '';
                if recVendor.Get("Buy-from Vendor No.") then begin
                    gsVendorPhoneNo := 'Vendor Phone No.: ' + recVendor."Phone No.";
                end;
                //SOC-SC 08-04-15

                //RSI-KS 09-25-15
                if "Purchase Header"."Receiving Address Code" = '' then
                    Clear(ShipAddress)
                else
                    if not ShipAddress.Get("Purchase Header"."Location Code", "Purchase Header"."Receiving Address Code") then
                        Clear(ShipAddress);
                //RSI-KS 09-25-15

                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

                if not CurrReport.Preview then begin
                    if ArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    end;
                end;

                if "Posting Date" <> 0D then
                    UseDate := "Posting Date"
                else
                    UseDate := WorkDate;
            end;

            trigger OnPreDataItem()
            begin
                if PrintCompany then
                    FormatAddress.Company(CompanyAddress, CompanyInformation)
                else
                    Clear(CompanyAddress);
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
                    field(NumberOfCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocumentEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get('');
    end;

    var
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Vend: Record Vendor;
        CompanyAddress: array[8] of Text[50];
        BuyFromAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        TaxAmount: Decimal;
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        Text000: Label 'COPY';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ToCaptionLbl: Label 'To:';
        ReceiveByCaptionLbl: Label 'Receive By';
        VendorIDCaptionLbl: Label 'Vendor ID';
        ConfirmToCaptionLbl: Label 'Confirm To';
        BuyerCaptionLbl: Label 'Buyer';
        ShipCaptionLbl: Label 'Ship';
        ToCaption1Lbl: Label 'To:';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER';
        PurchOrderNumCaptionLbl: Label 'Purchase Order Number:';
        PurchOrderDateCaptionLbl: Label 'Purchase Order Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via';
        TermsCaptionLbl: Label 'Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvDiscCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        gcCrossRefNo: Code[20];
        gsCrossRefDesc: Text[50];
        gcItemNo: Code[20];
        gsItemDesc: Text[50];
        gsPhoneNo: Text[30];
        gsVendorPhoneNo: Text[40];
        gsShipMethod: Text;
        gsTerms: Text;
        ReqDateLbl: Label 'Ship Date';
        ShipAddress: Record "Location Address";
        gsGeneric: Text;
}

