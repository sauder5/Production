tableextension 65767 WarehouseActLineExt extends "Warehouse Activity Line"
{
    fields
    {
        field(50000; "Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Created Date Time"; datetime)
        {
            DataClassification = CustomerContent;
        }
        field(51000; "Ship-to Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(51001; "Unit Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Line Seed Weight in g" := "Unit Seed Weight in g" * Quantity;
            end;
        }
        field(51002; "Line Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Unit Seed Weight in g" := ROUND("Line Seed Weight in g" / Quantity, 0.01);
            end;
        }
        field(51003; "Internal Lot No."; Code[40])
        {
            DataClassification = CustomerContent;
        }
        field(51004; "Country of Origin Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterDelete()
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        RuppFun.UpdateHdrShpgStatusFromPickLn(Rec, true);
    end;
}