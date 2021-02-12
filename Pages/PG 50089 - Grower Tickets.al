page 50089 "Grower Tickets"
{
    // version GroProd

    CardPageID = "Grower Ticket";
    PageType = ListPart;
    SourceTable = "Grower Ticket";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Grower Ticket No."; "Grower Ticket No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Vendor No."; "Vendor No.")
                {

                    trigger OnValidate();
                    begin
                        if not recVendor.GET("Vendor No.") then
                            CLEAR(recVendor);
                    end;
                }
                field("Vendor Name"; recVendor.Name)
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Grower Share %"; "Grower Share %")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Bin Code"; "Bin Code")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Item No."; recProdLot."Item No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Item Description"; recProdLot."Item Description")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Gross Wgt (LB)"; "Gross Wgt (LB)")
                {
                    Editable = false;
                    HideValue = false;
                }
                field("Tare Wgt (LB)"; "Tare Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Net Wgt (LB)"; "Net Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Gross Qty in Purchase UOM"; "Gross Qty in Purchase UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Purchase UOM"; recProdLot."Purchase UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity  Code"""; recProdLot."Commodity  Code")
                {
                    Caption = 'Commodity Code';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity Premium per UOM"""; recProdLot."Commodity Premium per UOM")
                {
                    Caption = 'Commodity Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("Moisture Test Result"; recScaleTkt."Moisture Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Moisture Discount per UOM"; recScaleTkt."Moisture Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Shrink %"""; recScaleTkt."Shrink %")
                {
                    Caption = 'Shrink %';
                    Editable = false;
                    Enabled = false;
                }
                field("Shrink Qty per UOM"; "Shrink Qty per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Splits Test Result"; recScaleTkt."Splits Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Splits Premium per UOM"; recScaleTkt."Splits Premium per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Test Weight Result"; recScaleTkt."Test Weight Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Test Weight Discount Per UOM"; recScaleTkt."Test Weight Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Vomitoxin Test Result"; recScaleTkt."Vomitoxin Test Result")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Vomitozin Discount Per UOM"; recScaleTkt."Vomitoxin Discount per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Cropping Practice Code"""; recProdLot."Cropping Practice Code")
                {
                    Caption = 'Cropping Practice Code';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Cropping Premium per UOM"""; recProdLot."Cropping Premium per UOM")
                {
                    Caption = 'Cropping Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Additional Premium per UOM"""; recProdLot."Additional Premium per UOM")
                {
                    Caption = 'Additional Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("Out of Zone Prem per UOM"; recProdLot."Out of Zone Premium per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Check Off %"; recProdLot."Check off %")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Total Premi / Disc per UOM"; "Total Premi / Disc per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Net Qty in Purchase UOM"; "Net Qty in Purchase UOM")
                {
                }
                field("Settled Quantity"; "Settled Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if recProdLot.GET("Production Lot No.") then;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then;
        if recVendor.GET("Vendor No.") then;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        if recProdLot.GET("Production Lot No.") then;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then;
    end;

    trigger OnOpenPage();
    begin
        if recProdLot.GET("Production Lot No.") then;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then;
    end;

    var
        recProdLot: Record "Production Lot";
        recScaleTkt: Record "Scale Ticket Header";
        recVendor: Record Vendor;
        recProdGrower: Record "Production Grower";

    procedure SetDataFilter(VendorNo: Code[20]; GenericName: Code[20]);
    begin
        SETFILTER("Vendor No.", VendorNo);
        if GenericName > '' then
            SETFILTER("Generic Name Code", GenericName);
        CurrPage.UPDATE;
    end;
}

