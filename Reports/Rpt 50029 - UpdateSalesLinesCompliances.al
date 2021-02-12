report 50029 "Update Sales Lines Compliances"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") WHERE ("Document Type" = CONST (Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            dataitem(MissingLicense; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "Outstanding Quantity" = FILTER (> 0), "Missing Reqd License" = CONST (true));

                trigger OnAfterGetRecord()
                var
                    bValidLicenseExists: Boolean;
                    bValidLiabilityWaiverExists: Boolean;
                    bValidQualityWaiverExists: Boolean;
                    recComplianceGrp: Record "Compliance Group";
                begin
                    //MESSAGE('License Missing: Order: %1, Item: %2', "Document No.", "No.");
                    giCnt += 1;
                    CalcFields("Compliance Group Code");
                    if recComplianceGrp.Get("Compliance Group Code") then begin
                        if not recComplianceGrp."License Required" then begin
                            giCntNotReqd += 1;
                            "Missing Reqd License" := false;
                            Modify();
                        end else begin
                            CompliaceMgt.CheckForValidCompliance("Compliance Group Code", "Sell-to Customer No.", '', '', false, bValidLicenseExists, bValidLiabilityWaiverExists, bValidQualityWaiverExists);
                            if bValidLicenseExists then begin
                                giCntDiscrepancy += 1;
                                "Missing Reqd License" := false;
                                Modify();
                                giCntCorrected += 1;
                            end;
                        end;
                    end else begin
                        "Missing Reqd License" := false;
                        Modify();
                        giCntCorrected += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('License Missing: %1, Not Reqd: %2, Discrepancy: %3, Corrected: %4', giCnt, giCntNotReqd, giCntDiscrepancy, giCntCorrected);
                end;

                trigger OnPreDataItem()
                begin
                    /*giCnt := 0;
                    giCntDiscrepancy := 0;
                    giCntNotReqd := 0;
                    giCntCorrected := 0;
                    */

                end;
            }
            dataitem(MissingLiab; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "Outstanding Quantity" = FILTER (> 0), "Missing Reqd Liability Waiver" = CONST (true));

                trigger OnAfterGetRecord()
                var
                    bValidLicenseExists: Boolean;
                    bValidLiabilityWaiverExists: Boolean;
                    bValidQualityWaiverExists: Boolean;
                    recComplianceGrp: Record "Compliance Group";
                begin
                    //MESSAGE('Liability Missing: Order: %1, Item: %2', "Document No.", "No.");
                    giCnt += 1;
                    CalcFields("Compliance Group Code");
                    if recComplianceGrp.Get("Compliance Group Code") then begin
                        if not recComplianceGrp."Liability Waiver Required" then begin
                            giCntNotReqd += 1;
                            "Missing Reqd Liability Waiver" := false;
                            Modify();
                        end else begin
                            CompliaceMgt.CheckForValidCompliance("Compliance Group Code", "Sell-to Customer No.", '', '', false, bValidLicenseExists, bValidLiabilityWaiverExists, bValidQualityWaiverExists);
                            if bValidLiabilityWaiverExists then begin
                                giCntDiscrepancy += 1;
                                "Missing Reqd Liability Waiver" := false;
                                Modify();
                                giCntCorrected += 1;
                            end;
                        end;
                    end else begin
                        "Missing Reqd Liability Waiver" := false;
                        Modify();
                        giCntCorrected += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('Liability Missing: %1, Not Reqd: %2, discrepancy: %3, Corrected: %4', giCnt, giCntNotReqd, giCntDiscrepancy, giCntCorrected);
                end;

                trigger OnPreDataItem()
                begin
                    /*giCnt := 0;
                    giCntDiscrepancy := 0;
                    giCntNotReqd := 0;
                    giCntCorrected := 0;
                    */

                end;
            }
            dataitem(MissingQual; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "Outstanding Quantity" = FILTER (> 0), "Missing Reqd Quality Release" = CONST (true));

                trigger OnAfterGetRecord()
                var
                    bValidLicenseExists: Boolean;
                    bValidLiabilityWaiverExists: Boolean;
                    bValidQualityWaiverExists: Boolean;
                    recComplianceGrp: Record "Compliance Group";
                begin
                    //MESSAGE('QualityWaiver Missing: Order: %1, Item: %2', "Document No.", "No.");
                    giCnt += 1;
                    CalcFields("Compliance Group Code");
                    if recComplianceGrp.Get("Compliance Group Code") then begin
                        if not recComplianceGrp."Quality Release Required" then begin
                            giCntNotReqd += 1;
                            "Missing Reqd Quality Release" := false;
                            Modify();
                        end else begin
                            CompliaceMgt.CheckForValidCompliance("Compliance Group Code", "Sell-to Customer No.", '', '', false, bValidLicenseExists, bValidLiabilityWaiverExists, bValidQualityWaiverExists);
                            if bValidQualityWaiverExists then begin
                                giCntDiscrepancy += 1;
                                "Missing Reqd Quality Release" := false;
                                Modify();
                                giCntCorrected += 1;
                            end;
                        end;
                    end else begin
                        "Missing Reqd Quality Release" := false;
                        Modify();
                        giCntCorrected += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('QualityWaiver Missing: %1, Not Reqd: %2, discrepancy: %3, Corrected: %4', giCnt, giCntNotReqd, giCntDiscrepancy, giCntCorrected);
                end;

                trigger OnPreDataItem()
                begin
                    /*giCnt := 0;
                    giCntDiscrepancy := 0;
                    giCntNotReqd := 0;
                    giCntCorrected := 0;
                    */

                end;
            }

            trigger OnAfterGetRecord()
            begin
                giCnt := 0;
                giCntDiscrepancy := 0;
                giCntNotReqd := 0;
                giCntCorrected := 0;

                giCntOrder += 1;
            end;

            trigger OnPostDataItem()
            begin
                Message('Compliances Missing: %1, Not Reqd: %2, Discrepancy: %3, Corrected: %4, Order: %5', giCnt, giCntNotReqd, giCntDiscrepancy, giCntCorrected, giCntOrder);
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
        if "Sales Header".GetFilters = '' then
            Error('Please enter order number and try again');
    end;

    var
        giCnt: Integer;
        CompliaceMgt: Codeunit "Compliance Management";
        giCntDiscrepancy: Integer;
        giCntNotReqd: Integer;
        giCntCorrected: Integer;
        giCntOrder: Integer;
}

