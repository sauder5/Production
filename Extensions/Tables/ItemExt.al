tableextension 60027 ItemExt extends Item
{
    fields
    {
        field(50000; "Purchase Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(51000; "Inventory Status Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where (Type = const ("Inventory Status"));
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
            begin
                CancelSubMgt.InventoryStatusValidateFromItem(Rec);
                IF "Inventory Status Code" <> '' THEN BEGIN
                    "Inventory Status Modified Date" := WORKDATE;
                END ELSE BEGIN
                    "Inventory Status Modified Date" := 0D;
                END;
            end;
        }
        field(51001; "Inventory Status Modified Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(51002; Treatment; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Treatment Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51004; "Rupp Product Group Code"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rupp Product Group"."Rupp Product Group Code";
            Caption = 'Product Group Code';
        }
        field(51006; "Generic Name Code"; Code[20])
        {
            TableRelation = "Product Attribute".Code WHERE ("Attribute Type" = FILTER ("Generic Name"));
            DataClassification = CustomerContent;
        }
        field(51007; "Shipping On Hold"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51010; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                recProduct: Record Product;

            begin
                //SOC-MA 09-09-14

                IF "Product Code" <> '' THEN BEGIN
                    recProduct.GET("Product Code");
                    "LowestUOM Qty. per CommonUOM" := recProduct."LowestUOM Qty. per CommonUOM";
                    "Generic Name Code" := recProduct."Generic Name Code";
                    //Maturity              := recProduct.Maturity;
                    "Treatment Code" := recProduct."Treatment Code";
                    //"Item Group Code"     := recProduct."Item Group Code";
                    //"Variety Code"        := recProduct."Variety Code";
                    //"Seed Size"           := recProduct."Seed Size";
                    //"Planting Season"     := recProduct."Planting Season";
                    "Checkoff %" := recProduct."Checkoff %";
                    "Quality Premium Code" := recProduct."Quality Premium Code";
                    "Inventory Status Code" := recProduct."Inventory Status Code";

                    IF "Global Dimension 1 Code" = '' THEN
                        IF recProduct."Global Dimension 1 Code" <> '' THEN
                            VALIDATE("Global Dimension 1 Code", recProduct."Global Dimension 1 Code");

                    IF "Global Dimension 2 Code" = '' THEN
                        IF recProduct."Global Dimension 2 Code" <> '' THEN
                            VALIDATE("Global Dimension 2 Code", recProduct."Global Dimension 2 Code");

                    IF "Item Category Code" = '' THEN
                        IF recProduct."Item Category Code" <> '' THEN
                            VALIDATE("Item Category Code", recProduct."Item Category Code");

                END ELSE BEGIN
                    "LowestUOM Qty. per CommonUOM" := 0;
                END;

                UpdateUOMQuantities();
            end;
        }
        field(51011; "Product Qty. in Lowest UOM"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Lowest UOM" WHERE ("Product Code" = FIELD ("Product Code"), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter"), "Variant Code" = FIELD ("Variant Filter"), "Lot No." = FIELD ("Lot No. Filter"), "Serial No." = FIELD ("Serial No. Filter")));
        }
        field(51012; "Product Qty. in Common UOM"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Common UOM" WHERE ("Product Code" = FIELD ("Product Code"), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter"), "Variant Code" = FIELD ("Variant Filter"), "Lot No." = FIELD ("Lot No. Filter"), "Serial No." = FIELD ("Serial No. Filter")));
        }
        field(51013; "Product Qty. in Base UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51014; "LowestUOM Qty. per CommonUOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51015; "Qty. on Pick"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Warehouse Activity Line"."Qty. (Base)" WHERE ("Activity Type" = CONST (Pick), "Action Type" = CONST (Take), "Item No." = FIELD ("No."), "Location Code" = FIELD ("Location Filter")));
        }
        field(51016; "Qty. Available to Pick"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51017; "Qty. Available to Sell"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51020; "Quality Premium Code"; Code[10])
        {
            TableRelation = "Commodity Settings";
            DataClassification = CustomerContent;
        }
        field(51021; "Checkoff %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51030; "Qty. in Lowest UOM"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Lowest UOM" WHERE ("Item No." = FIELD ("No."), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter"), "Drop Shipment" = FIELD ("Drop Shipment Filter"), "Variant Code" = FIELD ("Variant Filter"), "Lot No." = FIELD ("Lot No. Filter"), "Serial No." = FIELD ("Serial No. Filter")));
        }
        field(51031; "Qty. in Common UOM"; decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Qty. in Common UOM" WHERE ("Item No." = FIELD ("No."), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter"), "Drop Shipment" = FIELD ("Drop Shipment Filter"), "Variant Code" = FIELD ("Variant Filter"), "Lot No." = FIELD ("Lot No. Filter"), "Serial No." = FIELD ("Serial No. Filter")));
        }
        field(51032; "Qty. per Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51034; "Qty. can be Produced"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51035; "Qty. on Production"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Produced Item"."Remaining Quantity (Base)" WHERE ("Item No." = FIELD ("No."), "Location Code" = FIELD ("Location Filter")));
        }
        field(51036; "Qty. on Consumption"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Consumed Item"."Remaining Quantity (Base)" WHERE (Type = CONST (Item), "No." = FIELD ("No."), "Location Code" = FIELD ("Location Filter"), Template = CONST (false), Status = CONST (Open)));
        }
        field(51037; "Qty On PO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "No." = FIELD ("No."), "Shortcut Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter"), "Drop Shipment" = FIELD ("Drop Shipment Filter"), "Variant Code" = FIELD ("Variant Filter"), "Expected Receipt Date" = FIELD ("Date Filter"), "Future PO" = FILTER (False)));
        }

        field(51040; "Seasonal Cash Disc Code"; Code[20])
        {
            TableRelation = "Season Code";
            FieldClass = FlowField;
            CalcFormula = Lookup (Product."Seasonal Cash Disc Code" WHERE (Code = FIELD ("Product Code")));
        }
        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            begin
                UpdateUOMQuantities();
            end;
        }
    }
    fieldgroups
    {

        addlast(DropDown; Inventory, "Inventory Status Code")
        {

        }
    }

    var
        cduProdMgt: Codeunit "Product Management";
        InvQtyRec: Record "Inventory Quantities";

    procedure UpdateCalculatedQuantities()
    var

    begin
        //SOC-MA 09-09-14
        cduProdMgt.UpdateItemCalculatedQuantities(Rec);
    end;

    procedure GetProductQuantity() RetQty: Decimal
    begin
        RetQty := cduProdMgt.GetItemProductQuantity(Rec);
    end;

    procedure GetQuantityAvailableToPick() RetQty: Decimal
    begin
        RetQty := cduProdMgt.GetItemQuantityAvailableToPick(Rec);
    end;

    procedure GetQuantityCanBeProduced() RetQty: Decimal
    begin
        RetQty := cduProdMgt.GetItemQuantityCanBeProduced(Rec);
    end;

    procedure UpdateUOMQuantities()
    begin
        cduProdMgt.UpdateItemUOMQuantities(Rec);
    end;

    procedure GetQuantityAvailableToSell() RetQty: Decimal
    begin
        //RSI-KS
        IF InvQtyRec.GET("No.") THEN
            RetQty := InvQtyRec."Avl. to Sell"
        ELSE
            RetQty := 0;
        //RSI-KS
    end;

    procedure GetProductQtyInCommonUOM() RetQty: Decimal
    begin
        IF "Product Code" = '' THEN BEGIN
            RetQty := 0;
        END ELSE BEGIN
            CALCFIELDS("Product Qty. in Common UOM");
            RetQty := "Product Qty. in Common UOM";
        END;
    end;

    procedure GetProductQtyInLowestUOM() RetQty: Decimal
    begin
        IF "Product Code" = '' THEN BEGIN
            RetQty := 0;
        END ELSE BEGIN
            CALCFIELDS("Product Qty. in Lowest UOM");
            RetQty := "Product Qty. in Lowest UOM";
        END;
    end;
}