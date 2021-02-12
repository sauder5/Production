codeunit 50099 "Data Cleaning -MastersAndTrans"
{
    // //Use before CRP2 and before Go Live


    trigger OnRun()
    begin

        DoCleaning();
        Message('Done!');
    end;

    var
        Text001: Label 'For sercurity reasons data cleaning can only be performed\with a NSC 004/006 license.';
        Text002: Label 'Current process @1@@@@@@@@@@@@@@@\';
        Text003: Label 'Current status  #2###################';
        Text004: Label 'Table No.';
        Window: Dialog;
        StatusCounter: Integer;
        TotalRecNo: Integer;

    [Scope('Internal')]
    procedure DoCleaning()
    begin
        if not Confirm('Do you want to delete master and transactional data?', false) then
            exit;

        /*
        IF (COPYSTR(SERIALNUMBER,7,3) <> '002') AND (COPYSTR(SERIALNUMBER,7,3) <> '004') AND (COPYSTR(SERIALNUMBER,7,3) <> '006') THEN
          ERROR(Text001);
        */
        Window.Open(Text002 + Text003);
        Clear(StatusCounter);
        TotalRecNo := 50;


        //**********************************//
        // Master Records and Setup Records //
        //**********************************//
        CleanTable(DATABASE::"Standard Text");
        CleanTable(DATABASE::"Shipment Method");
        CleanTable(DATABASE::"Salesperson/Purchaser");
        CleanTable(DATABASE::Location);
        CleanTable(DATABASE::"BOM Component");
        CleanTable(DATABASE::"Customer Posting Group");
        CleanTable(DATABASE::"Vendor Posting Group");
        CleanTable(DATABASE::"Inventory Posting Group");
        //CleanTable(DATABASE::Resource);
        //CleanTable(DATABASE::"Resource Unit of Measure");
        CleanTable(DATABASE::"Resource Unit of Measure");       //205
        CleanTable(DATABASE::"Gen. Business Posting Group");
        CleanTable(DATABASE::"Gen. Product Posting Group");
        CleanTable(DATABASE::"General Posting Setup");
        CleanTable(DATABASE::"Transport Method");
        CleanTable(DATABASE::"Tariff Number");
        CleanTable(DATABASE::"Bank Account Posting Group");
        CleanTable(DATABASE::"Customer Bank Account");
        CleanTable(DATABASE::"Vendor Bank Account");
        //CleanTable(DATABASE::"Shipping Agent");
        CleanTable(DATABASE::"VAT Business Posting Group");
        CleanTable(DATABASE::"VAT Product Posting Group");
        CleanTable(DATABASE::"VAT Posting Setup");
        CleanTable(DATABASE::"Currency Exchange Rate");
        CleanTable(DATABASE::"Customer Discount Group");
        CleanTable(DATABASE::"Item Discount Group");
        CleanTable(DATABASE::"Customer Price Group");
        CleanTable(DATABASE::Dimension);
        CleanTable(DATABASE::"Dimension Value");
        CleanTable(DATABASE::"Dimension Combination");
        CleanTable(DATABASE::"Dimension Value Combination");
        CleanTable(DATABASE::"Default Dimension");
        CleanTable(DATABASE::"Dimension ID Buffer");
        CleanTable(DATABASE::"Default Dimension Priority");
        CleanTable(DATABASE::"Dimension Buffer");
        CleanTable(DATABASE::"Dimension Translation");
        CleanTable(DATABASE::"IC G/L Account");
        CleanTable(DATABASE::"IC Dimension");
        CleanTable(DATABASE::"IC Dimension Value");
        CleanTable(DATABASE::"IC Partner");
        CleanTable(DATABASE::"IC Outbox Transaction");
        //        CleanTable(DATABASE::"Approval Setup");
        //        CleanTable(DATABASE::"Approval Code");
        //        CleanTable(DATABASE::"Approval Templates");
        //        CleanTable(DATABASE::"Job Queue");
        CleanTable(DATABASE::"Job Queue Category");
        CleanTable(DATABASE::"Job Queue Entry");
        CleanTable(DATABASE::"Dimension Set Entry");
        CleanTable(DATABASE::"Dimension Set Tree Node");
        CleanTable(DATABASE::"Standard General Journal");
        CleanTable(DATABASE::"Standard General Journal Line");
        CleanTable(DATABASE::"Standard Item Journal");
        CleanTable(DATABASE::"Standard Item Journal Line");
        CleanTable(DATABASE::"Cash Flow Forecast");
        CleanTable(DATABASE::"Cash Flow Account");
        CleanTable(DATABASE::"Cash Flow Setup");
        CleanTable(DATABASE::"Cash Flow Manual Revenue");
        CleanTable(DATABASE::"Cash Flow Manual Expense");
        CleanTable(DATABASE::"Assembly Setup");
        CleanTable(DATABASE::"Job Task");
        CleanTable(DATABASE::"Job Planning Line");
        CleanTable(DATABASE::"Job WIP Method");
        CleanTable(DATABASE::"Job Resource Price");
        CleanTable(DATABASE::"Job Item Price");
        CleanTable(DATABASE::"Job G/L Account Price");
        CleanTable(DATABASE::"Job Entry No.");
        //CleanTable(DATABASE::"Cost Journal Line");
        //CleanTable(DATABASE::"Cost Entry");
        //CleanTable(DATABASE::"Cost Register");
        //CleanTable(DATABASE::"Cost Budget Entry");
        //CleanTable(DATABASE::"Cost Budget Register");
        CleanTable(DATABASE::"Business Relation");
        CleanTable(DATABASE::"Mailing Group");
        CleanTable(DATABASE::"Industry Group");
        CleanTable(DATABASE::"Customer Template");
        CleanTable(DATABASE::Rating);
        CleanTable(DATABASE::"Interaction Template Setup");
        CleanTable(DATABASE::Attendee);
        CleanTable(DATABASE::Employee);
        CleanTable(DATABASE::"Employee Relative");
        CleanTable(DATABASE::"Cause of Absence");
        CleanTable(DATABASE::"Employee Absence");
        CleanTable(DATABASE::Union);
        CleanTable(DATABASE::"Cause of Inactivity");
        CleanTable(DATABASE::"Employment Contract");
        CleanTable(DATABASE::"Employee Statistics Group");
        CleanTable(DATABASE::"Misc. Article");
        CleanTable(DATABASE::"Misc. Article Information");
        CleanTable(DATABASE::Confidential);
        CleanTable(DATABASE::"Confidential Information");
        CleanTable(DATABASE::"Grounds for Termination");
        CleanTable(DATABASE::"Human Resources Setup");
        CleanTable(DATABASE::"Human Resource Unit of Measure");
        CleanTable(DATABASE::"Item Variant");
        CleanTable(DATABASE::"Unit of Measure Translation");
        CleanTable(DATABASE::"Item Substitution");
        CleanTable(DATABASE::"Nonstock Item");
        CleanTable(DATABASE::"Nonstock Item Setup");
        CleanTable(DATABASE::Manufacturer);
        CleanTable(DATABASE::Purchasing);
        CleanTable(DATABASE::"Item Category");
        //        CleanTable(DATABASE::"Product Group");
        //CleanTable(DATABASE::"Warehouse Setup");
        CleanTable(DATABASE::"Shipping Agent Services");
        CleanTable(DATABASE::"Item Charge");
        CleanTable(DATABASE::"Post Value Entry to G/L");
        CleanTable(DATABASE::"Inventory Posting Setup");
        CleanTable(DATABASE::"Inventory Adjmt. Entry (Order)");
        CleanTable(DATABASE::"Service Order Type");
        CleanTable(DATABASE::"Service Item Group");
        CleanTable(DATABASE::"Service Cost");
        CleanTable(DATABASE::"Service Hour");
        CleanTable(DATABASE::"Service Mgt. Setup");
        CleanTable(DATABASE::"Fault Area");
        CleanTable(DATABASE::"Symptom Code");
        CleanTable(DATABASE::"Fault Reason Code");
        CleanTable(DATABASE::"Fault Code");
        CleanTable(DATABASE::"Resolution Code");
        CleanTable(DATABASE::"Repair Status");
        CleanTable(DATABASE::"Service Status Priority Setup");
        CleanTable(DATABASE::"Service Shelf");
        CleanTable(DATABASE::"Service Document Register");
        CleanTable(DATABASE::"Service Item Component");
        CleanTable(DATABASE::"Troubleshooting Header");
        CleanTable(DATABASE::"Troubleshooting Line");
        CleanTable(DATABASE::"Troubleshooting Setup");
        CleanTable(DATABASE::"Work-Hour Template");
        CleanTable(DATABASE::"Skill Code");
        CleanTable(DATABASE::"Resource Skill");
        CleanTable(DATABASE::"Service Zone");
        CleanTable(DATABASE::"Resource Service Zone");
        CleanTable(DATABASE::"Service Contract Line");
        CleanTable(DATABASE::"Service Contract Header");
        CleanTable(DATABASE::"Contract Group");
        CleanTable(DATABASE::"Contract Change Log");
        CleanTable(DATABASE::"Contract Gain/Loss Entry");
        CleanTable(DATABASE::"Filed Service Contract Header");
        CleanTable(DATABASE::"Filed Contract Line");
        CleanTable(DATABASE::"Service Contract Account Group");
        CleanTable(DATABASE::"Service Price Group");
        CleanTable(DATABASE::"Serv. Price Group Setup");
        CleanTable(DATABASE::"Service Price Adjustment Group");
        CleanTable(DATABASE::"Serv. Price Adjustment Detail");
        CleanTable(DATABASE::"Return Reason");
        CleanTable(DATABASE::"Sales Line Discount");
        CleanTable(DATABASE::"Purchase Price");
        CleanTable(DATABASE::"Purchase Line Discount");
        CleanTable(DATABASE::"Item Budget Name");
        CleanTable(DATABASE::"Item Budget Entry");
        CleanTable(DATABASE::"Item Analysis View");
        CleanTable(DATABASE::"Item Analysis View Filter");
        CleanTable(DATABASE::"Item Analysis View Entry");
        CleanTable(DATABASE::"Item Analysis View Budg. Entry");
        CleanTable(DATABASE::"Item Analysis View Entry");
        CleanTable(DATABASE::"Item Analysis View Budg. Entry");
        CleanTable(DATABASE::"Work Shift");
        CleanTable(DATABASE::"Shop Calendar");
        CleanTable(DATABASE::"Shop Calendar Working Days");
        CleanTable(DATABASE::"Work Center");
        CleanTable(DATABASE::"Work Center Group");
        CleanTable(DATABASE::"Calendar Entry");
        CleanTable(DATABASE::"Machine Center");
        CleanTable(DATABASE::"Routing Header");
        CleanTable(DATABASE::"Routing Line");
        CleanTable(DATABASE::"Manufacturing Setup");
        CleanTable(DATABASE::"Routing Link");
        CleanTable(DATABASE::"Capacity Unit of Measure");
        CleanTable(DATABASE::"Production Forecast Name");
        CleanTable(DATABASE::"Production Forecast Entry");
        CleanTable(DATABASE::"Capacity Constrained Resource");
        CleanTable(DATABASE::"Payment Terms");
        CleanTable(DATABASE::"Standard Text");
        CleanTable(DATABASE::"Salesperson/Purchaser");
        CleanTable(DATABASE::Location);
        CleanTable(DATABASE::"G/L Account");
        CleanTable(DATABASE::"User Setup");
        CleanTable(DATABASE::"Customer Posting Group");
        CleanTable(DATABASE::"Vendor Posting Group");
        CleanTable(DATABASE::"Inventory Posting Group");
        CleanTable(DATABASE::"G/L Budget Name");
        CleanTable(DATABASE::"General Posting Setup");
        CleanTable(DATABASE::"Warehouse Employee");


        //MASTER DATA
        CleanTable(DATABASE::Customer);
        CleanTable(DATABASE::"Cust. Invoice Disc.");
        CleanTable(DATABASE::Vendor);
        CleanTable(DATABASE::"Vendor Invoice Disc.");
        CleanTable(DATABASE::Item);
        CleanTable(DATABASE::"Item Unit of Measure");
        CleanTable(DATABASE::"Sales Price");
        CleanTable(DATABASE::"Item Discount Group");
        CleanTable(DATABASE::"Stockkeeping Unit");
        CleanTable(DATABASE::"Item Cross Reference");
        CleanTable(DATABASE::"Item Translation");
        CleanTable(DATABASE::"Extended Text Header");
        CleanTable(DATABASE::"Extended Text Line");
        //CleanTable(DATABASE::"Accounting Period");
        //CleanTable(DATABASE::"Acc. Schedule Line");
        //CleanTable(DATABASE::"General Ledger Setup");
        CleanTable(DATABASE::"Item Vendor");
        //CleanTable(DATABASE::Resource);
        CleanTable(DATABASE::"Ship-to Address");
        CleanTable(DATABASE::"Order Address");
        CleanTable(DATABASE::"Work Type");                      //200
        CleanTable(DATABASE::"Resource Price");                 //201
        CleanTable(DATABASE::"Resource Cost");                  //202
        CleanTable(DATABASE::"Comment Line");
        CleanTable(DATABASE::Contact);
        CleanTable(DATABASE::"Contact Alt. Addr. Date Range");
        CleanTable(DATABASE::"Contact Alt. Address");
        CleanTable(DATABASE::"Contact Business Relation");
        CleanTable(DATABASE::"Contact Mailing Group");
        CleanTable(DATABASE::"Contact Industry Group");
        CleanTable(DATABASE::"Contact Job Responsibility");
        //CleanTable(DATABASE::"Business Relation");
        //CleanTable(DATABASE::"Mailing Group");
        //CleanTable(DATABASE::"Industry Group");
        //CleanTable(DATABASE::"Web Source");
        CleanTable(DATABASE::"Contact Web Source");
        CleanTable(DATABASE::Attachment);
        //CleanTable(DATABASE::"Interaction Group");
        CleanTable(DATABASE::"Interaction Log Entry");
        CleanTable(DATABASE::"Contact Profile Answer");
        CleanTable(DATABASE::"Sales Cycle");
        CleanTable(DATABASE::"Sales Cycle Stage");
        CleanTable(DATABASE::Opportunity);
        CleanTable(DATABASE::"My Customer");
        CleanTable(DATABASE::"My Vendor");
        CleanTable(DATABASE::"My Item");

        /*************************************/
        // Transactional Records
        /*************************************/
        CleanTable(DATABASE::"G/L Entry");
        CleanTable(DATABASE::"Cust. Ledger Entry");
        CleanTable(DATABASE::"Vendor Ledger Entry");
        CleanTable(DATABASE::"Item Ledger Entry");
        CleanTable(DATABASE::"Post Value Entry to G/L");
        CleanTable(DATABASE::"G/L Register");
        CleanTable(DATABASE::"Item Register");
        CleanTable(DATABASE::"Exch. Rate Adjmt. Reg.");
        CleanTable(DATABASE::"Date Compr. Register");
        CleanTable(DATABASE::"Sales Shipment Header");
        CleanTable(DATABASE::"Sales Shipment Line");
        CleanTable(DATABASE::"Sales Invoice Header");
        CleanTable(DATABASE::"Sales Invoice Line");
        CleanTable(DATABASE::"Sales Cr.Memo Header");
        CleanTable(DATABASE::"Sales Cr.Memo Line");
        CleanTable(DATABASE::"Purch. Rcpt. Header");
        CleanTable(DATABASE::"Purch. Rcpt. Line");
        CleanTable(DATABASE::"Purch. Inv. Header");
        CleanTable(DATABASE::"Purch. Inv. Line");
        CleanTable(DATABASE::"Purch. Cr. Memo Hdr.");
        CleanTable(DATABASE::"Purch. Cr. Memo Line");
        CleanTable(DATABASE::"Job Ledger Entry");
        CleanTable(DATABASE::"Res. Ledger Entry");
        //CleanTable(DATABASE::Table238);
        //CleanTable(DATABASE::Table239);
        CleanTable(DATABASE::"Resource Register");
        CleanTable(DATABASE::"Job Register");
        CleanTable(DATABASE::"VAT Entry");
        CleanTable(DATABASE::"Bank Account Ledger Entry");
        CleanTable(DATABASE::"Check Ledger Entry");
        CleanTable(DATABASE::"Bank Account Statement");
        CleanTable(DATABASE::"Bank Account Statement Line");
        CleanTable(DATABASE::"Phys. Inventory Ledger Entry");
        CleanTable(DATABASE::"Issued Reminder Header");
        CleanTable(DATABASE::"Issued Reminder Line");
        CleanTable(DATABASE::"Reminder/Fin. Charge Entry");
        CleanTable(DATABASE::"Issued Fin. Charge Memo Header");
        CleanTable(DATABASE::"Issued Fin. Charge Memo Line");
        CleanTable(DATABASE::"Item Application Entry");
        //CleanTable(DATABASE::Table355);
        //CleanTable(DATABASE::Table359);
        CleanTable(DATABASE::"Detailed Cust. Ledg. Entry");
        CleanTable(DATABASE::"Detailed Vendor Ledg. Entry");
        CleanTable(DATABASE::"Change Log Entry");
        CleanTable(DATABASE::"FA Ledger Entry");
        CleanTable(DATABASE::"FA Register");
        CleanTable(DATABASE::"Registered Whse. Activity Hdr.");
        CleanTable(DATABASE::"Registered Whse. Activity Line");
        CleanTable(DATABASE::"Value Entry");
        CleanTable(DATABASE::"Rounding Residual Buffer");
        CleanTable(DATABASE::"Capacity Ledger Entry");
        CleanTable(DATABASE::"G/L Entry - VAT Entry Link");
        CleanTable(DATABASE::"G/L - Item Ledger Relation");

        CleanTable(DATABASE::"Sales Header");
        CleanTable(DATABASE::"Sales Line");
        CleanTable(DATABASE::"Sales Comment Line");
        CleanTable(DATABASE::"Purchase Header");
        CleanTable(DATABASE::"Purchase Line");
        CleanTable(DATABASE::"Purch. Comment Line");
        CleanTable(DATABASE::"Gen. Journal Line");
        CleanTable(DATABASE::"Return Receipt Header");
        CleanTable(DATABASE::"Return Receipt Line");

        CleanTable(DATABASE::"Res. Capacity Entry");            //160
        CleanTable(DATABASE::Job);                              //167
        CleanTable(DATABASE::"Standard Sales Code");            //170
        CleanTable(DATABASE::"Standard Sales Line");            //171
        CleanTable(DATABASE::"Standard Customer Sales Code");   //172
        CleanTable(DATABASE::"Standard Purchase Code");         //173
        CleanTable(DATABASE::"Standard Purchase Line");         //174
        CleanTable(DATABASE::"Standard Vendor Purchase Code");  //175
        CleanTable(DATABASE::"Reversal Entry");                 //179
        CleanTable(DATABASE::"Res. Journal Line");              //207
        CleanTable(DATABASE::"Job Posting Group");              //208
        CleanTable(DATABASE::"Job Journal Line");               //210

        CleanTable(DATABASE::"User Time Register");
        CleanTable(DATABASE::"Item Journal Line");
        CleanTable(DATABASE::"G/L Budget Entry");

        CleanTable(DATABASE::"Tracking Specification");
        CleanTable(DATABASE::"Reservation Entry");
        CleanTable(DATABASE::"Item Application Entry History");

        CleanTable(DATABASE::"Sales Header Archive");
        CleanTable(DATABASE::"Sales Line Archive");
        CleanTable(DATABASE::"Purchase Header Archive");
        CleanTable(DATABASE::"Purchase Line Archive");
        CleanTable(DATABASE::"Avg. Cost Adjmt. Entry Point");
        CleanTable(DATABASE::"Item Entry Relation");
        CleanTable(DATABASE::"Value Entry Relation");

        CleanTable(DATABASE::"Deposit Header");
        CleanTable(DATABASE::"Posted Deposit Header");
        CleanTable(DATABASE::"Posted Deposit Line");

        //CleanTable(DATABASE::Table14020365);

        CleanTable(DATABASE::"Warehouse Request");
        CleanTable(DATABASE::"Warehouse Activity Header");
        CleanTable(DATABASE::"Warehouse Activity Line");
        CleanTable(DATABASE::"Warehouse Comment Line");
        CleanTable(DATABASE::"Warehouse Journal Line");
        CleanTable(DATABASE::"Warehouse Entry");
        CleanTable(DATABASE::"Warehouse Register");
        CleanTable(DATABASE::"Warehouse Receipt Header");
        CleanTable(DATABASE::"Warehouse Receipt Line");
        CleanTable(DATABASE::"Warehouse Shipment Header");
        CleanTable(DATABASE::"Warehouse Shipment Line");
        CleanTable(DATABASE::"Registered Whse. Activity Hdr.");
        CleanTable(DATABASE::"Registered Whse. Activity Line");
        CleanTable(DATABASE::"Whse. Item Entry Relation");
        CleanTable(DATABASE::"Whse. Item Tracking Line");
        CleanTable(DATABASE::"Posted Whse. Receipt Header");
        CleanTable(DATABASE::"Posted Whse. Receipt Line");
        CleanTable(DATABASE::"Posted Whse. Shipment Header");
        CleanTable(DATABASE::"Posted Whse. Shipment Line");
        CleanTable(DATABASE::"Whse. Put-away Request");
        CleanTable(DATABASE::"Whse. Pick Request");
        CleanTable(DATABASE::"Whse. Worksheet Line");
        CleanTable(DATABASE::"Whse. Internal Put-away Header");
        CleanTable(DATABASE::"Whse. Internal Put-away Line");
        CleanTable(DATABASE::"Whse. Internal Pick Header");
        CleanTable(DATABASE::"Whse. Internal Pick Line");
        CleanTable(DATABASE::"Bin Content");

        CleanTable(DATABASE::"Transfer Header");
        CleanTable(DATABASE::"Transfer Line");
        CleanTable(DATABASE::"Transfer Shipment Header");
        CleanTable(DATABASE::"Transfer Shipment Line");
        CleanTable(DATABASE::"Transfer Receipt Header");
        CleanTable(DATABASE::"Transfer Receipt Line");
        CleanTable(DATABASE::"Transfer Route");

        CleanTable(DATABASE::"Requisition Line");
        CleanTable(DATABASE::"Production Order");
        CleanTable(DATABASE::"Prod. Order Line");
        CleanTable(DATABASE::"Prod. Order Component");
        CleanTable(DATABASE::"Prod. Order Routing Line");
        CleanTable(DATABASE::"Prod. Order Capacity Need");

        CleanTable(DATABASE::"Action Message Entry");
        CleanTable(DATABASE::"Order Promising Line");
        CleanTable(DATABASE::"Record Link");
        CleanTable(DATABASE::"Finance Charge Memo Header");
        CleanTable(DATABASE::"Finance Charge Memo Line");

        //CleanTable(DATABASE::Table356);
        //CleanTable(DATABASE::Table357);
        //CleanTable(DATABASE::Table358);
        CleanTable(DATABASE::"Analysis View Entry");
        //CleanTable(DATABASE::Table5106);
        CleanTable(DATABASE::"Planning Error Log");

        CleanTable(DATABASE::"Reminder Header");
        CleanTable(DATABASE::"Reminder Line");

        CleanTable(DATABASE::"Entry Summary");

        CleanTable(DATABASE::"Item Charge Assignment (Purch)");
        CleanTable(DATABASE::"Item Charge Assignment (Sales)");

        CleanTable(DATABASE::"Job Queue Log Entry");

        CleanTable(DATABASE::"Sales Comment Line Archive");

        CleanTable(DATABASE::"Return Shipment Header");
        CleanTable(DATABASE::"Return Shipment Line");

        CleanTable(DATABASE::"Bank Rec. Header");
        CleanTable(DATABASE::"Bank Rec. Line");
        //CleanTable(DATABASE::Table10125);
        CleanTable(DATABASE::"Bank Rec. Sub-line");

        //CleanTable(DATABASE::"Cust. Price Group Assigned");
        //CleanTable(DATABASE::"Commission");
        //CleanTable(DATABASE::"Sales Line Commission");
        //CleanTable(DATABASE::"Commission Journal");

        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //CleanTable(DATABASE::"");
        //

        //CleanTable(DATABASE::Table37032457);

        CleanTable(DATABASE::"Service Item");
        CleanTable(DATABASE::"Service Item Log");
        CleanTable(DATABASE::"Service Header");
        CleanTable(DATABASE::"Service Item Line");
        CleanTable(DATABASE::"Service Line");
        CleanTable(DATABASE::"Service Comment Line");
        CleanTable(DATABASE::"Service Order Allocation");
        CleanTable(DATABASE::"Service Shipment Header");
        CleanTable(DATABASE::"Service Shipment Item Line");
        CleanTable(DATABASE::"Service Shipment Line");
        CleanTable(DATABASE::"Service Invoice Header");
        CleanTable(DATABASE::"Service Invoice Line");
        CleanTable(DATABASE::"Service Ledger Entry");
        CleanTable(DATABASE::"Warranty Ledger Entry");
        CleanTable(DATABASE::"Service Document Log");
        CleanTable(DATABASE::Loaner);
        CleanTable(DATABASE::"Loaner Entry");
        CleanTable(DATABASE::"Service Register");

        //Clean Eship master and transactions
        CleanTable(DATABASE::"Shipping Account");
        CleanTable(DATABASE::Package);
        CleanTable(DATABASE::"Package Line");
        CleanTable(DATABASE::"Posted Package");
        CleanTable(DATABASE::"Posted Package Line");
        CleanTable(DATABASE::"Manifest Header");
        CleanTable(DATABASE::"Manifest Line");
        CleanTable(DATABASE::"Rate Shop Header");
        CleanTable(DATABASE::"Rate Shop Line");
        CleanTable(DATABASE::"UPS Option Page");
        CleanTable(DATABASE::"UPS Posted Option Page");
        //CleanTable(DATABASE::"FedEx Option Page");
        //CleanTable(DATABASE::"FedEx Posted Option Page");
        //CleanTable(DATABASE::"Bill of Lading");
        //CleanTable(DATABASE::"Bill of Lading Line");
        //CleanTable(DATABASE::"Bill of Lading Info. Line");
        CleanTable(DATABASE::"Export Document");
        CleanTable(DATABASE::"Export Source Document");
        CleanTable(DATABASE::"Export Source Line");
        CleanTable(DATABASE::"Export Document Line");
        CleanTable(DATABASE::"Export Submitted Document");
        CleanTable(DATABASE::"Export Submitted Source Line");
        CleanTable(DATABASE::"Export Submitted Document Line");
        CleanTable(DATABASE::"E-Mail List Entry");
        CleanTable(DATABASE::"Label File");

        CleanTable(DATABASE::"Production BOM Header");
        CleanTable(DATABASE::"Production BOM Line");
        CleanTable(DATABASE::"Planning Assignment");
        CleanTable(DATABASE::"Untracked Planning Element");

        CleanTable(DATABASE::"Document Entry");
        CleanTable(DATABASE::"Analysis View Budget Entry");
        CleanTable(DATABASE::"Dimension Entry Buffer");
        CleanTable(DATABASE::"CV Ledger Entry Buffer");
        CleanTable(DATABASE::"Detailed CV Ledg. Entry Buffer");
        CleanTable(DATABASE::"Entry No. Amount Buffer");
        CleanTable(DATABASE::"Approval Entry");
        CleanTable(DATABASE::"Posted Approval Entry");
        CleanTable(DATABASE::"Overdue Approval Entry");
        CleanTable(DATABASE::"VAT Rate Change Log Entry");
        //        CleanTable(DATABASE::Table829);
        CleanTable(DATABASE::"Cash Flow Forecast Entry");
        CleanTable(DATABASE::"Time Sheet Posting Entry");
        CleanTable(DATABASE::"Job WIP Entry");
        CleanTable(DATABASE::"Job WIP G/L Entry");
        CleanTable(DATABASE::"Insurance Register");
        CleanTable(DATABASE::"Main Asset Component");
        CleanTable(DATABASE::"FA G/L Posting Buffer");
        CleanTable(DATABASE::"Insurance Type");
        CleanTable(DATABASE::"Ins. Coverage Ledger Entry");
        CleanTable(DATABASE::Insurance);
        CleanTable(DATABASE::"Maintenance Ledger Entry");
        CleanTable(DATABASE::"Maintenance Registration");
        CleanTable(DATABASE::"FA Allocation");
        CleanTable(DATABASE::"FA Depreciation Book");
        CleanTable(DATABASE::"FA Location");
        CleanTable(DATABASE::"Fixed Asset");
        CleanTable(DATABASE::"FA Posting Group");
        //CleanTable(DATABASE::"

        //************//
        // Custom Tables//
        //************//
        CleanTable(DATABASE::Product);
        CleanTable(DATABASE::"Product Attribute");
        CleanTable(DATABASE::"Rupp Reason Code");
        CleanTable(DATABASE::"Item Creation Pkg Size");
        CleanTable(DATABASE::"Research Plots");
        CleanTable(DATABASE::"Seasonal Discount Appl. Entry");
        CleanTable(DATABASE::"Purchase Contract Header");
        CleanTable(DATABASE::"Purchase Contract Line");
        CleanTable(DATABASE::"Receipt Header");
        CleanTable(DATABASE::"Receipt Line");
        CleanTable(DATABASE::"Posted Receipt Header");
        CleanTable(DATABASE::"Posted Receipt Line");
        CleanTable(DATABASE::"Rupp Comment Line");
        CleanTable(DATABASE::"Compliance Group Product Item");
        CleanTable(DATABASE::"Work Order");
        CleanTable(DATABASE::"Produced Item");
        CleanTable(DATABASE::"Consumed Item");
        CleanTable(DATABASE::Compliance);
        CleanTable(DATABASE::"Geographical Restriction");
        CleanTable(DATABASE::"Research Plot Data");
        CleanTable(DATABASE::"Customer Payment Link");
        CleanTable(DATABASE::"Shipment Planning Batch");
        CleanTable(DATABASE::"Shipment Planning Line");
        CleanTable(DATABASE::"Contract Rcpt-Invoice Link");

        //        CleanTable(DATABASE::Table104025);
        //        CleanTable(DATABASE::Table104026);
        //        CleanTable(DATABASE::Table104027);

        Window.Close;

    end;

    local procedure CleanTable(TableNo: Integer)
    var
        RecordReference: RecordRef;
    begin

        Window.Update(2, Text004 + ' ' + Format(TableNo));
        StatusCounter := StatusCounter + 1;
        Window.Update(1, Round(StatusCounter / TotalRecNo * 10000, 1));
        RecordReference.Open(TableNo);
        //RecordReference.DELETEALL(TRUE);
        RecordReference.DeleteAll();
    end;
}

