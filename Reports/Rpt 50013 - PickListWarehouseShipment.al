report 50013 "Pick List - Warehouse Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PickListWarehouseShipment.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            RequestFilterFields = "No.";
            column(WhseShptNo; "Warehouse Shipment Header"."No.")
            {
            }
            column(WhseShptDate; "Warehouse Shipment Header"."Shipment Date")
            {
            }
            column(CompanyInfo1; gsCompanyInfoArray[1])
            {
            }
            column(CompanyInfo2; gsCompanyInfoArray[2])
            {
            }
            column(CompanyInfo3; gsCompanyInfoArray[3])
            {
            }
            column(CompanyInfo4; gsCompanyInfoArray[4])
            {
            }
            column(CompanyInfo5; gsCompanyInfoArray[5])
            {
            }
            column(CompanyInfo6; gsCompanyInfoArray[6])
            {
            }
            column(CompanyInfo7; gsCompanyInfoArray[7])
            {
            }
            column(CompanyInfo8; gsCompanyInfoArray[8])
            {
            }
            column(CompanyLogo; recCompanyInfo.Picture)
            {
            }
            dataitem(Destination; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Destination Type", "Destination No.");
                column(DestType; Destination."Destination Type")
                {
                }
                column(DestNo; Destination."Destination No.")
                {
                }
                dataitem(WhseShptLn; "Warehouse Shipment Line")
                {
                    DataItemLink = "No." = FIELD("No."), "Destination Type" = FIELD("Destination Type"), "Destination No." = FIELD("Destination No.");
                    DataItemTableView = SORTING("No.", "Source Document", "Source No.");
                    dataitem("Order"; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(SrcDoc; WhseShptLn."Source Document")
                        {
                        }
                        column(SrcSubType; WhseShptLn."Source Subtype")
                        {
                        }
                        column(OrderNo; WhseShptLn."Source No.")
                        {
                        }
                        column(SellTo1; gsSellToArray[1])
                        {
                        }
                        column(SellTo2; gsSellToArray[2])
                        {
                        }
                        column(SellTo3; gsSellToArray[3])
                        {
                        }
                        column(SellTo4; gsSellToArray[4])
                        {
                        }
                        column(SellTo5; gsSellToArray[5])
                        {
                        }
                        column(SellTo6; gsSellToArray[6])
                        {
                        }
                        column(SellTo7; gsSellToArray[7])
                        {
                        }
                        column(SellTo8; gsSellToArray[8])
                        {
                        }
                        column(ShipTo1; gsShipToArray[1])
                        {
                        }
                        column(ShipTo2; gsShipToArray[2])
                        {
                        }
                        column(ShipTo3; gsShipToArray[3])
                        {
                        }
                        column(ShipTo4; gsShipToArray[4])
                        {
                        }
                        column(ShipTo5; gsShipToArray[5])
                        {
                        }
                        column(ShipTo6; gsShipToArray[6])
                        {
                        }
                        column(ShipTo7; gsShipToArray[7])
                        {
                        }
                        column(ShipTo8; gsShipToArray[8])
                        {
                        }
                        column(ShipToPhone; gsShipPhone)
                        {
                        }
                        column(ShipContact; gsContact)
                        {
                        }
                        column(ExtDocNo; gsExternalDocNo)
                        {
                        }
                        column(SalespersonCode; gsSalespersonCode)
                        {
                        }
                        column(PaymentTerms; gsPaymentTerms)
                        {
                        }
                        column(ReqShipDate; gtReqShipDate)
                        {
                        }
                        column(ShipVia; gsShipVia)
                        {
                        }
                        dataitem(SourceDocLn; "Warehouse Shipment Line")
                        {
                            DataItemLink = "No." = FIELD("No."), "Source Type" = FIELD("Source Type"), "Source Subtype" = FIELD("Source Subtype"), "Source No." = FIELD("Source No.");
                            DataItemLinkReference = WhseShptLn;
                            DataItemTableView = SORTING("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.") WHERE("Qty. to Pick" = FILTER(> 0));
                            column(WhseShptNo1; "Warehouse Shipment Header"."No.")
                            {
                            }
                            column(WhseShptDate1; "Warehouse Shipment Header"."Shipment Date")
                            {
                            }
                            column(ItemNo; SourceDocLn."Item No.")
                            {
                            }
                            column(Qty; SourceDocLn.Quantity)
                            {
                            }
                            column(SrcLineNo; SourceDocLn."Source Line No.")
                            {
                            }
                            column(UOMCode; SourceDocLn."Unit of Measure Code")
                            {
                            }
                            column(Description; SourceDocLn.Description)
                            {
                            }
                            column(LocationCode; SourceDocLn."Location Code")
                            {
                            }
                            column(GenericName; gsGenericName)
                            {
                            }
                            column(QtyToPick; SourceDocLn."Qty. to Pick")
                            {
                            }
                            column(BinCode; gsBinCode)
                            {
                            }
                            dataitem(LineComment; "Sales Comment Line")
                            {
                                DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No."), "Document Line No." = FIELD("Source Line No.");
                                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Print On Pick Ticket" = CONST(true));
                                column(LineComment; LineComment.Comment)
                                {
                                }
                                column(LineCommentDocLineNo; LineComment."Document Line No.")
                                {
                                }

                                trigger OnPreDataItem()
                                begin
                                    if WhseShptLn."Source Document" <> WhseShptLn."Source Document"::"Sales Order" then
                                        CurrReport.Break;
                                end;
                            }

                            trigger OnAfterGetRecord()
                            var
                                recItem: Record Item;
                            begin
                                gsGenericName := '';
                                if recItem.Get("Item No.") then begin
                                    gsGenericName := recItem."Generic Name Code";
                                end;
                            end;
                        }
                        dataitem(HdrComment; "Sales Comment Line")
                        {
                            DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                            DataItemLinkReference = WhseShptLn;
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Line No." = CONST(0), "Print On Pick Ticket" = CONST(true));
                            column(HdrComment; HdrComment.Comment)
                            {
                            }
                            column(HdrCommentDocLineNo; HdrComment."Document Line No.")
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                if WhseShptLn."Source Document" <> WhseShptLn."Source Document"::"Sales Order" then
                                    CurrReport.Break;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            FormatAddress: Codeunit "Format Address";
                            recSH: Record "Sales Header";
                            recPH: Record "Purchase Header";
                            recTH: Record "Transfer Header";
                        begin
                            Clear(gsSellToArray);
                            Clear(gsShipToArray);
                            Clear(gsExternalDocNo);
                            Clear(gsSalespersonCode);
                            Clear(gsPaymentTerms);
                            Clear(gtReqShipDate);
                            Clear(gsShipVia);

                            case WhseShptLn."Source Document" of
                                WhseShptLn."Source Document"::"Sales Order":
                                    begin
                                        recSH.Get(WhseShptLn."Source Subtype", WhseShptLn."Source No.");
                                        FormatAddress.SalesHeaderSellTo(gsSellToArray, recSH);
                                        //      IF gcShipmentCount < 2 THEN
                                        FormatAddress.SalesHeaderShipTo(gsShipToArray, gsShipToArray, recSH);
                                        gsShipPhone := recSH."Ship-to Phone No. -CL-";
                                        gsContact := recSH."Ship-to Contact";
                                        gsExternalDocNo := recSH."External Document No.";
                                        gsSalespersonCode := recSH."Salesperson Code";
                                        gsPaymentTerms := recSH."Payment Terms Code";
                                        gtReqShipDate := recSH."Requested Ship Date";
                                        gsShipVia := recSH."Shipping Agent Code" + ' ' + recSH."E-Ship Agent Service";
                                    end;
                                WhseShptLn."Source Document"::"Purchase Return Order":
                                    begin
                                        recPH.Get(WhseShptLn."Source Subtype", WhseShptLn."Source No.");
                                        FormatAddress.PurchHeaderBuyFrom(gsSellToArray, recPH);
                                        FormatAddress.PurchHeaderShipTo(gsShipToArray, recPH);
                                        gsExternalDocNo := recPH."Vendor Order No.";
                                        gsShipVia := recPH."E-Ship Agent Code" + ' ' + recPH."E-Ship Agent Service";
                                    end;
                                WhseShptLn."Source Document"::"Outbound Transfer":
                                    begin
                                        recTH.Get(WhseShptLn."Source No.");
                                        FormatAddress.TransferHeaderTransferTo(gsSellToArray, recTH);
                                        FormatAddress.TransferHeaderTransferTo(gsShipToArray, recTH);
                                        gsShipVia := recTH."Shipping Agent Code" + ' ' + recTH."E-Ship Agent Service";
                                    end;
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if (WhseShptLn."Source Document" = giPrevSrcDoc) and (WhseShptLn."Source No." = gcPrevSrcDocNo) then begin
                            CurrReport.Skip();
                        end else begin
                            giPrevSrcDoc := WhseShptLn."Source Document";
                            gcPrevSrcDocNo := WhseShptLn."Source No.";
                        end;

                        WhActivityLine.SetFilter(WhActivityLine."Source Type", '%1', WhseShptLn."Source Type");
                        WhActivityLine.SetFilter(WhActivityLine."Source Subtype", '%1', WhseShptLn."Source Subtype");
                        WhActivityLine.SetFilter(WhActivityLine."Source No.", '%1', WhseShptLn."Source No.");
                        WhActivityLine.SetFilter(WhActivityLine."Source Line No.", '%1', WhseShptLn."Source Line No.");
                        WhActivityLine.SetFilter(WhActivityLine."Action Type", '%1', WhActivityLine."Action Type"::Take);

                        gsBinCode := '';
                        if WhActivityLine.FindSet then
                            gsBinCode := WhActivityLine."Bin Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        giPrevSrcDoc := 0;
                        gcPrevSrcDocNo := '';
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Destination Type" = giPrevDestType) and ("Destination No." = gcPrevDestNo) then begin //**
                        CurrReport.Skip();
                    end else begin
                        giPrevDestType := "Destination Type";
                        gcPrevDestNo := "Destination No.";
                        //gcPrevSrcShipToCode
                        //gcPrevShpgAgentCode
                        //gcPrevEShipAgentSer
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    giPrevDestType := 0;
                    gcPrevDestNo := '';
                    gcPrevSrcShipToCode := '';
                    gcPrevShpgAgentCode := '';
                    gcPrevEShipAgentSer := '';
                end;
            }

            trigger OnAfterGetRecord()
            var
                recWHLine: Record "Warehouse Shipment Line";
            begin
                gcShipmentCount := RuppFunctions.CountWhShipmentOrders("Warehouse Shipment Header"."No.");
            end;

            trigger OnPreDataItem()
            var
                FormatAddr: Codeunit "Format Address";
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
                FormatAddr.FormatAddr(gsCompanyInfoArray, recCompanyInfo.Name, '', '', recCompanyInfo.Address, '', recCompanyInfo.City,
                            recCompanyInfo."Post Code", recCompanyInfo.County, '');
                //FormatAddr.FormatAddr(AddrArray,Name,Name2,Contact,Addr,Addr2,City,PostCode,County,CountryCode)
                gsCompanyInfoArray[6] := recCompanyInfo."Phone No.";
                gsCompanyInfoArray[7] := 'Fax: ' + recCompanyInfo."Fax No.";
                gsCompanyInfoArray[8] := recCompanyInfo."Home Page";
                CompressArray(gsCompanyInfoArray);
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
        BillToLbl = 'Bill To:';
        ShipToLbl = 'Ship To:';
        PhoneLbl = 'Phone:';
        ContactLbl = 'Contact:';
    }

    trigger OnPostReport()
    var
        recWHLine: Record "Warehouse Shipment Line";
    begin
        if gcShipmentCount > 1 then begin
            recWHLine.SetRange(recWHLine."No.", "Warehouse Shipment Header"."No.");
            recWHLine.FindSet();
            REPORT.RunModal(50012, true, false, recWHLine);
        end;
    end;

    var
        recCompanyInfo: Record "Company Information";
        giPrevDestType: Integer;
        gcPrevDestNo: Code[20];
        gcPrevSrcShipToCode: Code[10];
        gcPrevShpgAgentCode: Code[10];
        gcPrevEShipAgentSer: Code[10];
        giPrevSrcDoc: Integer;
        gcPrevSrcDocNo: Code[20];
        gsSellToArray: array[8] of Text[50];
        gsShipToArray: array[8] of Text[50];
        gsCompanyInfoArray: array[8] of Text[50];
        gsExternalDocNo: Code[20];
        gsSalespersonCode: Code[10];
        gsPaymentTerms: Code[10];
        gtReqShipDate: Date;
        gsShipVia: Text[50];
        gsGenericName: Code[20];
        gsShipPhone: Text[30];
        gsContact: Text[50];
        gcShipmentCount: Integer;
        RuppFunctions: Codeunit "Rupp Functions";
        WhActivityLine: Record "Warehouse Activity Line";
        gsBinCode: Text;
}

