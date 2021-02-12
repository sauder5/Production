tableextension 67002 SalesPriceExt extends "Sales Price"
{
    fields
    {
        field(51000; "Generic Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51001; Product; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51010; "Unit Price per Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateUnitPrice();
            end;
        }
        field(51011; "Common UOM"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51012; "Qty. per Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52001; "Allow Group Discount"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(52010; "Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                UpdateUnitPricePerCUOM();
            end;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                recItem: Record Item;
                recItemUom: Record "Item Unit of Measure";
            begin
                if recItem.get("Item No.") then
                    "Generic Code" := recItem."Generic Name Code";
                if recItemUom.get("Item No.", "Unit of Measure Code") then
                    "Common UOM" := recItemUom."Common UOM Code";
            end;
        }
    }
    procedure UpdateUnitPrice()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if not ItemUOM.get("Item No.", "Unit of Measure Code") then
            clear(ItemUOM);
        "Unit Price" := ItemUom."Qty. per Common UOM" * "Unit Price per Common UOM";
    end;

    procedure UpdateUnitPricePerCUOM()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if not ItemUOM.get("Item No.", "Unit of Measure Code") then
            clear(ItemUOM);
        "Unit Price per Common UOM" := 0;
        IF ItemUom."Qty. per Common UOM" <> 0 THEN BEGIN
            "Unit Price per Common UOM" := ROUND("Unit Price" / ItemUom."Qty. per Common UOM", 0.00001);
        END;
    end;

}