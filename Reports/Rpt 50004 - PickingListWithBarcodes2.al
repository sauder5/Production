report 50004 "Picking List With Barcodes2"
{
    // //SOC-SC 12-10-12
    //   Printing barcodes for Order No. and Item No.
    // //SOC-SC 12-13-12
    //   OnPreReport: made ShowLotSN = true
    // //SOC-SC 01-02-13
    //   Made barcodes invisible, showing Dest Name, City and State
    // 
    // //SOC-SC 01-29-13
    //   Print header
    // 
    // //SOC-SC 06-01-13
    //   As per Al, if Lot No. is an old Lot No. (if the initial acquisition inventory layer of that item lot no. is before Go-Live), then print only 9-12 chars
    // 
    // //SOC-SC 10-09-13
    //   Modified layout as per Shellee
    // 
    // //SOC-SC 12-14-13
    //   Calculate Total Quantity
    // 
    // //SOC-RB 09.29.14
    //   Added Code to Include Ship-to Phone No.
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PickingListWithBarcodes2.rdlc';
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Picking List';

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING(Type, "No.") WHERE(Type = FILTER(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(No_WhseActivHeader; "No.")
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
                column(Time; Time)
                {
                }
                column(PickFilter; PickFilter)
                {
                }
                column(DirectedPutAwayAndPick; Location."Directed Put-away and Pick")
                {
                }
                column(BinMandatory; Location."Bin Mandatory")
                {
                }
                column(InvtPick; InvtPick)
                {
                }
                column(ShowLotSN; ShowLotSN)
                {
                }
                column(SumUpLines; SumUpLines)
                {
                }
                column(No_WhseActivHeaderCaption; 'Pick No.')
                {
                }
                column(WhseActivHeaderCaption; "Warehouse Activity Header".TableCaption + ': ' + PickFilter)
                {
                }
                column(LoctnCode_WhseActivHeader; "Warehouse Activity Header"."Location Code")
                {
                }
                column(SortingMtd_WhseActivHeader; "Warehouse Activity Header"."Sorting Method")
                {
                }
                column(AssgUserID_WhseActivHeader; "Warehouse Activity Header"."Assigned User ID")
                {
                }
                column(SourcDocument_WhseActLine; "Warehouse Activity Line"."Source Document")
                {
                }
                column(LoctnCode_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Location Code"))
                {
                }
                column(SortingMtd_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Sorting Method"))
                {
                }
                column(AssgUserID_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Assigned User ID"))
                {
                }
                column(SourcDocument_WhseActLineCaption; "Warehouse Activity Line".FieldCaption("Source Document"))
                {
                }
                column(SourceNo_WhseActLineCaption; 'Order No.')
                {
                }
                column(ShelfNo_WhseActLineCaption; WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(VariantCode_WhseActLineCaption; WhseActLine.FieldCaption("Variant Code"))
                {
                }
                column(Description_WhseActLineCaption; WhseActLine.FieldCaption(Description))
                {
                }
                column(ItemNo_WhseActLineCaption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(UOMCode_WhseActLineCaption; 'Unit of Measure')
                {
                }
                column(QtytoHandle_WhseActLineCaption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(QtyBase_WhseActLineCaption; WhseActLine.FieldCaption("Qty. (Base)"))
                {
                }
                column(DestinatnType_WhseActLineCaption; WhseActLine.FieldCaption("Destination Type"))
                {
                }
                column(DestinationNo_WhseActLineCaption; 'Customer')
                {
                }
                column(ZoneCode_WhseActLineCaption; WhseActLine.FieldCaption("Zone Code"))
                {
                }
                column(BinCode_WhseActLineCaption; WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(ActionType_WhseActLineCaption; WhseActLine.FieldCaption("Action Type"))
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(PickingListCaption; PickingListCaptionLbl)
                {
                }
                column(WhseActLineDueDateCaption; WhseActLineDueDateCaptionLbl)
                {
                }
                column(QtyHandledCaption; QtyHandledCaptionLbl)
                {
                }
                column(SellToCaption; gsSellToCaption)
                {
                }
                column(SellToAdd1; gsSellToAddArray[1])
                {
                }
                column(SellToAdd2; gsSellToAddArray[2])
                {
                }
                column(SellToAdd3; gsSellToAddArray[3])
                {
                }
                column(SellToAdd4; gsSellToAddArray[4])
                {
                }
                column(SellToAdd5; gsSellToAddArray[5])
                {
                }
                column(SellToAdd6; gsSellToAddArray[6])
                {
                }
                column(SellToAdd7; gsSellToAddArray[7])
                {
                }
                column(SellToAdd8; gsSellToAddArray[8])
                {
                }
                column(ShipToCaption; gsShipToCaption)
                {
                }
                column(ShipToAdd1; gsShipToAddArray[1])
                {
                }
                column(ShipToAdd2; gsShipToAddArray[2])
                {
                }
                column(ShipToAdd3; gsShipToAddArray[3])
                {
                }
                column(ShipToAdd4; gsShipToAddArray[4])
                {
                }
                column(ShipToAdd5; gsShipToAddArray[5])
                {
                }
                column(ShipToAdd6; gsShipToAddArray[6])
                {
                }
                column(ShipToAdd7; gsShipToAddArray[7])
                {
                }
                column(ShipToAdd8; gsShipToAddArray[8])
                {
                }
                column(MultipleSrcDocs; gbMultipleSrcDocs)
                {
                }
                column(Carrier; gsCarrier)
                {
                }
                column(OrderNo; gsOrderNo)
                {
                }
                column(DueDate; gtDueDate)
                {
                }
                column(CustPONo; gsCustPONo)
                {
                }
                dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.");

                    trigger OnAfterGetRecord()
                    begin
                        if SumUpLines and
                           ("Warehouse Activity Header"."Sorting Method" <>
                            "Warehouse Activity Header"."Sorting Method"::Document)
                        then begin
                            if TmpWhseActLine."No." = '' then begin
                                TmpWhseActLine := "Warehouse Activity Line";
                                TmpWhseActLine.Insert;
                                Mark(true);
                            end else begin
                                TmpWhseActLine.SetCurrentKey("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                                TmpWhseActLine.SetRange("Activity Type", "Activity Type");
                                TmpWhseActLine.SetRange("No.", "No.");
                                TmpWhseActLine.SetRange("Bin Code", "Bin Code");
                                TmpWhseActLine.SetRange("Item No.", "Item No.");
                                TmpWhseActLine.SetRange("Action Type", "Action Type");
                                TmpWhseActLine.SetRange("Variant Code", "Variant Code");
                                TmpWhseActLine.SetRange("Unit of Measure Code", "Unit of Measure Code");
                                TmpWhseActLine.SetRange("Due Date", "Due Date");
                                if "Warehouse Activity Header"."Sorting Method" =
                                   "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                then begin
                                    TmpWhseActLine.SetRange("Destination Type", "Destination Type");
                                    TmpWhseActLine.SetRange("Destination No.", "Destination No.")
                                end;
                                if TmpWhseActLine.FindFirst then begin
                                    TmpWhseActLine."Qty. (Base)" := TmpWhseActLine."Qty. (Base)" + "Qty. (Base)";
                                    TmpWhseActLine."Qty. to Handle" := TmpWhseActLine."Qty. to Handle" + "Qty. to Handle";
                                    TmpWhseActLine."Source No." := '';
                                    if "Warehouse Activity Header"."Sorting Method" <>
                                       "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                    then begin
                                        TmpWhseActLine."Destination Type" := TmpWhseActLine."Destination Type"::" ";
                                        TmpWhseActLine."Destination No." := '';
                                    end;
                                    TmpWhseActLine.Modify;
                                end else begin
                                    TmpWhseActLine := "Warehouse Activity Line";
                                    TmpWhseActLine.Insert;
                                    Mark(true);
                                end;
                            end;
                        end else
                            Mark(true);
                    end;

                    trigger OnPostDataItem()
                    begin
                        MarkedOnly(true);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TmpWhseActLine.SetRange("Activity Type", "Warehouse Activity Header".Type);
                        TmpWhseActLine.SetRange("No.", "Warehouse Activity Header"."No.");
                        TmpWhseActLine.DeleteAll;
                        if BreakbulkFilter then
                            TmpWhseActLine.SetRange("Original Breakbulk", false);
                        Clear(TmpWhseActLine);
                    end;
                }
                dataitem(WhseActLine; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Source No.", "Source Line No.", "Source Subline No.", "Serial No.", "Lot No.");
                    column(SourceNo_WhseActLine; "Source No.")
                    {
                    }
                    column(FormatSourcDocument_WhseActLine; Format("Source Document"))
                    {
                    }
                    column(ShelfNo_WhseActLine; "Shelf No.")
                    {
                    }
                    column(ItemNo_WhseActLine; "Item No.")
                    {
                    }
                    column(Description_WhseActLine; Description)
                    {
                    }
                    column(VariantCode_WhseActLine; "Variant Code")
                    {
                    }
                    column(UOMCode_WhseActLine; "Unit of Measure Code")
                    {
                    }
                    column(DueDate_WhseActLine; Format("Due Date"))
                    {
                    }
                    column(QtytoHandle_WhseActLine; "Qty. to Handle")
                    {
                    }
                    column(QtyBase_WhseActLine; "Qty. (Base)")
                    {
                    }
                    column(DestinatnType_WhseActLine; "Destination Type")
                    {
                    }
                    column(DestinationNo_WhseActLine; "Destination No.")
                    {
                    }
                    column(ZoneCode_WhseActLine; "Zone Code")
                    {
                    }
                    column(BinCode_WhseActLine; "Bin Code")
                    {
                    }
                    column(ActionType_WhseActLine; "Action Type")
                    {
                    }
                    column(LotNo_WhseActLine; gcLotNo)
                    {
                    }
                    column(SerialNo_WhseActLine; "Serial No.")
                    {
                    }
                    column(LotNo_WhseActLineCaption; FieldCaption("Lot No."))
                    {
                    }
                    column(SerialNo_WhseActLineCaption; FieldCaption("Serial No."))
                    {
                    }
                    column(LineNo_WhseActLine; "Line No.")
                    {
                    }
                    column(BinRanking_WhseActLine; "Bin Ranking")
                    {
                    }
                    column(EmptyStringCaption; EmptyStringCaptionLbl)
                    {
                    }
                    column(DestinationName; gsDestName)
                    {
                    }
                    column(DestinationCityState; gsDestCity + ', ' + gsDestState)
                    {
                    }
                    column(CrossRefNo; gsCrossRefNo)
                    {
                    }
                    column(TotalQty; gdTotalQty)
                    {
                    }
                    dataitem(WhseActLine2; "Warehouse Activity Line")
                    {
                        DataItemLink = "Activity Type" = FIELD("Activity Type"), "No." = FIELD("No."), "Bin Code" = FIELD("Bin Code"), "Item No." = FIELD("Item No."), "Action Type" = FIELD("Action Type"), "Variant Code" = FIELD("Variant Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Due Date" = FIELD("Due Date");
                        DataItemLinkReference = WhseActLine;
                        DataItemTableView = SORTING("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                        column(LotNo_WhseActLine2; "Lot No.")
                        {
                        }
                        column(SerialNo_WhseActLine2; "Serial No.")
                        {
                        }
                        column(QtyBase_WhseActLine2; "Qty. (Base)")
                        {
                        }
                        column(QtytoHandle_WhseActLine2; "Qty. to Handle")
                        {
                        }
                        column(LineNo_WhseActLine2; "Line No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            cTradexWhseFun: Codeunit "Rupp Functions";
                        begin
                            //**gcLotNo := cTradexWhseFun.GetLotNo("Item No.", "Lot No."); //SOC-SC 06-01-13
                        end;
                    }
                    dataitem("Sales Comment Line"; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No."), "Document Line No." = FIELD("Source Line No.");
                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Print On Pick Ticket" = CONST(true));
                        column(SalesLineComment; "Sales Comment Line".Comment)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if WhseActLine."Source Type" <> 37 then CurrReport.Break();
                        end;
                    }
                    dataitem(SrcDocHeadercomment; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Line No." = FILTER(0), "Print On Pick Ticket" = CONST(true));
                        column(SalesHdrComment; SrcDocHeadercomment.Comment)
                        {
                        }

                        trigger OnPreDataItem()
                        var
                            iLastSrcLineNo: Integer;
                        begin
                            if WhseActLine."Source Type" <> 37 then CurrReport.Break();
                            iLastSrcLineNo := GetLastSrcLineNo(WhseActLine);
                            if WhseActLine."Line No." <> iLastSrcLineNo then begin
                                CurrReport.Break();
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        cTradexWhseFun: Codeunit "Rupp Functions";
                    begin
                        if SumUpLines then begin
                            TmpWhseActLine.Get("Activity Type", "No.", "Line No.");
                            "Qty. (Base)" := TmpWhseActLine."Qty. (Base)";
                            "Qty. to Handle" := TmpWhseActLine."Qty. to Handle";
                        end;

                        //SOC-SC 01-31-13
                        GetDestNameCityState(WhseActLine, gsDestName, gsDestCity, gsDestState);
                        GetCrossRef(WhseActLine, gsCrossRefNo);
                        //**gcLotNo := cTradexWhseFun.GetLotNo("Item No.", "Lot No."); //SOC-SC 06-01-13
                        //SOC-SC 01-31-13

                        //SOC-SC 12-14-13
                        if "Action Type" = "Action Type"::Take then begin
                            gdTotalQty += "Qty. to Handle";
                        end;
                        //SOC-SC 12-14-13
                    end;

                    trigger OnPreDataItem()
                    begin
                        Copy("Warehouse Activity Line");
                        Counter := Count;
                        if Counter = 0 then
                            CurrReport.Break;

                        if BreakbulkFilter then
                            SetRange("Original Breakbulk", false);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                InvtPick := Type = Type::"Invt. Pick";

                if not CurrReport.Preview then
                    WhseCountPrinted.Run("Warehouse Activity Header");

                GetOrderHdrToPrint("Warehouse Activity Header", gsSellToAddArray, gsShipToAddArray, gbMultipleSrcDocs, gsCarrier, gsOrderNo, gtDueDate, gsCustPONo); //SOC-SC 01-29-13

                gdTotalQty := 0;
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
                    field(Breakbulk; BreakbulkFilter)
                    {
                        Caption = 'Set Breakbulk Filter';
                        Editable = BreakbulkEditable;
                    }
                    field(SumUpLines; SumUpLines)
                    {
                        Caption = 'Sum up Lines';
                        Editable = SumUpLinesEditable;
                    }
                    field(LotSerialNo; ShowLotSN)
                    {
                        Caption = 'Show Serial/Lot Number';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SumUpLinesEditable := true;
            BreakbulkEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if HideOptions then begin
                BreakbulkEditable := false;
                SumUpLinesEditable := false;
            end;
        end;
    }

    labels
    {
        CarrierLbl = 'Carrier:';
        OrderLbl = 'Order:';
        DueDateLbl = 'Due Date:';
        PulledByLbl = 'Pulled By:';
        CheckedByLbl = 'Checked By:';
        DoubleCheckedByLbl = 'Double Checked By:';
        ChangesLbl = 'Bin/Lot Changes';
        QtyPickedLbl = 'Qty. Picked';
        NotesLbl = 'NOTES:';
        CustPOLbl = 'Cust PO:';
        TotalCaptionLbl = 'Total:';
    }

    trigger OnPreReport()
    begin
        PickFilter := "Warehouse Activity Header".GetFilters;
        //**ShowLotSN := TRUE; //SOC-SC 12-13-12
    end;

    var
        Location: Record Location;
        TmpWhseActLine: Record "Warehouse Activity Line" temporary;
        WhseCountPrinted: Codeunit "Whse.-Printed";
        PickFilter: Text[250];
        BreakbulkFilter: Boolean;
        SumUpLines: Boolean;
        HideOptions: Boolean;
        InvtPick: Boolean;
        ShowLotSN: Boolean;
        Counter: Integer;
        [InDataSet]
        BreakbulkEditable: Boolean;
        [InDataSet]
        SumUpLinesEditable: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        PickingListCaptionLbl: Label 'Picking List';
        WhseActLineDueDateCaptionLbl: Label 'Due Date';
        QtyHandledCaptionLbl: Label 'Qty. Handled';
        EmptyStringCaptionLbl: Label '_________';
        gsDestName: Text[50];
        gsDestCity: Text[30];
        gsDestState: Text[30];
        gsSellToAddArray: array[8] of Text[50];
        gsShipToAddArray: array[8] of Text[50];
        gbMultipleSrcDocs: Boolean;
        gsSellToCaption: Label 'Sell To:';
        gsShipToCaption: Label 'Ship To:';
        gsCrossRefNo: Code[20];
        gcLotNo: Code[20];
        gsCarrier: Text[50];
        gsOrderNo: Text[20];
        gtDueDate: Date;
        gsCustPONo: Text[50];
        gdTotalQty: Decimal;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    [Scope('Internal')]
    procedure SetBreakbulkFilter(BreakbulkFilter2: Boolean)
    begin
        BreakbulkFilter := BreakbulkFilter2;
    end;

    [Scope('Internal')]
    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;

    [Scope('Internal')]
    procedure GetDestNameCityState(WhseActLn: Record "Warehouse Activity Line"; var retDestName: Text[50]; var retDestCity: Text[30]; var retDestState: Text[30])
    var
        recCust: Record Customer;
        recVendor: Record Vendor;
        recLoc: Record Location;
        recSH: Record "Sales Header";
        recPH: Record "Purchase Header";
        recTH: Record "Transfer Header";
    begin
        retDestName := '';
        retDestCity := '';
        retDestState := '';

        case WhseActLn."Destination Type" of
            WhseActLn."Destination Type"::Customer:
                begin
                    if recCust.Get(WhseActLn."Destination No.") then begin
                        retDestName := recCust.Name;
                    end;
                    if WhseActLn."Source Type" = 37 then begin
                        if recSH.Get(WhseActLn."Source Subtype", WhseActLn."Source No.") then begin
                            retDestCity := recSH."Ship-to City";
                            retDestState := recSH."Ship-to County";
                        end;
                    end;
                end;
            WhseActLn."Destination Type"::Vendor:
                begin
                    if recVendor.Get(WhseActLn."Destination No.") then begin
                        retDestName := recVendor.Name;
                    end;
                    if WhseActLn."Source Type" = 39 then begin
                        if recPH.Get(WhseActLn."Source Subtype", WhseActLn."Source No.") then begin
                            retDestCity := recPH."Ship-to City";
                            retDestState := recPH."Ship-to County";
                        end;
                    end;
                end;
            WhseActLn."Destination Type"::Location:
                begin
                    if recLoc.Get(WhseActLn."Destination No.") then begin
                        retDestName := recLoc.Name;
                    end;
                    if WhseActLn."Source Type" = 5741 then begin
                        if recTH.Get(WhseActLn."Source No.") then begin
                            retDestCity := recTH."Transfer-to City";
                            retDestState := recTH."Transfer-to County";
                        end;
                    end;
                end;
            else
                ;
        end;
    end;

    [Scope('Internal')]
    procedure GetLastSrcLineNo(recWhseActLn: Record "Warehouse Activity Line") retLastSrcLineNo: Integer
    var
        recWALn: Record "Warehouse Activity Line";
    begin
        retLastSrcLineNo := 0;
        recWALn.SetCurrentKey("Source No.", "Source Line No.", "Source Subline No.", "Serial No.", "Lot No.");
        recWALn.SetRange("Activity Type", recWhseActLn."Activity Type");
        recWALn.SetRange("No.", recWhseActLn."No.");
        recWALn.SetRange("Source Type", recWhseActLn."Source Type");
        recWALn.SetRange("Source Subtype", recWhseActLn."Source Subtype");
        recWALn.SetRange("Source No.", recWhseActLn."Source No.");
        recWALn.SetRange("Action Type", recWALn."Action Type"::Take);
        if recWALn.FindLast() then begin
            retLastSrcLineNo := recWALn."Line No.";
        end;
    end;

    [Scope('Internal')]
    procedure GetOrderHdrToPrint(WhseActHdr: Record "Warehouse Activity Header"; var retSellToAddrArray: array[8] of Text[50]; var retShipToAddrArray: array[8] of Text[50]; var retMutlipleSrcDocsExist: Boolean; var retCarrier: Text[50]; var retOrderNo: Text[20]; var retDueDate: Date; var retCustPONo: Text[50])
    var
        recWhseActLn: Record "Warehouse Activity Line";
        iPrevSrcDoc: Integer;
        cPrevSrcDocNo: Code[20];
        FormatAddr: Codeunit "Format Address";
        recSH: Record "Sales Header";
        recPH: Record "Purchase Header";
        recTH: Record "Transfer Header";
        iShiptoAddArrayCount: Integer;
    begin
        retMutlipleSrcDocsExist := false;
        Clear(retSellToAddrArray);
        Clear(retShipToAddrArray);
        Clear(retCarrier);
        Clear(retOrderNo);
        Clear(retDueDate);
        Clear(retCustPONo);

        recWhseActLn.Reset();
        recWhseActLn.SetRange("Activity Type", WhseActHdr.Type);
        recWhseActLn.SetRange("No.", WhseActHdr."No.");
        recWhseActLn.FindSet();
        iPrevSrcDoc := recWhseActLn."Source Document";
        cPrevSrcDocNo := recWhseActLn."Source No.";
        repeat
            if (iPrevSrcDoc <> recWhseActLn."Source Document") or (cPrevSrcDocNo <> recWhseActLn."Source No.") then begin
                retMutlipleSrcDocsExist := true;
            end;
            iPrevSrcDoc := recWhseActLn."Source Document";
            cPrevSrcDocNo := recWhseActLn."Source No.";
        until (recWhseActLn.Next = 0) or retMutlipleSrcDocsExist;

        if retMutlipleSrcDocsExist then exit;

        recWhseActLn.FindFirst();
        case recWhseActLn."Source Document" of
            recWhseActLn."Source Document"::"Sales Order":
                begin
                    recSH.Get(recSH."Document Type"::Order, recWhseActLn."Source No.");
                    FormatAddr.SalesHeaderSellTo(retSellToAddrArray, recSH);
                    FormatAddr.SalesHeaderShipTo(retShipToAddrArray, retShipToAddrArray, recSH);
                    //SOC-RB 09.29.14 Added Code to Include Ship-to Phone No.
                    iShiptoAddArrayCount := CompressArray(retShipToAddrArray);
                    retShipToAddrArray[iShiptoAddArrayCount + 1] := recSH."Ship-to Phone No. -CL-";
                    //SOC-RB End
                    retOrderNo := recSH."No.";
                    retCarrier := recSH."Shipping Agent Code" + ' ' + recSH."E-Ship Agent Service";
                    retDueDate := recSH."Shipment Date";
                    retCustPONo := recSH."External Document No.";
                end;
            recWhseActLn."Source Document"::"Purchase Return Order":
                begin
                    recPH.Get(recPH."Document Type"::"Return Order", recWhseActLn."Source No.");
                    FormatAddr.PurchHeaderBuyFrom(retSellToAddrArray, recPH);
                    FormatAddr.PurchHeaderShipTo(retShipToAddrArray, recPH);
                    retOrderNo := recPH."No.";
                    retCarrier := recPH."E-Ship Agent Code" + ' ' + recSH."E-Ship Agent Service";
                    retDueDate := recPH."Expected Receipt Date";
                    retCustPONo := recPH."Vendor Order No.";
                end;
            recWhseActLn."Source Document"::"Outbound Transfer":
                begin
                    recTH.Get(recWhseActLn."Source No.");
                    FormatAddr.TransferHeaderTransferFrom(retSellToAddrArray, recTH);
                    FormatAddr.TransferHeaderTransferTo(retShipToAddrArray, recTH);
                    retOrderNo := recTH."No.";
                    retCarrier := recTH."Shipping Agent Code" + ' ' + recTH."E-Ship Agent Service";
                end;
            else
                ;
        end;
    end;

    [Scope('Internal')]
    procedure GetCrossRef(recWhseActLn: Record "Warehouse Activity Line"; var retCrossRefNo: Code[20])
    var
        recSL: Record "Sales Line";
    begin
        Clear(retCrossRefNo);
        case recWhseActLn."Source Document" of
            recWhseActLn."Source Document"::"Sales Order":
                begin
                    recSL.Get(recSL."Document Type"::Order, recWhseActLn."Source No.", recWhseActLn."Source Line No.");
                    retCrossRefNo := recSL."Cross-Reference No.";
                end;
            else
                ;
        end;
    end;
}

