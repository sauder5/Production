page 50062 "Invt. Status Change Subpage"
{
    // //PM1.0
    //   Added columns "Qty. Requested", "Qty. Cancelled". "Inventory Status", "Product Code", "Cancelled Reason Code","Unit Discount",
    //     "Pick Qty." and "Pick Creation DateTime"
    //   Mod in OnAfterGetRecord()
    //   Added columns "Qty. in LUOM", "Qty. in CUOM"
    // 
    // //SOC-SC 08-26-14
    //   Added "Total Amount" to show on page -mod on OnAfterGetCurrRecord()
    // 
    // //SOC-SC 09-11-14
    //   Added column "Unit Price per CUOM"

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = SORTING("Document Type", "Document No.", "Line No.")
                      WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            field(gdTotalAmt; gdTotalAmt)
            {
                Caption = 'Total Amount';
                Editable = false;
                Visible = false;
            }
            field("Substitute Unit Price"; gdSubstitiuteUnitPrice)
            {
            }
            group(Control1000000002)
            {
                ShowCaption = false;
                Visible = gbExceedingCreditLimit;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                        NoOnAfterValidate;

                        gbNonItem := (Type <> Type::Item); //SOC-SC 08-01-14
                    end;
                }
                field("No."; "No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field("Compliance Group Code"; "Compliance Group Code")
                {
                    Visible = false;
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CrossReferenceNoLookUp;
                        InsertExtendedText(false);
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                        NoOnAfterValidate;
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field("Substitution Available"; "Substitution Available")
                {
                    Visible = false;
                }
                field("Purchasing Code"; "Purchasing Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                    QuickEntry = false;
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Special Order"; "Special Order")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Bin Code"; "Bin Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Control50; Reserve)
                {
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field("Qty. Requested"; "Qty. Requested")
                {

                    trigger OnValidate()
                    begin
                        GetUnitPricePerCUOM(); //SOC-SC 09-11-14
                    end;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Qty. Cancelled"; "Qty. Cancelled")
                {
                }
                field("Cancelled Reason Code"; "Cancelled Reason Code")
                {
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Pick Qty."; "Pick Qty.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field(gsCustName; gsCustName)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(gtOrderDate; gtOrderDate)
                {
                    Caption = 'Order Date';
                    Editable = false;
                }
                field(goStatus; goStatus)
                {
                    Caption = 'Order Status';
                    Editable = false;
                }
                field(goShippingStatus; goShippingStatus)
                {
                    Caption = 'Shipping Status';
                    Editable = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Editable = false;
                    Visible = false;
                }
                field(SalesPriceExist; PriceExists)
                {
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        SetCreditLimitVisibility(); //PM1.0
                        CurrPage.Update();
                    end;
                }
                field(gdUnitPricePerCUOM; gdUnitPricePerCUOM)
                {
                    Caption = 'Unit Price per CUOM';
                    Visible = false;
                }
                field("Unit Discount"; "Unit Discount")
                {
                    Visible = false;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    Visible = false;
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                    Visible = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field(SalesLineDiscExists; LineDiscExists)
                {
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                    BlankZero = true;
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if "Qty. to Asm. to Order (Base)" <> 0 then begin
                            CurrPage.SaveRecord;
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Std. Pack Qty. to Ship"; "Std. Pack Qty. to Ship")
                {
                    Visible = false;
                }
                field("Package Qty. to Ship"; "Package Qty. to Ship")
                {
                    Visible = false;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    BlankZero = true;
                    QuickEntry = false;
                }
                field("Outstanding Qty. in Lowest UOM"; "Outstanding Qty. in Lowest UOM")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Outstanding Qty. in Common UOM"; "Outstanding Qty. in Common UOM")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    BlankZero = true;
                    Editable = false;
                    Visible = false;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                    Visible = false;
                }
                field("Planned Delivery Date"; "Planned Delivery Date")
                {
                    QuickEntry = false;
                    Visible = false;
                }
                field("Planned Shipment Date"; "Planned Shipment Date")
                {
                    Visible = false;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Required Shipping Agent Code"; "Required Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Required E-Ship Agent Service"; "Required E-Ship Agent Service")
                {
                    Visible = false;
                }
                field("Allow Other Ship. Agent/Serv."; "Allow Other Ship. Agent/Serv.")
                {
                    Visible = false;
                }
                field("Pick Creation DateTime"; "Pick Creation DateTime")
                {
                    Visible = false;
                }
                field("Inventory Status Action"; "Inventory Status Action")
                {
                }
                field("Original Item No."; "Original Item No.")
                {
                }
                field("Substituted Item No."; "Substituted Item No.")
                {
                    Editable = false;
                }
                field(Substitute; Substitute)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("<Action3>")
                    {
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Enabled = false;
                    Image = ReservationLedger;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action(ItemTrackingLines)
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action("Select Item Substitution")
                {
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        ShowItemSub;
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    Caption = 'Item Charge &Assignment';
                    Enabled = false;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ItemChargeAssgnt;
                    end;
                }
                action(OrderPromising)
                {
                    Caption = 'Order &Promising';
                    Enabled = false;
                    Image = OrderPromising;
                    Visible = false;

                    trigger OnAction()
                    begin
                        OrderPromisingLine;
                    end;
                }
                group("Assemble to Order")
                {
                    Caption = 'Assemble to Order';
                    Image = AssemblyBOM;
                    action(AssembleToOrderLines)
                    {
                        Caption = 'Assemble-to-Order Lines';

                        trigger OnAction()
                        begin
                            ShowAsmToOrderLines;
                        end;
                    }
                    action("Roll Up &Price")
                    {
                        Caption = 'Roll Up &Price';
                        Ellipsis = true;

                        trigger OnAction()
                        begin
                            RollupAsmPrice;
                        end;
                    }
                    action("Roll Up &Cost")
                    {
                        Caption = 'Roll Up &Cost';
                        Ellipsis = true;

                        trigger OnAction()
                        begin
                            RollUpAsmCost;
                        end;
                    }
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Delete Pick")
                {

                    trigger OnAction()
                    var
                        CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                    begin
                        CancelSubMgt.DeletePick(Rec);
                    end;
                }
                action(GetPrice)
                {
                    Caption = 'Get Price';
                    Ellipsis = true;
                    Image = Price;

                    trigger OnAction()
                    begin
                        ShowPrices;
                    end;
                }
                action("Get Li&ne Discount")
                {
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;

                    trigger OnAction()
                    begin
                        ShowLineDisc
                    end;
                }
                action(ExplodeBOM_Functions)
                {
                    Caption = 'E&xplode BOM';
                    Enabled = false;
                    Image = ExplodeBOM;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }
                action("Insert Ext. Texts")
                {
                    Caption = 'Insert &Ext. Text';
                    Image = Text;

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
                action(Reserve)
                {
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Enabled = false;
                    Image = Reserve;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Find;
                        ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    Enabled = false;
                    Image = NonStockItem;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ShowNonstockItems;
                    end;
                }
                action("Get Seas. Cash Disc Qty")
                {

                    trigger OnAction()
                    var
                        SeasDiscMgt: Codeunit "Seasonal Discounts Mgt.";
                    begin
                        //SOC-SC 09-10-14
                        SeasDiscMgt.GetSLSeasCashDiscQty(Rec);
                    end;
                }
            }
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action("Order")
                {
                    RunObject = Page "Sales Order";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("Document No.");
                }
                action("Substitute/ Cancel")
                {

                    trigger OnAction()
                    begin
                        Substitute_Cancel();
                    end;
                }
                action(Reopen)
                {

                    trigger OnAction()
                    var
                        CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                    begin
                        CancelSubMgt.Reopen(Rec);
                    end;
                }
                action(Release)
                {

                    trigger OnAction()
                    var
                        CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                    begin
                        CancelSubMgt.Release(Rec);
                    end;
                }
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Enabled = false;
                    Image = Delivery;
                    Visible = false;
                    action("Purchase &Order")
                    {
                        Caption = 'Purchase &Order';
                        Enabled = false;
                        Image = Document;
                        Visible = false;

                        trigger OnAction()
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Enabled = false;
                    Image = SpecialOrder;
                    Visible = false;
                    action(OpenSpecialPurchaseOrder)
                    {
                        Caption = 'Purchase &Order';
                        Enabled = false;
                        Image = Document;
                        Visible = false;

                        trigger OnAction()
                        begin
                            OpenSpecialPurchOrderForm;
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //gdTotalAmt := GetTotalCount(); //SOC-SC 08-26-14
    end;

    trigger OnAfterGetRecord()
    var
        PMMgt: Codeunit "Product Management";
    begin
        ShowShortcutDimCode(ShortcutDimCode);

        //"Can be Produced Qty." := PMMgt.GetSLProduceableQty(Rec); //PM1.0
        //SetCreditLimitVisibility(); //PM1.0
        gbNonItem := (Type <> Type::Item); //SOC-SC 08-01-14
        GetHdrFields();
    end;

    trigger OnClosePage()
    begin
        Reset_InProcessUserID();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
            Commit;
            if not ReserveSalesLine.DeleteLineConfirm(Rec) then
                exit(false);
            ReserveSalesLine.DeleteLine(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitType;
        Clear(ShortcutDimCode);
        gbNonItem := (Type <> Type::Item); //SOC-SC 08-01-14
    end;

    trigger OnOpenPage()
    begin
        FilterGroup := 2;
        SetFilter("Outstanding Quantity", '>0');
        SetRange("Drop Shipment", false);
        SetRange("Special Order", false);

        if gsItemNo <> '' then
            SetRange("No.", gsItemNo);

        if gsProductNo <> '' then
            SetRange("Product Code", gsProductNo);
        FilterGroup := 0;
    end;

    var
        gsItemNo: Code[20];
        gsProductNo: Code[20];
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array[8] of Code[20];
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        [InDataSet]
        gbExceedingCreditLimit: Boolean;
        gbNonItem: Boolean;
        gdTotalAmt: Decimal;
        gdUnitPricePerCUOM: Decimal;
        gtOrderDate: Date;
        gsCustName: Text[50];
        goShippingStatus: Option ,Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
        goStatus: Option Open,Released,"Pending Approval","Pending Prepayment";
        gcInventoryStatus: Code[10];
        gdSubstitiuteUnitPrice: Decimal;

    [Scope('Internal')]
    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    [Scope('Internal')]
    procedure CalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    [Scope('Internal')]
    procedure ExplodeBOM()
    begin
        if "Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    [Scope('Internal')]
    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", "Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;

    [Scope('Internal')]
    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", "Special Order Purchase No.");
        if not PurchHeader.IsEmpty then begin
            PurchOrder.SetTableView(PurchHeader);
            PurchOrder.Editable := false;
            PurchOrder.Run;
        end else begin
            PurchRcptHeader.SetRange("Order No.", "Special Order Purchase No.");
            if PurchRcptHeader.Count = 1 then
                PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.Run(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;

    [Scope('Internal')]
    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            Commit;
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;

    [Scope('Internal')]
    procedure ShowNonstockItems()
    begin
        ShowNonstock;
    end;

    [Scope('Internal')]
    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal;
    end;

    [Scope('Internal')]
    procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt;
    end;

    [Scope('Internal')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    [Scope('Internal')]
    procedure ShowPrices()
    begin
        SalesHeader.Get("Document Type", "Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;

    [Scope('Internal')]
    procedure ShowLineDisc()
    begin
        SalesHeader.Get("Document Type", "Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;

    [Scope('Internal')]
    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type", "Document Type");
        OrderPromisingLine.SetRange("Source ID", "Document No.");
        OrderPromisingLine.SetRange("Source Line No.", "Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SetTableView(OrderPromisingLine);
        OrderPromisingLines.RunModal;
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Type = Type::Item;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord;

        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("No." <> xRec."No.")
        then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and ("Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        if Type = Type::Item then
            case Reserve of
                Reserve::Always:
                    begin
                        CurrPage.SaveRecord;
                        AutoReserve;
                        CurrPage.Update(false);
                        UpdateIsDone := true;
                    end;
                Reserve::Optional:
                    if (Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                        CurrPage.SaveRecord;
                        CurrPage.Update(false);
                        UpdateIsDone := true;
                    end;
            end;

        if (Type = Type::Item) and
           (Quantity <> xRec.Quantity) and
           not UpdateIsDone
        then
            CurrPage.Update(true);

        SetCreditLimitVisibility(); //PM1.0
    end;

    local procedure QtyToAsmToOrderOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        if Reserve = Reserve::Always then
            AutoReserve;
        CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
            CurrPage.SaveRecord;
            AutoAsmToOrder;
            CurrPage.Update(false);
        end;
    end;

    [Scope('Internal')]
    procedure SetCreditLimitVisibility()
    var
        PMMgt: Codeunit "Product Management";
    begin
        gbExceedingCreditLimit := PMMgt.GetExceedingCreditLimit(Rec); //PM1.0
    end;

    [Scope('Internal')]
    procedure GetTotalCount() retTotalAmt: Decimal
    var
        recSL: Record "Sales Line";
    begin
        retTotalAmt := 0;
        recSL.Reset();
        recSL.SetRange("Document Type", "Document Type");
        recSL.SetRange("Document No.", "Document No.");
        if recSL.FindSet() then begin
            recSL.CalcSums("Line Amount");
            retTotalAmt := recSL."Line Amount";
        end;
    end;

    [Scope('Internal')]
    procedure GetUnitPricePerCUOM() retUnitPricePerCUOM: Decimal
    begin
        retUnitPricePerCUOM := 0;
    end;

    [Scope('Internal')]
    procedure GetHdrFields()
    var
        recSH: Record "Sales Header";
    begin
        recSH.Get("Document Type", "Document No.");
        gtOrderDate := recSH."Order Date";
        gsCustName := recSH."Sell-to Customer Name";
        goStatus := recSH.Status;
        goShippingStatus := recSH."Shipping Status";
    end;

    [Scope('Internal')]
    procedure UpdateSubsItemNo(SubsItemNo: Code[20])
    begin
        ModifyAll("Substituted Item No.", SubsItemNo);
    end;

    [Scope('Internal')]
    procedure Substitute_Cancel()
    var
        CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
    begin
        Rec.ModifyAll("In-process User ID", UserId);
        Reset();
        SetRange("In-process User ID", UserId);

        CancelSubMgt.SubstituteCancel(Rec, gcInventoryStatus, gdSubstitiuteUnitPrice);
        CurrPage.Update(false);
    end;

    [Scope('Internal')]
    procedure Reset_InProcessUserID()
    begin
        Rec.ModifyAll("In-process User ID", '');
    end;

    [Scope('Internal')]
    procedure SetItemNo(ItemNo: Code[20])
    begin
        gsItemNo := ItemNo;
    end;

    [Scope('Internal')]
    procedure SetProductNo(ProductNo: Code[20])
    begin
        gsProductNo := ProductNo;
    end;

    [Scope('Internal')]
    procedure SetInventoryStatus(cInventoryStatus: Code[10])
    begin
        gcInventoryStatus := cInventoryStatus;
    end;

    [Scope('Internal')]
    procedure AutofillSubstituteAll()
    begin
        Rec.ModifyAll("In-process User ID", UserId);
        Reset();
        FilterGroup := 2;
        SetRange("In-process User ID", UserId);
        FilterGroup := 0;

        SetRange("Quantity Shipped", 0);
        SetRange("Pick Qty.", 0);
        ModifyAll("Inventory Status Action", "Inventory Status Action"::Substitute);
        SetRange("Quantity Shipped");
        SetRange("Pick Qty.");
        CurrPage.Update(false);
    end;

    [Scope('Internal')]
    procedure AutofillCancelAll()
    begin
        Rec.ModifyAll("In-process User ID", UserId);
        Reset();
        FilterGroup := 2;
        SetRange("In-process User ID", UserId);
        FilterGroup := 0;

        SetRange("Pick Qty.", 0);
        ModifyAll("Inventory Status Action", "Inventory Status Action"::Cancel);
        SetRange("Pick Qty.");
        CurrPage.Update(false);
    end;

    [Scope('Internal')]
    procedure ResetActionAll()
    begin
        ModifyAll("Inventory Status Action", "Inventory Status Action"::" ");
        CurrPage.Update(false);
    end;
}

