page 50099 "Split Load"
{
    // version GroProd

    PageType = ListPart;
    SourceTable = "Scale Ticket Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production Lot No.";"Production Lot No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Scale Ticket No.";"Scale Ticket No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                }
                field("Vendor Name";"Vendor Name")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Farm No.";"Farm No.")
                {
                    Caption = 'Farm No.';
                }
                field("Field No.";"Field No.")
                {
                    Caption = 'Field No.';
                }
                field("recProdLot.""Item No.""";recProdLot."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Item Description""";recProdLot."Item Description")
                {
                    Caption = 'Item Description';
                    Editable = false;
                    Enabled = false;
                }
                field("Split Load %";"Split Load %")
                {
                }
                field("Gross Wgt (LB)";"Gross Wgt (LB)")
                {
                }
                field("Tare Wgt (LB)";"Tare Wgt (LB)")
                {
                }
                field("Net Wgt (LB)";"Net Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Gross Qty In Purchase UOM";"Gross Qty In Purchase UOM")
                {
                    Enabled = false;
                }
                field("recProdLot.""Purchase UOM""";recProdLot."Purchase UOM")
                {
                    Caption = 'Purchase UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity  Code""";recProdLot."Commodity  Code")
                {
                    Caption = 'Quality Premium Code';
                    Editable = false;
                    Enabled = false;
                }
                field("recProdLot.""Commodity Premium per UOM""";recProdLot."Commodity Premium per UOM")
                {
                    Caption = 'Quality Premium Per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Moisture Test Result""";recScaleTkt."Moisture Test Result")
                {
                    Caption = 'Moisture Test Result';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Moisture Discount per UOM""";recScaleTkt."Moisture Discount per UOM")
                {
                    Caption = 'Moisture Discount per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Shrink %""";recScaleTkt."Shrink %")
                {
                    Caption = 'Shrink %';
                    Editable = false;
                    Enabled = false;
                }
                field("Shrink Qty";"Shrink Qty")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Splits Test Result""";recScaleTkt."Splits Test Result")
                {
                    Caption = 'Splits Test Result';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Splits Premium per UOM""";recScaleTkt."Splits Premium per UOM")
                {
                    Caption = 'Splits Premium per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Test Weight Result""";recScaleTkt."Test Weight Result")
                {
                    Caption = 'Test Weight Result';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Test Weight Discount per UOM""";recScaleTkt."Test Weight Discount per UOM")
                {
                    Caption = 'Test Discount per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Vomitoxin Test Result""";recScaleTkt."Vomitoxin Test Result")
                {
                    Caption = 'Vomitoxin Test Result';
                    Editable = false;
                    Enabled = false;
                }
                field("recScaleTkt.""Vomitoxin Discount per UOM""";recScaleTkt."Vomitoxin Discount per UOM")
                {
                    Caption = 'Vomitoxin Discount Per UOM';
                    Editable = false;
                    Enabled = false;
                }
                field("Net Qty In UOM";"Net Qty In UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Total Prem/Disc Per UOM";"Total Prem/Disc Per UOM")
                {
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if recProdLot.GET("Production Lot No.") then ;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then ;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Init("Production Lot No.", "Scale Ticket No.");
        if recProdLot.GET("Production Lot No.") then ;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then ;
    end;

    trigger OnOpenPage();
    begin
        if recProdLot.GET("Production Lot No.") then ;
        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then ;
    end;

    var
        recProdLot : Record "Production Lot";
        recScaleTkt : Record "Scale Ticket Header";
}

