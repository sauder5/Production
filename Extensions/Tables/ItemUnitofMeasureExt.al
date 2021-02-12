tableextension 65404 ItemUnitofMeasureExt extends "Item Unit of Measure"
{
    fields
    {
        field(51000; "Lowest UOM Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(51001; "Common UOM Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(51002; "Qty. per Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Qty. per Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        modify(Code)
        {
            trigger OnBeforeValidate()
            var
                recUOM: Record "Unit of Measure";
            begin
                //SOC-SC 08-24-14
                IF recUOM.GET(Code) THEN BEGIN
                    "Lowest UOM Code" := recUOM."Lowest UOM Code";
                    "Common UOM Code" := recUOM."Common UOM Code";
                    "Qty. per Lowest UOM" := recUOM."Qty. per Lowest UOM";
                    "Qty. per Common UOM" := recUOM."Qty. per Common UOM";
                END ELSE BEGIN
                    "Lowest UOM Code" := '';
                    "Common UOM Code" := '';
                    "Qty. per Lowest UOM" := 0;
                    "Qty. per Common UOM" := 0;
                END;


            end;
        }
    }
}