report 50014 "Whse. - Shipment -Rupp"
{
    // //SOC-SC 10-12-14
    //   Enable user to sort lines
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/WhseShipmentRupp.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Whse. - Shipment';

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(HeaderNo_WhseShptHeader; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyName; CompanyName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(AssUid__WhseShptHeader; "Warehouse Shipment Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(HrdLocCode_WhseShptHeader; "Warehouse Shipment Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(HeaderNo1_WhseShptHeader; "Warehouse Shipment Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Show1; not Location."Bin Mandatory")
                {
                }
                column(Show2; Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehouseShipmentCaption; WarehouseShipmentCaptionLbl)
                {
                }
                column(SameDestination; gbSameDestination)
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
                dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Shipment Header";
                    column(ShelfNo_WhseShptLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_WhseShptLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_WhseShptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UomCode_WhseShptLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_WhseShptLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_WhseShptLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_WhseShptLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_WhseShptLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_WhseShptLine; "Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseShptLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(GenericName; gsGenericName)
                    {
                    }
                    column(QtyToPick; "Qty. to Pick")
                    {
                        DecimalPlaces = 0 : 2;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    recWhseShptLn: Record "Warehouse Shipment Line";
                    recSH: Record "Sales Header";
                    recPH: Record "Purchase Header";
                    recTH: Record "Transfer Header";
                    FormatAddress: Codeunit "Format Address";
                    recWhseShptLn1: Record "Warehouse Shipment Line";
                begin
                    //SOC-SC 10-12-14
                    Clear(gsSellToArray);
                    Clear(gsShipToArray);
                    Clear(gsExternalDocNo);
                    Clear(gsSalespersonCode);
                    Clear(gsPaymentTerms);
                    Clear(gtReqShipDate);
                    Clear(gsShipVia);
                    Clear(gbSameDestination);

                    //if all lines are for the same destination, then print the address
                    recWhseShptLn.Reset();
                    recWhseShptLn.SetRange("No.", "Warehouse Shipment Header"."No.");
                    if recWhseShptLn.FindFirst() then begin
                        recWhseShptLn1.Reset();
                        recWhseShptLn1.SetRange("No.", recWhseShptLn."No.");
                        recWhseShptLn1.SetFilter("Line No.", '<>%1', recWhseShptLn."Line No.");
                        recWhseShptLn1.SetFilter("Destination Type", '<>%1', recWhseShptLn."Destination Type");
                        if recWhseShptLn1.Count = 0 then begin

                            recWhseShptLn1.SetRange("Destination Type");
                            recWhseShptLn1.SetFilter("Destination No.", '<>%1', recWhseShptLn."Destination No.");
                            if recWhseShptLn1.Count = 0 then begin

                                gbSameDestination := true;
                                case recWhseShptLn."Source Document" of
                                    recWhseShptLn."Source Document"::"Sales Order":
                                        begin
                                            recSH.Get(recWhseShptLn."Source Subtype", recWhseShptLn."Source No.");
                                            FormatAddress.SalesHeaderSellTo(gsSellToArray, recSH);
                                            FormatAddress.SalesHeaderShipTo(gsShipToArray, gsShipToArray, recSH);
                                            gsExternalDocNo := recSH."External Document No.";
                                            gsSalespersonCode := recSH."Salesperson Code";
                                            gsPaymentTerms := recSH."Payment Terms Code";
                                            gtReqShipDate := recSH."Requested Ship Date";
                                            gsShipVia := recSH."Shipping Agent Code" + ' ' + recSH."E-Ship Agent Service";
                                        end;
                                    recWhseShptLn."Source Document"::"Purchase Return Order":
                                        begin
                                            recPH.Get(recWhseShptLn."Source Subtype", recWhseShptLn."Source No.");
                                            FormatAddress.PurchHeaderBuyFrom(gsSellToArray, recPH);
                                            FormatAddress.PurchHeaderShipTo(gsShipToArray, recPH);
                                            gsExternalDocNo := recPH."Vendor Order No.";
                                            gsShipVia := recPH."E-Ship Agent Code" + ' ' + recPH."E-Ship Agent Service";
                                        end;
                                    recWhseShptLn."Source Document"::"Outbound Transfer":
                                        begin
                                            recTH.Get(recWhseShptLn."Source No.");
                                            FormatAddress.TransferHeaderTransferTo(gsSellToArray, recTH);
                                            FormatAddress.TransferHeaderTransferTo(gsShipToArray, recTH);
                                            gsShipVia := recTH."Shipping Agent Code" + ' ' + recTH."E-Ship Agent Service";
                                        end;
                                end;
                            end;
                        end;
                    end;
                    //SOC-SC 10-12-14
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Whse. - Posted Shipment';

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
        Location: Record Location;
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehouseShipmentCaptionLbl: Label 'Warehouse Shipment';
        gsSellToArray: array[8] of Text[50];
        gsShipToArray: array[8] of Text[50];
        gsExternalDocNo: Code[20];
        gsSalespersonCode: Code[10];
        gsPaymentTerms: Code[10];
        gtReqShipDate: Date;
        gsShipVia: Text[50];
        gsGenericName: Code[20];
        gbSameDestination: Boolean;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

