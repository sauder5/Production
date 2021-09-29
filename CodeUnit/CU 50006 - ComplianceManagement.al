codeunit 50006 "Compliance Management"
{
    // //SOC-SC 01-04-16
    //   Added commit in UpdateSalesLineCompliance() before calling the check function


    trigger OnRun()
    begin
    end;

    var
        cPrevItemNo: Code[20];

    procedure UpdateSalesLineComplianceHeader(SalesHead: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
            SetFilter("Document Type", '%1', SalesHead."Document Type");
            SetFilter("Document No.", SalesHead."No.");
            if findset then
                repeat
                    UpdateSalesLineCompliance(SalesLine);
                    salesline.modify();
                until next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateSalesLineCompliance(var SalesLine: Record "Sales Line")
    var
        recComplianceItem: Record "Compliance Group Product Item";
    begin
        //Called from Sales Line table
        if SalesLine.Type = SalesLine.Type::Item then begin
            recComplianceItem.Reset();
            recComplianceItem.SetRange("Item No.", SalesLine."No.");
            if recComplianceItem.FindFirst() then begin
                SalesLine."Compliance Group Code" := recComplianceItem."Waiver Code";
                UpdateComplianceStatus(SalesLine, recComplianceItem);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateComplianceStatus(var SalesLine: Record "Sales Line"; recComplianceItem: Record "Compliance Group Product Item")
    var
        recCompliance: Record Compliance;
        recSalesHdr: Record "Sales Header";
    begin
        /*    recCompliance.Reset();
            recCompliance.SetRange("Waiver Code", recComplianceItem."Waiver Code");
            recCompliance.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
            if recSalesHdr.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                if recSalesHdr."Ship-to Code" <> '' then begin
                    recCompliance.SetRange("Ship-to Code", recSalesHdr."Ship-to Code");
                end;
            end;

            //SalesLine."Missing Reqd License" := (recComplianceItem."License Required" AND NOT recCompliance.FINDFIRST());
            if recComplianceItem."License Required" then begin
                recCompliance.SetFilter("License No.", '<>%1', '');
                recCompliance.SetFilter("License Expiration Date", '%1|>=%2', 0D, WorkDate);
                SalesLine."Missing Reqd License" := not recCompliance.FindFirst();
                recCompliance.SetRange("License No.");
                recCompliance.SetRange("License Expiration Date");
            end;

            //SalesLine."Missing Reqd Liability Waiver" := (recComplianceItem."Liability Waiver Required" AND NOT recCompliance.FINDFIRST());
            if recComplianceItem."Liability Waiver Required" then begin
                recCompliance.SetRange("Liability Waiver Signed", true);
                recCompliance.SetFilter("Liability Waiver Start Date", '%1|<=%2', 0D, WorkDate);
                recCompliance.SetFilter("Liability Waiver End Date", '%1|>=%2', 0D, WorkDate);
                SalesLine."Missing Reqd Liability Waiver" := not recCompliance.FindFirst();
                recCompliance.SetRange("Liability Waiver Signed");
                recCompliance.SetRange("Liability Waiver Start Date");
                recCompliance.SetRange("Liability Waiver End Date");
            end;

            //SalesLine."Missing Reqd Quality Release" := (recComplianceItem."Quality Release Required" AND NOT recCompliance.FINDFIRST());
            if recComplianceItem."Quality Release Required" then begin
                recCompliance.SetRange("Quality Release Signed", true);
                recCompliance.SetFilter("Quality Release Start Date", '%1|<=%2', 0D, WorkDate);
                recCompliance.SetFilter("Quality Release End Date", '%1|>=%2', 0D, WorkDate);
                SalesLine."Missing Reqd Quality Release" := not recCompliance.FindFirst();
            end;
            // SalesLine.Modify();
            */
    end;

    [Scope('Internal')]
    procedure ShowCompliancesReqd(SalesHdr: Record "Sales Header")
    var
        recComplianceItem: Record "Compliance Group Product Item";
        recSL: Record "Sales Line";
        pgComplGroupItem: Page "Compliance Group Items";
        recCompliance: Record Compliance;
        ComplianceMgt: Codeunit "Compliance Management";
        giCnt: Integer;
        recComplianceItemTmp: Record "Compliance Group Product Item" temporary;
        RecordRefVar: RecordRef;
    begin
        //Called from page 9305 and 42

        recComplianceItemTmp.Reset();
        if recComplianceItemTmp.FindSet() then begin
            RecordRefVar.GetTable(recComplianceItemTmp);
            if RecordRefVar.IsTemporary then begin
                recComplianceItemTmp.DeleteAll();
            end else
                Error('The table is not temporary');
        end;

        recSL.Reset();
        recSL.SetRange("Document Type", SalesHdr."Document Type");
        recSL.SetRange("Document No.", SalesHdr."No.");
        recSL.SetRange(Type, recSL.Type::Item);
        recSL.SetFilter("Outstanding Quantity", '<>0');
        if recSL.FindSet() then begin
            repeat
                recSL.CalcFields("Compliance Group Code", "Rupp Missing Liability Waiver", "Rupp Missing License", "Rupp Missing Quality Release");
                recComplianceItemTmp.Init();
                recComplianceItemTmp."Waiver Code" := recSL."Compliance Group Code";
                recComplianceItemTmp."Item No." := recSL."No.";

                if recSL."Rupp Missing License" then begin
                    //recComplianceItem.MARK(TRUE);
                    recComplianceItemTmp."License Required" := true;
                    recComplianceItemTmp.Insert();
                end;

                if recSL."Rupp Missing Liability Waiver" then begin
                    //recComplianceItem.MARK(TRUE);
                    recComplianceItemTmp."Liability Waiver Required" := true;
                    if not recComplianceItemTmp.Insert then
                        recComplianceItemTmp.Modify();
                end;

                if recSL."Rupp Missing Quality Release" then begin
                    //recComplianceItem.MARK(TRUE);
                    recComplianceItemTmp."Quality Release Required" := true;
                    if not recComplianceItemTmp.Insert then
                        recComplianceItemTmp.Modify();
                end;
            until recSL.Next = 0;
            if recComplianceItemTmp.FindSet() then;
            //MESSAGE('Count is %1', recComplianceItem.COUNT());
            PAGE.RunModal(0, recComplianceItemTmp);
        end;

        /*recComplianceItem.RESET();
        
        recSL.RESET();
        recSL.SETRANGE("Document Type", SalesHdr."Document Type");
        recSL.SETRANGE("Document No.", SalesHdr."No.");
        recSL.SETRANGE(Type, recSL.Type::Item);
        recSL.SETFILTER("Outstanding Quantity", '<>0');
        IF recSL.FINDSET() THEN BEGIN
          REPEAT
            recComplianceItem.SETRANGE("Item No.", recSL."No.");
            IF recComplianceItem.FINDFIRST() THEN BEGIN
              IF recSL."Missing Reqd License" THEN BEGIN
                recComplianceItem.MARK(TRUE);
              END;
        
              IF recSL."Missing Reqd Liability Waiver" THEN BEGIN
                recComplianceItem.MARK(TRUE);
              END;
        
              IF recSL."Missing Reqd Quality Release" THEN BEGIN
                recComplianceItem.MARK(TRUE);
              END;
            END;
          UNTIL recSL.NEXT = 0;
          recComplianceItem.SETRANGE("Item No.");
          recComplianceItem.FINDSET();
          recComplianceItem.MARKEDONLY(TRUE);
          //MESSAGE('Count is %1', recComplianceItem.COUNT());
          PAGE.RUNMODAL(0, recComplianceItem);
        END;
        */

    end;

    [Scope('Internal')]
    procedure UpdateSalesLinesForCompliance(var Compliance: Record Compliance; ComplDeleted: Boolean)
    var
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
        //        recComplianceItem: Record "Compliance Group Product Item";
        //        bMissingReqdLicense: Boolean;
        //        bMissingReqdLiability: Boolean;
        //        bMissingReqdQualityWaiver: Boolean;
        bValidLicenseExists: Boolean;
        bValidLiabilityWaiverExists: Boolean;
        bValidQualityWaiverExists: Boolean;
        bModify: Boolean;
    begin
        /*        //Called by Table 50026 Compliance
                recComplianceItem.Reset();
                recComplianceItem.SetRange("Waiver Code", Compliance."Waiver Code");

                recSalesLine.Reset();
                recSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Shipment Date");
                recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetFilter("No.", '<>%1', '');
                recSalesLine.SetRange("Compliance Group Code", Compliance."Waiver Code");
                //IF NOT ComplDeleted THEN BEGIN
                recSalesLine.SetRange("Sell-to Customer No.", Compliance."Customer No.");
                if Compliance."Ship-to Code" <> '' then
                    recSalesLine.SetRange("Ship-to Code", Compliance."Ship-to Code");
                //END;
                if recSalesLine.FindSet() then begin
                    cPrevItemNo := '';
                    bMissingReqdLicense := false;
                    bMissingReqdLiability := false;
                    bMissingReqdQualityWaiver := false;

                    repeat
                        if recSalesLine."No." <> cPrevItemNo then begin
                            recSalesLine.CalcFields("Ship-to Code");
                            Commit; //SOC-SC 01-04-16
                            CheckForValidCompliance(Compliance."Waiver Code", recSalesLine."Sell-to Customer No.", recSalesLine."Ship-to Code", Compliance.Code, ComplDeleted,
                                    bValidLicenseExists, bValidLiabilityWaiverExists, bValidQualityWaiverExists);

                            if not ComplDeleted then begin
                                if not bValidLicenseExists then
                                    if ((Compliance."License No." <> '') and ((Compliance."License Expiration Date" = 0D) or (Compliance."License Expiration Date" > WorkDate))) then
                                        bValidLicenseExists := true;

                                if not bValidLiabilityWaiverExists then
                                    if Compliance."Liability Waiver Signed" and
                                      ((Compliance."Liability Waiver Start Date" = 0D) or (Compliance."Liability Waiver Start Date" <= WorkDate)) and
                                      ((Compliance."Liability Waiver End Date" = 0D) or (Compliance."Liability Waiver End Date" >= WorkDate)) then
                                        bValidLiabilityWaiverExists := true;

                                if not bValidQualityWaiverExists then
                                    if Compliance."Quality Release Signed" and
                                      ((Compliance."Quality Release Start Date" = 0D) or (Compliance."Quality Release Start Date" <= WorkDate)) and
                                      ((Compliance."Quality Release End Date" = 0D) or (Compliance."Quality Release End Date" >= WorkDate)) then
                                        bValidQualityWaiverExists := true;

                            end;

                            recComplianceItem.SetRange("Item No.", recSalesLine."No.");
                            if recComplianceItem.FindFirst() then begin

                                if recComplianceItem."License Required" then
                                    bMissingReqdLicense := not bValidLicenseExists;

                                if recComplianceItem."Liability Waiver Required" then
                                    bMissingReqdLiability := not bValidLiabilityWaiverExists;

                                if recComplianceItem."Quality Release Required" then
                                    bMissingReqdQualityWaiver := not bValidQualityWaiverExists;

                            end;
                            cPrevItemNo := recSalesLine."No.";
                        end;

                        bModify := false;
                        if recSalesLine."Missing Reqd License" <> bMissingReqdLicense then begin
                            recSalesLine.Validate("Missing Reqd License", bMissingReqdLicense);
                            bModify := true;
                        end;
                        if recSalesLine."Missing Reqd Liability Waiver" <> bMissingReqdLiability then begin
                            recSalesLine.Validate("Missing Reqd Liability Waiver", bMissingReqdLiability);
                            bModify := true;
                        end;
                        if recSalesLine."Missing Reqd Quality Release" <> bMissingReqdQualityWaiver then begin
                            recSalesLine.Validate("Missing Reqd Quality Release", bMissingReqdQualityWaiver);
                            bModify := true;
                        end;

                        if bModify then
                            recSalesLine.Modify();
                    until recSalesLine.Next = 0;
                end; */
    end;

    [Scope('Internal')]
    procedure CheckForValidCompliance(WaiverCode: Code[20]; CustNo: Code[20]; ShipToCode: Code[10]; ComplCode: Code[10]; ComplDeleted: Boolean; var retValidLicenseExists: Boolean; var retValidLiabilityWaiverExists: Boolean; var retValidQualityWaiverExists: Boolean)
    var
        recCompliance: Record Compliance;
        bExists: Boolean;
    begin
        retValidLicenseExists := false;
        retValidLiabilityWaiverExists := false;
        retValidQualityWaiverExists := false;

        recCompliance.Reset();
        if WaiverCode <> '' then
            recCompliance.SetRange("Waiver Code", WaiverCode);
        recCompliance.SetRange("Customer No.", CustNo);
        if ShipToCode <> '' then
            recCompliance.SetRange("Ship-to Code", ShipToCode);

        if ComplDeleted then
            recCompliance.SetFilter(Code, '<>%1', ComplCode);

        recCompliance.SetFilter("License No.", '<>%1', '');
        recCompliance.SetFilter("License Expiration Date", '%1|>=%2', 0D, WorkDate);
        bExists := recCompliance.FindFirst();
        retValidLicenseExists := recCompliance.FindFirst();
        recCompliance.SetRange("License No.");
        recCompliance.SetRange("License Expiration Date");

        recCompliance.SetRange("Liability Waiver Signed", true);
        recCompliance.SetFilter("Liability Waiver Start Date", '%1|<=%2', 0D, WorkDate);
        recCompliance.SetFilter("Liability Waiver End Date", '%1|>=%2', 0D, WorkDate);
        retValidLiabilityWaiverExists := recCompliance.FindFirst();
        recCompliance.SetRange("Liability Waiver Signed");
        recCompliance.SetRange("Liability Waiver Start Date");
        recCompliance.SetRange("Liability Waiver End Date");

        recCompliance.SetRange("Quality Release Signed", true);
        recCompliance.SetFilter("Quality Release Start Date", '%1|<=%2', 0D, WorkDate);
        recCompliance.SetFilter("Quality Release End Date", '%1|>=%2', 0D, WorkDate);
        retValidQualityWaiverExists := recCompliance.FindFirst();
    end;

    [Scope('Internal')]
    procedure UpdateSalesLineOnModify(var Compliance: Record Compliance; iFieldNo: Integer)
    begin
        case iFieldNo of
            Compliance.FieldNo("License No."), Compliance.FieldNo("License Expiration Date"):
                begin
                    if Compliance."License No." = '' then begin
                        UpdateSLWithLicense(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", false);
                    end else begin
                        if (Compliance."License Expiration Date" >= WorkDate) or (Compliance."License Expiration Date" = 0D) then begin
                            UpdateSLWithLicense(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", true);
                        end;
                    end;
                end;
            Compliance.FieldNo("Liability Waiver Signed"), Compliance.FieldNo("Liability Waiver Start Date"), Compliance.FieldNo("Liability Waiver End Date"):
                begin
                    if Compliance."Liability Waiver Signed" then begin
                        if ((Compliance."Liability Waiver Start Date" <= WorkDate) or (Compliance."Liability Waiver Start Date" = 0D)) and
                          ((Compliance."Liability Waiver End Date" = 0D) or (Compliance."Liability Waiver End Date" >= WorkDate)) then begin
                            UpdateSLWithLiability(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", true);
                        end;
                    end else begin
                        UpdateSLWithLiability(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", false);
                    end;
                end;
            Compliance.FieldNo("Quality Release Signed"), Compliance.FieldNo("Quality Release Start Date"), Compliance.FieldNo("Quality Release End Date"):
                begin
                    if Compliance."Quality Release Signed" then begin
                        if ((Compliance."Quality Release Start Date" <= WorkDate) or (Compliance."Quality Release Start Date" = 0D)) and
                          ((Compliance."Quality Release End Date" = 0D) or (Compliance."Quality Release End Date" >= WorkDate)) then begin
                            UpdateSLWithQualityWaiver(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", true);
                        end;
                    end else begin
                        UpdateSLWithQualityWaiver(Compliance."Waiver Code", Compliance."Customer No.", Compliance."Ship-to Code", false);
                    end;
                end;
            else
                exit;
        end;
    end;

    local procedure UpdateSLWithLicense(WaiverCode: Code[20]; CustNo: Code[20]; ShipToCode: Code[10]; ValidLicense: Boolean)
    var
        recSalesLine: Record "Sales Line";
    begin
        /*        recSalesLine.Reset();
                recSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Shipment Date");
                recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetFilter("No.", '<>%1', '');
                recSalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
                recSalesLine.SetRange("Compliance Group Code", WaiverCode);
                recSalesLine.SetRange("Sell-to Customer No.", CustNo);
                if ShipToCode <> '' then begin
                    recSalesLine.SetRange("Ship-to Code", ShipToCode);
                end;
                recSalesLine.SetRange("Rupp Missing License", ValidLicense);
                if recSalesLine.FindSet() then begin
                    recSalesLine.ModifyAll("Missing Reqd License", not ValidLicense);
                end;*/
    end;

    local procedure UpdateSLWithLiability(WaiverCode: Code[20]; CustNo: Code[20]; ShipToCode: Code[10]; ValidLiability: Boolean)
    var
        recSalesLine: Record "Sales Line";
    begin
        /*        recSalesLine.Reset();
                recSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Shipment Date");
                recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetFilter("No.", '<>%1', '');
                recSalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
                recSalesLine.SetRange("Compliance Group Code", WaiverCode);
                recSalesLine.SetRange("Sell-to Customer No.", CustNo);
                if ShipToCode <> '' then begin
                    recSalesLine.SetRange("Ship-to Code", ShipToCode);
                end;
                recSalesLine.SetRange("Missing Reqd Liability Waiver", ValidLiability);
                if recSalesLine.FindSet() then begin
                    recSalesLine.ModifyAll("Missing Reqd Liability Waiver", not ValidLiability);
                end;*/
    end;

    local procedure UpdateSLWithQualityWaiver(WaiverCode: Code[20]; CustNo: Code[20]; ShipToCode: Code[10]; ValidQualityWaiver: Boolean)
    var
        recSalesLine: Record "Sales Line";
    begin
        /*        recSalesLine.Reset();
                recSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Shipment Date");
                recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetFilter("No.", '<>%1', '');
                recSalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
                recSalesLine.SetRange("Compliance Group Code", WaiverCode);
                recSalesLine.SetRange("Sell-to Customer No.", CustNo);
                if ShipToCode <> '' then begin
                    recSalesLine.SetRange("Ship-to Code", ShipToCode);
                end;
                recSalesLine.SetRange("Missing Reqd Quality Release", ValidQualityWaiver);
                if recSalesLine.FindSet() then begin
                    recSalesLine.ModifyAll("Missing Reqd Quality Release", not ValidQualityWaiver);
                end;*/
    end;
}

