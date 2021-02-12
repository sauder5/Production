tableextension 67023 SalesPriceWorkSheetExt extends "Sales Price Worksheet"
{
    fields
    {
        field(51000; "Generic Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code where("Attribute Type" = const("Generic Name"));
            DataClassification = CustomerContent;
        }
        field(51010; "Current Unit Price per CUOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51011; "New Unit Price per CUOM"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateUnitPrice();
            end;
        }
        field(51012; "Common UOM"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(51013; "Qty. per Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51020; "Batch Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Sales Price Worksheet Batch"));
            DataClassification = CustomerContent;
        }
        modify("New Unit Price")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Sales Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Minimum Quantity")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateNewUnitPricePerCUOM();
            end;
        }
    }
    procedure UpdateUnitPrice()
    begin
        CALCFIELDS("Qty. per Common UOM");
        "New Unit Price" := "Qty. per Common UOM" * "New Unit Price per CUOM";
    end;

    procedure UpdateCurrentUnitPricePerCUOM()
    begin
        CALCFIELDS("Qty. per Common UOM");
        "Current Unit Price per CUOM" := 0;
        IF "Qty. per Common UOM" <> 0 THEN BEGIN
            "Current Unit Price per CUOM" := ROUND("Current Unit Price" / "Qty. per Common UOM", 0.00001);
        END;
    end;

    procedure UpdateNewUnitPricePerCUOM()
    begin
        CALCFIELDS("Qty. per Common UOM");
        "New Unit Price per CUOM" := 0;
        IF "Qty. per Common UOM" <> 0 THEN BEGIN
            "New Unit Price per CUOM" := ROUND("New Unit Price" / "Qty. per Common UOM", 0.00001);
        END;
    end;
}