page 50079 "Open Order List"
{
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order),
                            Type = FILTER(Item),
                            "Outstanding Quantity" = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Caption = 'Customer No';
                }
                field(gsCustomerName; gsCustomerName)
                {
                    Caption = 'Name';
                }
                field("Document No."; "Document No.")
                {
                    Caption = 'Order No';
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'Date';
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Caption = 'Requested Ship Date';
                }
                field("No."; "No.")
                {
                    Caption = 'Item No';
                }
                field(gsItemDesc; gsItemDesc)
                {
                    Caption = 'Description';
                }
                field(Quantity; Quantity)
                {
                    Caption = 'Qty Ordered';
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    Caption = 'Qty Outstanding';
                }
                field(gdqtyAvailable; gdqtyAvailable)
                {
                    Caption = 'Qty Available';
                }
                field(gdQtyOnHand; gdQtyOnHand)
                {
                    Caption = 'Qty On Hand';
                }
                field(gdQtyOnOrder; gdQtyOnOrder)
                {
                    Caption = 'Qty On Order';
                }
                field(gcPaymentTerms; gcPaymentTerms)
                {
                    Caption = 'Pmt Terms';
                }
                field(gsPickExists; gsPickExists)
                {
                    Caption = 'Pick Printed';
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Caption = 'Sales Person';
                }
                field(gsPickNo; gsPickNo)
                {
                    Caption = 'Pick Number';
                }
                field(gsState; gsState)
                {
                    Caption = 'State';
                }
                field(gcShipMethod; gcShipMethod)
                {
                    Caption = 'Ship Method';
                }
                field(gsWaivers; gsWaivers)
                {
                    Caption = 'Waivers';
                }
                field(gtExpDate; gtExpDate)
                {
                    Caption = 'Expiration Date';
                }
                field(gdCreditLimit; gdCreditLimit)
                {
                    Caption = 'Credit Limit';
                }
                field(gcManufacturer; gcManufacturer)
                {
                    Caption = 'Manufacturer';
                }
                field(gsSeedSize; gsSeedSize)
                {
                    Caption = 'Seed Size';
                }
                field(gcBaseUOM; gcBaseUOM)
                {
                    Caption = 'Base UofM';
                }
                field(gsSeedsPerLbf; gsSeedsPerLbf)
                {
                    Caption = 'Seeds Per Lb';
                }
                field(gdWtLbs; gdWtLbs)
                {
                    Caption = 'Wt In Lbs';
                }
                field(gdWtGms; gdWtGms)
                {
                    Caption = 'Wt In Grms';
                }
                field("Net Weight"; "Net Weight")
                {
                    Visible = false;
                }
                field("Product Code"; "Product Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Pick Qty."; "Pick Qty.")
                {
                    Visible = false;
                }
                field(gsPaymentMethod; gsPaymentMethod)
                {
                    Caption = 'Payment Method';
                }
                field(gsNotes; gsNotes)
                {
                    Caption = 'Notes';
                }
                field(PickDate; gtPickCreatedDate)
                {
                    Caption = 'Pick Date';
                }
                field(gsShipToName; gsShipToName)
                {
                    Caption = 'Ship To Name';
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Caption = 'Division Code';
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        SetCurrentKey("Document No.");
    end;

    trigger OnAfterGetRecord()
    var
        recItem: Record Item;
        recCustomer: Record Customer;
        recProduct: Record Product;
        recSalesHeader: Record "Sales Header";
        recWhseActLn: Record "Warehouse Activity Line";
        recCompliance: Record Compliance;
        recIDString: Text;
        ReadBlob: InStream;
        TempNote: Text;
        recRef: RecordRef;
        recWhseHead: Record "Warehouse Activity Header";
    begin
        gsPickExists := '';
        gcPaymentTerms := '';
        gcSalesperson := '';
        gsState := '';
        gcShipMethod := '';
        gsWaivers := '';
        gdqtyAvailable := 0;
        gdQtyOnHand := 0;
        gdQtyOnOrder := 0;
        gsPickNo := '';
        gtExpDate := 0D;
        gsItemDesc := '';
        gtPickCreatedDate := 0D;
        CalcFields("Pick Qty.");


        if "Pick Qty." > 0 then begin
            gsPickExists := 'YES';
            recWhseActLn.Reset();
            recWhseActLn.SetRange("Activity Type", recWhseActLn."Activity Type"::Pick);
            recWhseActLn.SetRange("Source Type", 37);
            recWhseActLn.SetRange("Source Subtype", "Document Type");
            recWhseActLn.SetRange("Source No.", "Document No.");
            recWhseActLn.SetRange("Source Line No.", "Line No.");
            if recWhseActLn.FindFirst() then begin
                gsPickNo := recWhseActLn."No.";
            end;
            recWhseHead.SetFilter(Type, 'Pick');
            recWhseHead.SetFilter("No.", recWhseActLn."No.");
            if recWhseHead.FindSet then
                gtPickCreatedDate := recWhseHead."Date of Last Printing";
        end else
            gsPickExists := 'NO';

        recSalesHeader.Get("Document Type", "Document No.");
        gdOrderDate := recSalesHeader."Order Date";
        gcPaymentTerms := recSalesHeader."Payment Terms Code";
        gsState := recSalesHeader."Ship-to County";
        gsPaymentMethod := recSalesHeader."Payment Method Code";
        gsShipToName := recSalesHeader."Ship-to Name";
        if recSalesHeader."Shipping Agent Code" <> '' then
            gcShipMethod := recSalesHeader."Shipping Agent Code" + ' ,' + recSalesHeader."E-Ship Agent Service"
        else
            gcShipMethod := recSalesHeader."E-Ship Agent Service";

        if recSalesHeader."Missing Reqd License" then begin
            gsWaivers := 'License Required';
        end;

        if ("No." <> '') and (Type = Type::Item) then begin
            recItem.Get("No.");
            recItem.CalcFields(Inventory, "Qty. on Sales Order", "Product Qty. in Common UOM");
            gsItemDesc := recItem.Description;
            gdqtyAvailable := recItem."Product Qty. in Common UOM";
            gdQtyOnHand := recItem.Inventory;
            gdQtyOnOrder := recItem."Qty. on Sales Order";
            gcManufacturer := recItem."Vendor No.";
            // gcBaseUOM       := recItem."Base Unit of Measure";
        end;


        if "Sell-to Customer No." <> '' then begin
            if recCustomer.Get("Sell-to Customer No.") then begin
                gsCustomerName := recCustomer.Name;
                gdCreditLimit := recCustomer."Credit Limit (LCY)";
            end
            else begin
                gsCustomerName := '';
                gdCreditLimit := 0;
            end;
        end;

        if "Product Code" <> '' then begin
            recProduct.Get("Product Code");
            if recProduct."Seed Size" = recProduct."Seed Size"::Small then
                gsSeedSize := 'Small'
            else
                if recProduct."Seed Size" = recProduct."Seed Size"::Large then
                    gsSeedSize := 'Large'
                else
                    gsSeedSize := ' ';
        end;
        gdWtLbs := "Gross Weight" * "Outstanding Quantity";

        gdWtGms := gdWtLbs * 453.59;

        gsWaivers := '';
        if Type = Type::Item then begin
            gsWaivers := "Compliance Group Code";
            if "Missing Reqd License" then begin
                gsWaivers := gsWaivers + ': ' + 'License Reqd';
            end else begin
                if recCompliance.Get("Compliance Group Code", "Sell-to Customer No.", recSalesHeader."Ship-to Code", '') then begin//"Waiver Code","Customer No.","Ship-to Code","Code"
                    gtExpDate := recCompliance."License Expiration Date";
                end;
            end;

            if "Missing Reqd Liability Waiver" then begin
                gsWaivers := gsWaivers + ' ,' + 'Liability Waiver Reqd.';
            end;

            if "Missing Reqd Quality Release" then begin
                gsWaivers := gsWaivers + ' ,' + 'Missing Reqd Quality Release';
            end;
        end;

        recRef.GetTable(recSalesHeader);
        recLink.SetRange("Record ID", recRef.RecordId);
        if not recLink.FindFirst then
            gsNotes := ''
        else begin
            recLink.CalcFields(Note);
            recLink.Note.CreateInStream(ReadBlob);  // ReadBlob is an Instream variable and remember a blob can overflow a text variable
            ReadBlob.ReadText(TempNote);
            gsNotes := CopyStr(TempNote, 2);
        end;
    end;

    trigger OnInit()
    var
        recIDString: Text;
    begin
    end;

    var
        gdqtyAvailable: Decimal;
        gdQtyOnHand: Decimal;
        gdQtyOnOrder: Decimal;
        gcPaymentTerms: Code[10];
        gsPickExists: Text[3];
        gsPickNo: Text[20];
        gsState: Text[30];
        gcShipMethod: Code[24];
        gtPickCreatedDate: Date;
        gsWaivers: Text[200];
        gtExpDate: Date;
        gdCreditLimit: Decimal;
        gcManufacturer: Code[20];
        gsSeedSize: Text;
        gcBaseUOM: Code[10];
        gsSeedsPerLbf: Text;
        gdWtLbs: Decimal;
        gdWtGms: Decimal;
        gsCustomerName: Text[50];
        gsItemDesc: Text[50];
        gcSalesperson: Text;
        gdOrderDate: Date;
        recCount: Integer;
        recNumber: Integer;
        ProgressWindow: Dialog;
        timProgress: Time;
        intProgress: Integer;
        gsPaymentMethod: Text;
        gsNotes: Text;
        recLink: Record "Record Link";
        gsPickDate: Date;
        gsShipToName: Text[50];
}

