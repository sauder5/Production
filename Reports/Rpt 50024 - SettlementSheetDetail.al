report 50024 "Settlement Sheet Detail"
{
    // //SOC-SC 10-09-15
    //   Moved fields around for display as per Dereck
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/SettlementSheetDetail.rdlc';
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Purchase Contract Header"; "Purchase Contract Header")
        {
            RequestFilterFields = "No.";
            column(ContractNo; "No.")
            {
            }
            column(SettlementDate; "Purchase Contract Header"."Contract Date")
            {
            }
            column(ItemNo; "Purchase Contract Header"."Item No.")
            {
            }
            column(VendorNo; "Purchase Contract Header"."Vendor No.")
            {
            }
            column(VendorAddress1; gsVendorAddress[1])
            {
            }
            column(VendorAddress2; gsVendorAddress[2])
            {
            }
            column(VendorAddress3; gsVendorAddress[3])
            {
            }
            column(VendorAddress4; gsVendorAddress[4])
            {
            }
            column(VendorAddress5; gsVendorAddress[5])
            {
            }
            column(VendorAddress6; gsVendorAddress[6])
            {
            }
            column(VendorAddress7; gsVendorAddress[7])
            {
            }
            column(VendorAddress8; gsVendorAddress[8])
            {
            }
            column(CompanyInfo1; gsCompanyInfo[1])
            {
            }
            column(CompanyInfo2; gsCompanyInfo[2])
            {
            }
            column(CompanyInfo3; gsCompanyInfo[3])
            {
            }
            column(CompanyInfo4; gsCompanyInfo[4])
            {
            }
            column(CompanyInfo5; gsCompanyInfo[5])
            {
            }
            column(CompanyInfo6; gsCompanyInfo[6])
            {
            }
            column(CompanyInfo7; gsCompanyInfo[7])
            {
            }
            column(CompanyInfo8; gsCompanyInfo[8])
            {
            }
            column(ContractQty; "Purchase Contract Header".Quantity)
            {
            }
            dataitem(SettlementLn; "Purchase Contract Line")
            {
                DataItemLink = "Contract No." = FIELD("No.");
                DataItemTableView = WHERE("Transaction Type" = CONST(Settlement));
                RequestFilterFields = "Line No.";
                column(SettContractNo; SettlementLn."Contract No.")
                {
                }
                column(SettLineNo; SettlementLn."Line No.")
                {
                }
                column(SettTransType; SettlementLn."Transaction Type")
                {
                }
                column(SettPostingDate; SettlementLn."Posting Date")
                {
                }
                column(SettQty; SettlementLn.Quantity)
                {
                }
                column(SettUnitCost; SettlementLn."Settlement Unit Cost")
                {
                }
                column(SettLineAmt; SettlementLn."Settlement Line Amount")
                {
                }
                column(SettInvPc; SettlementLn."Invoice %")
                {
                }
                column(SettInvoiced; SettlementLn."Settlement Invoiced")
                {
                }
                column(SettlementNo; giSettlementNo)
                {
                }
                dataitem(InvLn; "Purchase Contract Line")
                {
                    DataItemLink = "Contract No." = FIELD("Contract No."), "Settled Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Contract No.", "Transaction Type", "Line No.") WHERE("Transaction Type" = CONST(Invoice));
                    column(InvContractNo; InvLn."Contract No.")
                    {
                    }
                    column(InvSettledLineNo; InvLn."Settled Line No.")
                    {
                    }
                    column(InvPostingDate; InvLn."Posting Date")
                    {
                    }
                    column(InvQty; InvLn.Quantity)
                    {
                    }
                    column(InvSettUnitCost; InvLn."Settlement Unit Cost")
                    {
                    }
                    column(InvSettLineAmt; InvLn."Settlement Line Amount")
                    {
                    }
                    column(InvPremDiscUnitCost; InvLn."Premium/ Discount Unit Cost")
                    {
                    }
                    column(InvCheckoffPc; InvLn."Check-off %")
                    {
                    }
                    column(InvUnitCost; InvLn."Invoice Unit Cost")
                    {
                    }
                    column(InvLineAmt; Round(InvLn."Invoice Line Amount", 0.01))
                    {
                    }
                    column(InvPremiumAmt; Round(InvLn."Premium/ Discount Amount", 0.01))
                    {
                    }
                }
                dataitem(Link; "Contract Rcpt-Invoice Link")
                {
                    DataItemLink = "Contract No." = FIELD("Contract No."), "Settlement Line No." = FIELD("Line No.");
                    column(SettRctLnNumber; giCnt)
                    {
                    }
                    column(SettRcptContractNo; Link."Contract No.")
                    {
                    }
                    column(SettRcptContractLineNo; Link."Settlement Line No.")
                    {
                    }
                    column(SettTicketNo; Link."Scale Ticket No.")
                    {
                    }
                    column(SettTicketDate; Link."Receipt Date")
                    {
                    }
                    column(SettMoisture; Link.Moisture)
                    {
                    }
                    column(SettSplits; Link.Splits)
                    {
                    }
                    column(SettTestWt; Link."Test Weight")
                    {
                    }
                    column(SettRcptGrossQty; Link."Recd. Gross Qty.")
                    {
                    }
                    column(SettRcptShrinkQty; Link."Recd. Shrink Qty.")
                    {
                    }
                    column(SettRcptNetQty; Link."Recd. Net Qty.")
                    {
                    }
                    column(SettUnitPremiumDiscount; Link."Unit Premium/Discount")
                    {
                    }
                    column(SettTicketPremiumDiscount; Link."Premium/Discount Amount")
                    {
                    }
                    column(SettCheckOff; Link."Check-off %")
                    {
                    }
                    column(RecdQtySettled; Link."Quantity Linked")
                    {
                    }
                    column(RecdQtyToPrint; Link."Quantity Linked")
                    {
                        DecimalPlaces = 0 : 2;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        giCnt += 1;
                        /*IF Number = 1 THEN BEGIN
                          recSettRcptLnTMP.FINDSET();
                        END ELSE BEGIN
                          recSettRcptLnTMP.NEXT();
                        END;
                        
                        //MESSAGE('Number is %1, Ticket No. is %2', Number, recSettRcptLn."Scale Ticket No.");
                        */

                    end;

                    trigger OnPreDataItem()
                    begin
                        /*IF giSettRcptLnCnt = 0 THEN BEGIN
                          CurrReport.BREAK;
                        END ELSE BEGIN
                          SETRANGE(Number, 1, giSettRcptLnCnt);
                        END;
                        */
                        giCnt := 0;

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    gdHdrNetQtyInPUOM := 0;
                    gdHdrGrossQtyInPUOM := 0;
                    gdHdrShrinkQtyInPUOM := 0;
                    gdUnitPremDisc := 0;
                    gsTicketNo := '';
                    gdMoisture := 0;
                    gdSplits := 0;
                    gdTestWt := 0;
                    gdCheckoff := 0;

                    giSettlementNo += 1;
                    recSettRcptLnTMP.Reset();
                    recSettRcptLnTMP.DeleteAll();

                    //giSettRcptLnCnt := GetSettRcptLines(SettlementLn, recSettRcptLnTMP);
                    //MESSAGE('receipt lines count %1', giSettRcptLnCnt);
                end;

                trigger OnPreDataItem()
                begin
                    giSettlementNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                recVendor: Record Vendor;
                recCompany: Record "Company Information";
            begin

                recCompany.Get();

                cuFormatAddress.FormatAddr(gsCompanyInfo, recCompany.Name, '', '', recCompany.Address, '', recCompany.City,
                            recCompany.County, recCompany."Post Code", '');
                CompressArray(gsCompanyInfo);

                if "Vendor No." <> '' then begin
                    recVendor.Get("Vendor No.");
                    cuFormatAddress.FormatAddr(gsVendorAddress, recVendor.Name, '', '', recVendor.Address, '', recVendor.City,
                               recVendor.County, recVendor."Post Code", '');
                    CompressArray(gsCompanyInfo);
                end;
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

    var
        gsVendorAddress: array[8] of Text[50];
        gsCompanyInfo: array[8] of Text[50];
        cuFormatAddress: Codeunit "Format Address";
        gdRatio: Decimal;
        gdNetQty: Decimal;
        gdGrossQty: Decimal;
        gdShrinkQty: Decimal;
        gdExtendedPrice: Decimal;
        gdTicketPremiumDiscount: Decimal;
        gdHdrNetQtyInPUOM: Decimal;
        gdHdrGrossQtyInPUOM: Decimal;
        gdHdrShrinkQtyInPUOM: Decimal;
        gdUnitPremDisc: Decimal;
        gsTicketNo: Text[50];
        gdMoisture: Decimal;
        gdSplits: Decimal;
        gdTestWt: Decimal;
        gdCheckoff: Decimal;
        recSettRcptLnTMP: Record "Purchase Contract Line" temporary;
        giSettRcptLnCnt: Integer;
        gdRecdQtySettled: Decimal;
        giCnt: Integer;
        giSettlementNo: Integer;

    [Scope('Internal')]
    procedure GetSettRcptLines(SettLn: Record "Purchase Contract Line"; var retSettRcptLnTMP: Record "Purchase Contract Line" temporary) retCntLines: Integer
    var
        recInvContractLn: Record "Purchase Contract Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        recRcptContractLn: Record "Purchase Contract Line";
        recPurchInvLn: Record "Purch. Inv. Line";
        recSettRcptLn: Record "Purchase Contract Line";
    begin
        retCntLines := 0;

        recSettRcptLn.Reset();
        recSettRcptLn.SetRange("Contract No.", SettLn."Contract No.");
        recSettRcptLn.SetRange("Transaction Type", recSettRcptLn."Transaction Type"::Receipt);

        recPurchInvLn.Reset();
        recPurchInvLn.SetRange("Purchase Contract No.", SettLn."Contract No.");

        recInvContractLn.Reset();
        recInvContractLn.SetRange("Contract No.", SettLn."Contract No.");
        recInvContractLn.SetRange("Transaction Type", recInvContractLn."Transaction Type"::Invoice);
        recInvContractLn.SetRange("Settled Line No.", SettLn."Line No.");
        if recInvContractLn.FindSet() then begin
            repeat
                recPurchInvLn.SetRange("Purchase Contract Inv Line No.", recInvContractLn."Line No.");
                //recPurchInvLn.SETRANGE("Auto-generating Process", recPurchInvLn."Auto-generating Process"::Receipt);
                recPurchInvLn.SetRange(Type, recPurchInvLn.Type::Item);
                recPurchInvLn.SetRange("Prepmt Item No.", '');
                if recPurchInvLn.FindSet() then begin
                    repeat
                        recPurchInvLn.GetPurchRcptLines(TempPurchRcptLine);
                        if TempPurchRcptLine.FindSet() then begin
                            repeat
                                if TempPurchRcptLine."Rcpt No." <> '' then begin
                                    recSettRcptLn.SetRange("Receipt No.", TempPurchRcptLine."Rcpt No.");
                                    recSettRcptLn.SetRange("Receipt Line No.", TempPurchRcptLine."Rcpt Line No.");
                                    if recSettRcptLn.FindSet() then begin
                                        repeat
                                            retSettRcptLnTMP.Init();
                                            retSettRcptLnTMP.TransferFields(recSettRcptLn);
                                            retSettRcptLnTMP."Recd/Settled Qty. Invoiced" := recPurchInvLn.Quantity;
                                            retSettRcptLnTMP."Recd. Qty. to Print" := TempPurchRcptLine.Quantity;
                                            if retSettRcptLnTMP.Insert() then;

                                        //retSettRcptLnTMP."Recd/Settled Qty. Invoiced" := recPurchInvLn.Quantity;
                                        //retSettRcptLnTMP."Recd. Qty. to Print"        := TempPurchRcptLine.Quantity;
                                        //retSettRcptLnTMP.MODIFY();
                                        //retSettRcptLn.MARK(TRUE);
                                        //MESSAGE('Rcpt No. %1', TempPurchRcptLine."Rcpt No.");
                                        until recSettRcptLn.Next = 0;
                                    end;
                                end;
                            until TempPurchRcptLine.Next = 0;
                        end;
                    until recPurchInvLn.Next = 0;
                end;

            until recInvContractLn.Next = 0;
            //recSettRcptLn.SETRANGE("Receipt No.");
            //recSettRcptLn.SETRANGE("Receipt Line No.");
            //retSettRcptLn.MARKEDONLY(TRUE);
            retSettRcptLnTMP.FindSet();
            retCntLines := retSettRcptLnTMP.Count();
            //MESSAGE('Count is %1', retCntLines);
        end;
    end;
}

