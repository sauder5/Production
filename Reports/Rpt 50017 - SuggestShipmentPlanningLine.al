report 50017 "Suggest Shipment Planning Line"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/SuggestShipmentPlanningLine.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order));
            RequestFilterFields = "Salesperson Code", "Posting Date";
            column(DocType; "Sales Line"."Document Type")
            {
            }
            column(OrderNo; "Sales Line"."Document No.")
            {
            }
            column(LineNo; "Sales Line"."Line No.")
            {
            }
            column(QtyOrdered; "Sales Line".Quantity)
            {
            }
            column(PickQty; "Sales Line"."Pick Qty.")
            {
            }
            column(GrossWt; "Sales Line"."Gross Weight")
            {
            }
            column(NetWt; "Sales Line"."Net Weight")
            {
            }
            column(QtyOutstanding; "Sales Line"."Outstanding Quantity")
            {
            }
            column(ItemNo; "Sales Line"."No.")
            {
            }
            column(CustomerNo; "Sales Line"."Sell-to Customer No.")
            {
            }
            column(ProductCode; "Sales Line"."Product Code")
            {
            }
            column(UnitOfMeasure; "Sales Line"."Unit of Measure Code")
            {
            }
            column(QtyAvailable; gdQtyAvailable)
            {
            }
            column(QtyonHand; gdQtyOnHand)
            {
            }
            column(QtyonOrder; gdQtyOnOrder)
            {
            }
            column(PaymentTerms; gcPaymentTerms)
            {
            }
            column(PickExists; gsPickExists)
            {
            }
            column(PickNo; gsPickNo)
            {
            }
            column(State; gsState)
            {
            }
            column(ShipMethod; gcShipMethod)
            {
            }
            column(PickCreatedDate; gtPickCreatedDate)
            {
            }
            column(Waivers; gsWaivers)
            {
            }
            column(ExpirationDate; gsExpirationDate)
            {
            }
            column(CreditLimit; gdCreditLimit)
            {
            }
            column(Manufacturer; gcManufacturer)
            {
            }
            column(SeedSize; gsSeedSize)
            {
            }
            column(BaseUOM; gcBaseUOM)
            {
            }
            column(SeedsPerLb; gsSeedsPerLb)
            {
            }
            column(WtLbs; gdWtLbs)
            {
            }
            column(WtGms; gdWtGms)
            {
            }
            column(SalesPerson; "Sales Line"."Salesperson Code")
            {
            }
            column(CustomerName; gsCustomerName)
            {
            }
            column(OrderDate; gdOrderDate)
            {
            }
            column(RequestedShipDate; "Sales Line"."Shipment Date")
            {
            }
            column(ItemDesc; gsItemDesc)
            {
            }
            column(PostingDate; "Sales Line"."Posting Date")
            {
            }

            trigger OnAfterGetRecord()
            var
                recItem: Record Item;
                recCustomer: Record Customer;
                recProduct: Record Product;
                recSalesHeader: Record "Sales Header";
                recWhseActLn: Record "Warehouse Activity Line";
                recCompliance: Record Compliance;
                recShptPlanningLine: Record "Shipment Planning Line";
            begin
                gsPickExists := '';
                gcPaymentTerms := '';
                gcSalesperson := '';
                gsState := '';
                gcShipMethod := '';
                gsWaivers := '';
                gdQtyAvailable := 0;
                gdQtyOnHand := 0;
                gdQtyOnOrder := 0;
                gsPickNo := '';
                gtExpDate := 0D;
                CalcFields("Pick Qty.");
                gbPickExists := false;

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
                        gtPickCreatedDate := "Sales Line"."Pick Creation DateTime";
                        gbPickExists := true;
                    end;
                end else
                    gsPickExists := 'NO';

                recSalesHeader.Get("Document Type", "Document No.");
                gdOrderDate := recSalesHeader."Order Date";
                gcPaymentTerms := recSalesHeader."Payment Terms Code";
                gsState := recSalesHeader."Ship-to County";
                if recSalesHeader."Shipping Agent Code" <> '' then
                    gcShipMethod := recSalesHeader."Shipping Agent Code" + ' ,' + recSalesHeader."E-Ship Agent Service"
                else
                    gcShipMethod := recSalesHeader."E-Ship Agent Service";

                if recSalesHeader."Missing Reqd License" then begin
                    gsWaivers := 'License Required';
                end;

                if ("No." <> '') and (Type = Type::Item) then begin
                    recItem.Get("No.");
                    recItem.CalcFields(Inventory, "Qty. on Sales Order");
                    gsItemDesc := recItem.Description;
                    gdQtyAvailable := recItem."Product Qty. in Base UOM";
                    gdQtyOnHand := recItem.Inventory;
                    gdQtyOnOrder := recItem."Qty. on Sales Order";
                    gcManufacturer := recItem."Vendor No.";
                    // gcBaseUOM       := recItem."Base Unit of Measure";
                end;


                if "Sell-to Customer No." <> '' then begin
                    recCustomer.Get("Sell-to Customer No.");
                    gsCustomerName := recCustomer.Name;
                    gdCreditLimit := recCustomer."Credit Limit (LCY)";
                end;

                goSeedSize := 0;
                if "Product Code" <> '' then begin
                    recProduct.Get("Product Code");
                    goSeedSize := recProduct."Seed Size";
                    if recProduct."Seed Size" = recProduct."Seed Size"::Small then
                        gsSeedSize := 'Small'
                    else
                        if recProduct."Seed Size" = recProduct."Seed Size"::Large then
                            gsSeedSize := 'Large'
                        else
                            gsSeedSize := ' ';
                end;
                gdWtLbs := "Sales Line"."Gross Weight" * "Sales Line"."Outstanding Quantity";

                gdWtGms := gdWtLbs * 453.59;

                gsWaivers := '';
                if Type = Type::Item then begin
                    gsWaivers := "Compliance Group Code";
                    if "Missing Reqd License" then begin
                        gsWaivers := gsWaivers + ': ' + 'License Reqd';
                    end else begin
                        if recCompliance.Get("Compliance Group Code", "Sales Line"."Sell-to Customer No.", recSalesHeader."Ship-to Code", '') then begin//"Waiver Code","Customer No.","Ship-to Code","Code"
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

                giCnt += 1;
                InsertPlanningLine();
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

    trigger OnPostReport()
    begin
        Message('Inserted %1 lines', giCnt);
    end;

    trigger OnPreReport()
    begin
        if gsBatchName = '' then
            Error('Batch Name cannot be blank. Please try it from the Shipment Planning Worksheet');
    end;

    var
        gdQtyAvailable: Decimal;
        gdQtyOnHand: Decimal;
        gdQtyOnOrder: Decimal;
        gcManufacturer: Code[20];
        gcBaseUOM: Code[10];
        gcPaymentTerms: Code[10];
        gcSalesperson: Code[10];
        gsState: Text[30];
        gcShipMethod: Code[20];
        gsPickExists: Text[3];
        gtPickCreatedDate: DateTime;
        gsWaivers: Text[200];
        gsExpirationDate: Text[10];
        gdCreditLimit: Decimal;
        gsSeedSize: Text;
        gsSeedsPerLb: Text;
        gdWtLbs: Decimal;
        gdWtGms: Decimal;
        gsPickNo: Text[20];
        gtExpDate: Date;
        gsCustomerName: Text[50];
        gdOrderDate: Date;
        gsItemDesc: Text[50];
        gsBatchName: Code[10];
        giCnt: Integer;
        goSeedSize: Option " ",Small,Large;
        gbPickExists: Boolean;

    [Scope('Internal')]
    procedure InsertPlanningLine()
    var
        recShptPlLn: Record "Shipment Planning Line";
    begin
        recShptPlLn.Init();
        recShptPlLn."Batch Name" := gsBatchName;
        recShptPlLn."Line No." := giCnt;
        recShptPlLn."Sales Document Type" := "Sales Line"."Document Type";
        recShptPlLn."Sales Document No." := "Sales Line"."Document No.";
        recShptPlLn."Sales Document Line No." := "Sales Line"."Line No.";
        recShptPlLn.Quantity := "Sales Line".Quantity;
        recShptPlLn."Pick Qty." := "Sales Line"."Pick Qty.";
        recShptPlLn."Gross Weight" := "Sales Line"."Gross Weight";
        recShptPlLn."Net Weight" := "Sales Line"."Net Weight";
        recShptPlLn."Oustanding Quantity" := "Sales Line"."Outstanding Quantity";
        recShptPlLn."Item No." := "Sales Line"."No.";
        recShptPlLn."Sell-to Customer No." := "Sales Line"."Sell-to Customer No.";
        recShptPlLn."Product Code" := "Sales Line"."Product Code";
        recShptPlLn."Unit of Measure Code" := "Sales Line"."Unit of Measure Code";
        recShptPlLn."Qty. Available" := gdQtyAvailable;
        recShptPlLn."Qty. on Hand" := gdQtyOnHand;
        recShptPlLn."Qty. on Order" := gdQtyOnOrder;
        recShptPlLn."Payment Terms Code" := gcPaymentTerms;
        recShptPlLn."Pick Exists" := gbPickExists;
        recShptPlLn."Pick No." := gsPickNo;
        recShptPlLn.State := gsState;
        recShptPlLn."Shipment Method" := gcShipMethod;
        recShptPlLn."Pick Created Date" := DT2Date("Sales Line"."Pick Creation DateTime");
        recShptPlLn.Waivers := gsWaivers;
        recShptPlLn."Expiration date" := gtExpDate;
        recShptPlLn."Credit Limit" := gdCreditLimit;
        recShptPlLn.Manufacturer := gcManufacturer;
        recShptPlLn."Seed Size" := goSeedSize;
        recShptPlLn."Base Unit of Measure" := gcBaseUOM;
        recShptPlLn."Weight (Lbs)" := gdWtLbs;
        recShptPlLn."Weight (G)" := gdWtGms;
        recShptPlLn."Salesperson Code" := "Sales Line"."Salesperson Code";
        recShptPlLn."Customer Name" := gsCustomerName;
        recShptPlLn."Order Date" := gdOrderDate;
        recShptPlLn."Shipment Date" := "Sales Line"."Shipment Date";
        recShptPlLn."Item Description" := gsItemDesc;
        recShptPlLn."Posting Date" := "Sales Line"."Posting Date";
        recShptPlLn.Insert();
    end;

    [Scope('Internal')]
    procedure SetPlanningBatchName(BatchName: Code[10])
    begin
        gsBatchName := BatchName;
    end;
}

