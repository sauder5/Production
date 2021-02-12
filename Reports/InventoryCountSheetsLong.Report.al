report 50001 "Rupp Inventory Count Sheets"
{
    // ************************
    // Copyright Notice
    // This objects content is copyright of Dynamic Manufacturing Solutions Inc 2011.  All rights reserved.
    // Any redistribution or reproduction of part or all of the contents in any form is prohibited.
    // ************************
    // 
    // <DMS>
    //  <REVISION author="M.Hamblin" date="12/3/2009" version="INV1.0" issue="">
    //   Copied from base report
    //    - changed layout
    //    - added sorting options
    //  </REVISION>
    //  <REVISION author="M.Hamblin" date="6/22/2010" version="INV1.2" issue="">
    //   Adjusted grouping layout to prevent wrong heading from appearing on count sheet
    //  </REVISION>
    //  <REVISION author="S.Roy" date="2/24/2012" version="INV2.0" issue="">
    //   Add variables and code, plus slightly modify classic layout for RTC support.
    //  </REVISION>
    //  <REVISION author="R.Trudeau" date="9/13/2012" version="INV3.0" issue="">
    //   Modified for Count Headers.
    //  </REVISION>
    //  <REVISION author="many" date="10/21/2012" version="INV3.0" issue="">
    //    2013 Support
    //  </REVISION>
    //  <REVISION author="R.Letts" date="09/30/2013" version="DMS13.09" issue="TFS690">
    //    Added 2D barcoding to the report.
    //  </REVISION>
    //  <REVISION author="R.Letts" date="2/6/2014" version="DMS14.02" issue="TFS1086">
    //    Changed barcode to 1D for Inv count merge reasons. 2D barcodes relied on WMDMCommon which doesn't come over in INV count merges
    //  </REVISION>
    //  <REVISION author="M.Hamblin" date="7/21/2015" version="DMS15.07" issue="TFS1895">
    //   Added UOM, serial #, and lot # to dataset to make it easier for clients to format report
    //  </REVISION>
    //  <REVISION author="M.Hamblin" date="10/04/2015" version="DMS15.10" issue="TFS2006">
    //   Changed margins to fit 8.5x11, fixed issue with barcode repeating
    //  </REVISION>
    //  <REVISION author="C.Avent" date="11/23/2015" version="DMS15.11" issue="TFS2078">
    //   Update Caption ML for Help File purposes
    //  </REVISION>
    // 
    // </DMS>
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/InventoryCountSheetsLong.rdlc';

    Caption = 'Rupp Inventory Count Sheets';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(recSheetLoop; "IWX Count Sheet Configuration")
        {
            DataItemTableView = SORTING("Count No.", "Sheet Name") WHERE("WIP Only" = CONST(false));
            RequestFilterFields = "Sheet Name";
            RequestFilterHeading = 'Count Sheets';
            column(SheetNameCaption; txtSheetNameCaption)
            {
            }
            column(CountedByCaption; txtCountedByCaption)
            {
            }
            column(ReportTitlePageValue; txtReportTitlePageValue)
            {
            }
            column(EmptyString; '')
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(nTotalPages; nTotalPages)
            {
            }
            column(Inventory_Count_SheetCaption; Inventory_Count_SheetCaptionLbl)
            {
            }
            column(NOTE__Check_nItemsPerPage_constant_if_you_change_report_layoutCaption; NOTE__Check_nItemsPerPage_constant_if_you_change_report_layoutCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(OfCaption; OfCaptionLbl)
            {
            }
            column(recSheetLoop_Count_No_; "Count No.")
            {
            }
            column(recSheetLoop_Sheet_Name; "Sheet Name")
            {
            }
            dataitem(recCountSheetLine; "IWX Count Sheet Line")
            {
                DataItemLink = "Count No." = FIELD("Count No."), "Sheet Name" = FIELD("Sheet Name");
                DataItemTableView = SORTING("Generic Name Code", "Bin Code", Description) WHERE("Item No." = FILTER(<> ''));
                column(recCountSheetLine__Sheet_Name_; "Sheet Name")
                {
                }
                column(Sheet_Name_Caption; tcSheetNameLabel)
                {
                }
                column(Counted_By_Caption; tcCountedByLabel)
                {
                }
                column(recCountSheetLine__Count_No__; "Count No.")
                {
                }
                column(Count_No_Caption; tcCountNoLabel)
                {
                }
                column(recCountSheetLine__Item_No__; "Item No.")
                {
                }
                column(getDescription; getDescription)
                {
                }
                column(recCountSheetLine__Bin_Code_; "Bin Code")
                {
                }
                column(recCountSheetLine__Item_No__Caption; FieldCaption("Item No."))
                {
                }
                column(Qty_Caption; Qty_CaptionLbl)
                {
                }
                column(recCountSheetLine__Bin_Code_Caption; FieldCaption("Bin Code"))
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(recCountSheetLine_Tag_No_; "Tag No.")
                {
                }
                column(Unit_of_Measure; "Unit of Measure Code")
                {
                }
                column(Serial_No; "Serial No.")
                {
                }
                column(Lot_No; "Lot No.")
                {
                }
                column(Generic_Name; "Generic Name Code")
                {
                }
            }
            dataitem(recBlanks; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(recSheetLoop__Sheet_Name_; recSheetLoop."Sheet Name")
                {
                }
                column(Sheet_Name_Caption_Control1000000026; tcSheetNameLabel)
                {
                }
                column(Counted_By_Caption_Control1000000031; tcCountedByLabel)
                {
                }
                column(recSheetLoop__Count_No__; recSheetLoop."Count No.")
                {
                }
                column(recBlanks_Count_No_Caption_; tcCountNoLabel)
                {
                }
                column(recBlanks_recBlanks_Number; recBlanks.Number)
                {
                }
                column(Item_No_Caption; Item_No_CaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(NotesCaption; NotesCaptionLbl)
                {
                }
                column(BinCaption; BinCaptionLbl)
                {
                }
                column(Tag_No_Caption; Tag_No_CaptionLbl)
                {
                }
                column(Serial_No_Caption; Serial_No_CaptionLbl)
                {
                }
                column(Generic_Name_Caption; Generic_NameLbl)
                {
                }

                trigger OnPreDataItem()
                begin
                    if recSheetLoop."Blank Sheet Qty." = 0 then
                        CurrReport.Break;

                    recBlanks.SetRange(Number, 1, cnBlankLinesPerPage * recSheetLoop."Blank Sheet Qty.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //<DMS author="S.Roy" date="2/24/2012" issue="" >
                txtSheetNameCaption := tcSheetNameLabel;
                txtSheetNameValue := "Sheet Name";
                txtCountedByCaption := tcCountedByLabel;
                txtReportTitlePageValue := tcReportTitle;
                //</DMS>
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

    trigger OnInitReport()
    begin
        cnItemsPerPage := 45; // NOTE: Change this if report layout changes
        cnBlankLinesPerPage := 25; // NOTE: Change this if report layout changes
    end;

    trigger OnPreReport()
    var
        lrecCountSheet: Record "IWX Count Sheet Line";
    begin
        lrecCountSheet.SetFilter("Item No.", '=%1', '');
        lrecCountSheet.DeleteAll;

        calculatePageCount;
    end;

    var
        bPage1Printed: Boolean;
        recItem: Record Item;
        bHideHeader: Boolean;
        cnItemsPerPage: Integer;
        nTotalPages: Integer;
        cnBlankLinesPerPage: Integer;
        tcBarcodeFormat: Label '%C%%1';
        txtSheetNameCaption: Text[50];
        txtSheetNameValue: Text[50];
        txtCountedByCaption: Text[30];
        txtReportTitlePageValue: Text[50];
        tcSheetNameLabel: Label 'Sheet Name:';
        tcReportTitle: Label 'Inventory Count Sheet';
        tcCountedByLabel: Label 'Counted By:';
        recCountHeader: Record "IWX Inventory Count Header";
        tcCountNoLabel: Label 'Count No.:';
        Inventory_Count_SheetCaptionLbl: Label 'Inventory Count Sheet';
        NOTE__Check_nItemsPerPage_constant_if_you_change_report_layoutCaptionLbl: Label 'NOTE: Check nItemsPerPage constant if you change report layout';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        OfCaptionLbl: Label 'Of';
        Qty_CaptionLbl: Label 'Qty.';
        DescriptionCaptionLbl: Label 'Description';
        EmptyStringCaptionLbl: Label '.  . ';
        Item_No_CaptionLbl: Label 'Item No.';
        QuantityCaptionLbl: Label 'Quantity';
        NotesCaptionLbl: Label 'Notes';
        BinCaptionLbl: Label 'Bin';
        Tag_No_CaptionLbl: Label 'Tag No.';
        Serial_No_CaptionLbl: Label 'Serial No.';
        [InDataSet]
        SumUpLinesEditable: Boolean;
        Generic_NameLbl: Label 'Generic Name';

    [Scope('Internal')]
    procedure getDescription(): Text[100]
    begin
        if recItem.Get(recCountSheetLine."Item No.") then
            exit(recItem.Description + recItem."Description 2");

        exit('');
    end;

    [Scope('Internal')]
    procedure calculatePageCount()
    var
        lrecCountConfig: Record "IWX Count Sheet Configuration";
        lrecCountSheet: Record "IWX Count Sheet Line";
    begin
        //<DMS author="M.Hamblin" date="9/11/2007" issue="191192" >
        // Emulates report loops to calculate total number of pages.
        //</DMS>

        recCountHeader.Get(recSheetLoop.GetFilter("Count No."));
        lrecCountConfig.Reset;

        lrecCountConfig.CopyFilters(recSheetLoop);
        if (lrecCountConfig.FindSet(false)) then begin
            repeat
                lrecCountSheet.SetRange("Count No.", lrecCountConfig."Count No.");
                lrecCountSheet.SetRange("Sheet Name", lrecCountConfig."Sheet Name");
                if (lrecCountSheet.Count = 0) and (lrecCountConfig."Blank Sheet Qty." = 0) then
                    nTotalPages += 1
                else
                    nTotalPages += Round(lrecCountSheet.Count / cnItemsPerPage, 1, '>');

                nTotalPages += lrecCountConfig."Blank Sheet Qty.";
            until lrecCountConfig.Next = 0;
        end;
    end;
}

