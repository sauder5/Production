codeunit 50002 "Rupp Business Logic"
{
    // //SOC-SC 08-09-15
    //   Populate Sales Line's "Shipping Charge" field with Resource's "Freight" field value
    // 
    // //SOC-SC 08-24-15
    //   As per Kristen, if there are any blank lines after the last line on the SO, then delete them at the time of releasing the SO.
    //   If there are any lines with "No." field not blank, but with blank description, error out
    // 
    // //SOC-SC 04-26-16
    //   When releasing the order, if the carrier is UPS, and if the destination is non-US, then Ship-to Phone No. cannot be blank.
    //   Also, check if World Ease has been checkmarked for the UPS Options Page for the order.
    // 
    // //RSI-KS 11-03-16
    //   Pull in Product status code if item status code is blank


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure ReleaseSO(var SalesHdr: Record "Sales Header")
    var
        recSL: Record "Sales Line";
        iLineNo: Integer;
        dTotalAmount: Decimal;
        recGLSetup: Record "General Ledger Setup";
        recDimension: Record Dimension;
        recCust: Record Customer;
        iLastLineNo: Integer;
        recShpgAgent: Record "Shipping Agent";
        recUPSOption: Record "UPS Option Page";
    begin
        with SalesHdr do begin
            if Cancelled then
                Error('This %1 %2 has been cancelled', SalesHdr."Document Type", SalesHdr."No.");

            if "On Hold" <> '' then
                Error('This %1 %2 is On Hold', SalesHdr."Document Type", SalesHdr."No.");

            recCust.Get("Sell-to Customer No.");
            recCust.TestField(Blocked, recCust.Blocked::" ");
            recCust.TestField("Gen. Bus. Posting Group");
            recCust.TestField("Customer Posting Group");

            if "Document Type" = "Document Type"::Order then begin
                if "Payment Terms Code" = '' then
                    Error('Please select a Payment Terms Code and then try again');

                //SOC-SC 04-26-16
                if not (SalesHdr."Ship-to Country/Region Code" in ['US', '']) then begin
                    if recShpgAgent.Get(SalesHdr."Shipping Agent Code") then begin
                        if recShpgAgent."Shipper Type" = recShpgAgent."Shipper Type"::UPS then begin
                            if SalesHdr."Ship-to Phone No. -CL-" = '' then begin
                                Error('Please enter Ship-to Phone No. and try again');
                            end;
                            recUPSOption.Reset();
                            recUPSOption.SetRange("Source Type", 36);
                            recUPSOption.SetRange("Source Subtype", SalesHdr."Document Type");
                            recUPSOption.SetRange("Source ID", SalesHdr."No.");
                            if not recUPSOption.FindFirst() and (SalesHdr."Ship-to Country/Region Code" = 'CA') then begin
                                Error('Please set up UPS Option and then try again');
                            end else begin
                                if (not recUPSOption."World Ease") and (SalesHdr."Ship-to Country/Region Code" = 'CA') then begin
                                    Error('Please flag the order as World Ease in UPS Options Page for the Order and then try again');
                                end;
                            end;
                        end;
                    end;
                end;
                //SOC-SC 04-26-16

                recSL.Reset();
                recSL.SetRange("Document Type", "Document Type");
                recSL.SetRange("Document No.", "No.");
                recSL.SetFilter("Outstanding Quantity", '<>0');
                recSL.SetFilter("Qty. Cancelled", '<>0');
                recSL.SetRange("Cancelled Reason Code", '');
                if recSL.FindFirst() then begin
                    Error('Sales Line No. %1 is cancelled. Please enter a Cancelled Reason Code', recSL."Line No.");
                end;

                recSL.SetRange("Qty. Cancelled", 0);

                recGLSetup.Get();
                if recGLSetup."Global Dimension 1 Code" <> '' then begin
                    recDimension.Get(recGLSetup."Global Dimension 1 Code");
                    recSL.SetRange(Type, recSL.Type::Item);
                    recSL.SetRange("Shortcut Dimension 1 Code", '');
                    if recSL.FindFirst() then begin
                        Error('Please enter %1 for Sales Line for item %2', recDimension."Code Caption", recSL."No.");
                    end;
                    recSL.SetRange("Shortcut Dimension 1 Code");
                    recSL.SetRange(Type);
                end;

                recSL.Reset();
                recSL.SetRange("Document Type", "Document Type");
                recSL.SetRange("Document No.", "No.");
                recSL.SetRange("Unit Price", 0);
                recSL.SetFilter(Quantity, '<>0');
                recSL.SetRange("Unit Price Reason Code", '');
                if recSL.FindFirst() then
                    Error('Unit Price cannot be zero without a valid reason for Sales Line No. %1', recSL."Line No.");

                recSL.SetRange("Unit Price");
                ;
                if recSL.FindSet() then begin
                    repeat
                        if recSL."Unit Price" <> recSL."Original Unit Price" then
                            Error('The Unit Price of Sales Line No. %1 has been changed. Please enter the Unit Price Reason Code', recSL."Line No.");
                    until recSL.Next = 0;
                end;

                SalesHdr.CalcFields(SalesHdr."Rupp Missing Reqd License", SalesHdr."Rupp Missing Reqd Liability", SalesHdr."Rupp Missing Reqd Quality Rel");
                if SalesHdr."Rupp Missing Reqd License" or SalesHdr."Rupp Missing Reqd Liability" or SalesHdr."Rupp Missing Reqd Quality Rel" then begin
                    if not Confirm('There are compliances required for this order. Do you still want to release the order?', false) then begin
                        exit;
                    end;
                end;

                //SOC-SC 08-24-15
                recSL.Reset();
                recSL.SetRange("Document Type", "Document Type");
                recSL.SetRange("Document No.", "No.");
                recSL.SetFilter("No.", '<>%1', '');
                recSL.SetRange(Description, '');
                if recSL.FindFirst() then begin
                    Error('Line with %1 does not have a Description. PLease enter a Description and try again', recSL."No.");
                end;

                recSL.SetRange("No.");
                recSL.SetFilter(Description, '<>%1', '');
                if recSL.FindLast() then begin
                    iLastLineNo := recSL."Line No.";
                    recSL.SetFilter("Line No.", '>%1', iLastLineNo);
                    recSL.SetRange("No.", '');
                    recSL.SetRange(Description, '');
                    if recSL.FindSet() then begin
                        recSL.DeleteAll();
                    end;
                end;
                //SOC-SC 08-24-15
            end;
        end;
    end;

    [Scope('Internal')]
    procedure CheckSalesLine_No(recSL: Record "Sales Line")
    var
        RuppFn: Codeunit "Rupp Functions";
        CustPmtLink: Codeunit "Cust. Payment Link Mgt.";
    begin
        //Called from Sales Line "No." field OnValidate()
        CheckForFreight(recSL);
        RuppFn.CheckSalesLineDuplicateExists(recSL);
        CustPmtLink.CheckSalesLnSeasDisc(recSL);
    end;

    [Scope('Internal')]
    procedure UpdateSalesLnRuppFields(var SalesLn: Record "Sales Line")
    var
        recItem: Record Item;
        recProduct: Record Product;
        recSalesHdr: Record "Sales Header";
        ComplianceMgt: Codeunit "Compliance Management";
        recResource: Record Resource;
    begin
        //Called from Sales Line "No." field OnValidate()
        //Clear custom field values first
        SalesLn."Product Code" := '';
        SalesLn."Original Item No." := '';
        SalesLn."Inventory Status Code" := '';
        SalesLn."Compliance Group Code" := '';
        SalesLn."Compliance Group Code" := '';
        //        SalesLn."Rupp Missing License" := false;
        //        SalesLn."Rupp Missing Liability Waiver" := false;
        //        SalesLn."Rupp Missing Quality Release" := false;

        if SalesLn.Type = SalesLn.Type::Item then begin
            if SalesLn."No." <> '' then begin
                //Fields "Product Code" and "Seasonal cash disc code"
                recItem.Get(SalesLn."No.");
                recItem.CalcFields("Seasonal Cash Disc Code");
                SalesLn."Product Code" := recItem."Product Code";
                if recItem."Seasonal Cash Disc Code" <> '' then begin
                    SalesLn."Seasonal Cash Disc Code" := recItem."Seasonal Cash Disc Code";
                    if SalesLn."Seasonal Cash Disc Code" <> '' then begin
                        recSalesHdr.Get(SalesLn."Document Type", SalesLn."Document No.");
                        SalesLn.Validate("Salesperson Code", recSalesHdr."Salesperson Code");
                        if recSalesHdr."Seasonal Cash Disc Code" = '' then begin
                            recSalesHdr."Seasonal Cash Disc Code" := SalesLn."Seasonal Cash Disc Code";
                            recSalesHdr.Modify();
                        end;
                    end;
                end;

                //Field: "Compliance Group Code"
                //                ComplianceMgt.UpdateSalesLineCompliance(SalesLn);
                SalesLn.CalcFields("Rupp Missing Liability Waiver", "Rupp Missing License", "Rupp Missing Quality Release");

                //Field: "Original Item No."
                SalesLn."Original Item No." := SalesLn."No.";

                //Field: "Inventory Status Code"
                SalesLn."Inventory Status Code" := recItem."Inventory Status Code";

                // If item status code is blank, check product code
                if recItem."Inventory Status Code" = '' then
                    if recProduct.Get(recItem."Product Code") then
                        SalesLn."Inventory Status Code" := recProduct."Inventory Status Code";
            end;
            //End;

            //SOC-SC 08-09-15
        end else begin
            if SalesLn.Type = SalesLn.Type::Resource then begin
                if recResource.Get(SalesLn."No.") then begin
                    SalesLn."Shipping Charge" := recResource.Freight;
                end;
            end;
        end;
        //SOC-SC 08-09-15
    end;

    [Scope('Internal')]
    procedure CheckToPrintSeasDiscSchedOnOrdConf(SalesHdr: Record "Sales Header") retOkToPrint: Boolean
    var
        recRuppSetup: Record "Rupp Setup";
        bCustMadeAPmt: Boolean;
        bIndicatedPmt: Boolean;
        recCust: Record Customer;
        recCustPostingGroup: Record "Customer Posting Group";
        recPmtTerms: Record "Payment Terms";
    begin
        retOkToPrint := false;
        /*Conditions as per Kristen: Order is $250 or more and cust has not made a payment or indcated another type of payment such as credit card, John Deere;
        Class ID's allowed for this on Vegetables: VRTL, VGRBPGH,VGRFM,VGRCOMM,VGRCHAR,VHG,VUNIV;
        Need to NOT print on the last day of a month that month's disc schedule.
        */

        SalesHdr.CalcFields("Amount Including VAT");
        recRuppSetup.Get();
        if recRuppSetup."Min Amt to Print Sched on Conf" <> 0 then begin
            if SalesHdr."Amount Including VAT" >= recRuppSetup."Min Amt to Print Sched on Conf" then begin
                if recCust.Get(SalesHdr."Sell-to Customer No.") then begin
                    recCust.CalcFields(Balance);
                    if recCust.Balance < 0 then begin
                        if Abs(recCust.Balance) < SalesHdr."Amount Including VAT" then begin
                            if recPmtTerms.Get(SalesHdr."Payment Terms Code") then begin
                                if recPmtTerms."Print Disc Sched on Ord Conf." then begin
                                    if not (bIndicatedPmt) then begin
                                        if recCustPostingGroup.Get(recCust."Customer Posting Group") then begin
                                            if recCustPostingGroup."To Print Seas Disc Sch on Conf" then begin
                                                retOkToPrint := true;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

    end;

    [Scope('Internal')]
    procedure CheckCustReasonCodeIfBlocked(CustNo: Code[20])
    var
        recCust: Record Customer;
    begin
        //Not called from anywhere as of 08/01/15
        recCust.Get(CustNo);
        if recCust.Blocked <> 0 then begin
            if recCust."Blocked Reason Code" = '' then begin
                Error('Customer %1 is Blocked, but the Blocked Reason Code has not been specified. Please enter Blocked Reason Code on the Customer and try again', CustNo);
            end;
        end;
    end;

    local procedure CheckForFreight(SalesLn: Record "Sales Line")
    var
        recSalesLn: Record "Sales Line";
        recSH: Record "Sales Header";
        recResource: Record Resource;
    begin
        if SalesLn.Type = SalesLn.Type::Resource then begin
            if recResource.Get(SalesLn."No.") then begin
                if recResource.Freight then begin
                    recSH.Get(SalesLn."Document Type", SalesLn."Document No.");
                    if recSH."Freight Charges Option" = recSH."Freight Charges Option"::"One Time Charge" then begin
                        recSalesLn.Reset();
                        recSalesLn.SetRange("Document Type", SalesLn."Document Type");
                        recSalesLn.SetRange("Document No.", SalesLn."Document No.");
                        recSalesLn.SetRange("Shipping Charge", true);
                        if recSalesLn.FindFirst() then begin
                            Error('Freight Charges Option is %1, and there is already a Freight line.', recSH."Freight Charges Option");
                        end;
                    end;
                end;
            end;
        end;
    end;
}

