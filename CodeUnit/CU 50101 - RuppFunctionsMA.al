codeunit 50101 "Rupp Functions MA"
{
    // 
    // //SOC-MA 10-20-14
    //   Added function UpdateDueDate()


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure UpdateForGeographicalRestrictions(var SalesLine: Record "Sales Line")
    var
        recGeographicalRestr: Record "Geographical Restriction";
        recSH: Record "Sales Header";
        sCustNo: Code[30];
        sItemNo: Code[30];
        sProdCode: Code[30];
        sCountryCode: Code[10];
        sState: Text[30];
        sCity: Text[30];
        sZipCode: Text[30];
        bRestricted: Boolean;
        recRuppSetup: Record "Rupp Setup";
    begin
        //Called from Sales LIne

        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') and (SalesLine."Outstanding Quantity" <> 0) then begin
            sItemNo := SalesLine."No.";
            sProdCode := SalesLine."Product Code";
            recSH.Get(SalesLine."Document Type", SalesLine."Document No.");
            sCustNo := recSH."Sell-to Customer No.";
            sCountryCode := recSH."Ship-to Country/Region Code";
            if sCountryCode = '' then
                sCountryCode := 'US';
            sState := recSH."Ship-to County";
            sCity := recSH."Ship-to City";
            sZipCode := recSH."Ship-to Post Code";
            if ItemProductHasRestriction(sCustNo, sItemNo, sProdCode, sCountryCode, sState, sCity, sZipCode) then begin
                if not CustomerAllowedToBuy(sCustNo, sItemNo, sProdCode, sCountryCode, sState, sCity, sZipCode) then begin
                    recRuppSetup.Get();
                    SalesLine.Validate("Qty. Cancelled", SalesLine."Outstanding Quantity");
                    SalesLine."Cancelled Reason Code" := recRuppSetup."Geographical Restriction Code";
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure GetQtyLUOMandQtyCUOM(ItemNo: Code[20]; "UOM Code": Code[20]; Quantity: Decimal; var RetQtyInLUOM: Decimal; var RetQtyInCUOM: Decimal)
    var
        recItemUOM: Record "Item Unit of Measure";
    begin

        RetQtyInLUOM := 0;
        RetQtyInLUOM := 0;
        if recItemUOM.Get(ItemNo, "UOM Code") then begin
            RetQtyInLUOM := Quantity * recItemUOM."Qty. per Lowest UOM";
            RetQtyInCUOM := Quantity * recItemUOM."Qty. per Common UOM";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateDueDate(var SalesHeader: Record "Sales Header")
    var
        tDueDt: Date;
        iCurYr: Integer;
        recPmtTerms: Record "Payment Terms";
    begin
        //Called from Sales Header

        //SOC-MA 10-20-14
        with SalesHeader do begin
            if recPmtTerms.Get("Payment Terms Code") then begin
                if recPmtTerms."Due Date MM-DD" > '' then begin
                    iCurYr := Date2DMY(Today, 3);
                    if Evaluate(tDueDt, recPmtTerms."Due Date MM-DD" + '-' + Format(iCurYr)) then begin
                        if tDueDt < Today then
                            tDueDt := CalcDate('1Y', tDueDt);
                        "Due Date" := tDueDt;
                        "Pmt. Discount Date" := tDueDt;
                    end;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure ItemProductHasRestriction(CustomerNo: Code[30]; ItemNo: Code[30]; ProductCode: Code[30]; CountryCode: Text[50]; StateCode: Text[30]; City: Text[50]; ZipCode: Text[10]) HasRestriction: Boolean
    var
        recGeoRestriction: Record "Geographical Restriction";
    begin

        HasRestriction := false;
        recGeoRestriction.Reset;
        recGeoRestriction.SetFilter("Product Code", '%1|%2', '', ProductCode);
        recGeoRestriction.SetFilter("Item No.", '%1|%2', '', ItemNo);
        if recGeoRestriction.FindFirst() then begin
            recGeoRestriction.SetRange("Restriction Type", recGeoRestriction."Restriction Type"::"Not Allowed to Sell");
            recGeoRestriction.SetFilter("Allowed Customer No.", '%1|%2', '', CustomerNo);
            recGeoRestriction.SetFilter("Country Code", '%1|%2', '', CountryCode);
            recGeoRestriction.SetFilter(State, '%1|%2', '', StateCode);
            recGeoRestriction.SetFilter(City, '%1|%2', '', City);
            recGeoRestriction.SetFilter("Zip Code", '%1|%2', '', ZipCode);
            if recGeoRestriction.FindFirst() then
                HasRestriction := true;
        end;
    end;

    [Scope('Internal')]
    procedure CustomerAllowedToBuy(CustomerNo: Code[30]; ItemNo: Code[30]; ProductCode: Code[30]; CountryCode: Text[50]; StateCode: Text[30]; City: Text[50]; ZipCode: Text[10]) AllowedToBuy: Boolean
    var
        recGeoRestriction: Record "Geographical Restriction";
    begin

        AllowedToBuy := false;
        recGeoRestriction.Reset;
        recGeoRestriction.SetRange("Restriction Type", recGeoRestriction."Restriction Type"::"Allowed to Sell");
        recGeoRestriction.SetFilter("Allowed Customer No.", '%1|%2', '', CustomerNo);
        recGeoRestriction.SetFilter("Product Code", '%1|%2', '', ProductCode);
        recGeoRestriction.SetFilter("Item No.", '%1|%2', '', ItemNo);
        recGeoRestriction.SetFilter("Country Code", '%1|%2', '', CountryCode);
        recGeoRestriction.SetFilter(State, '%1|%2', '', StateCode);
        recGeoRestriction.SetFilter(City, '%1|%2', '', City);
        recGeoRestriction.SetFilter("Zip Code", '%1|%2', '', ZipCode);
        if recGeoRestriction.FindFirst() then
            AllowedToBuy := true;
    end;
}

