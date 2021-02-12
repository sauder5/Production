tableextension 80702 PackageLineExt extends "Package Line"
{
    fields
    {
        field(51000; "Warehouse Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Package."Warehouse Shipment No." WHERE("No." = FIELD("Package No.")));
        }
    }
    trigger OnAfterInsert()
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        RuppFun.UpdateHdrShpgStatusFromPackLn(Rec, FALSE); //SOC-SC 09-03-14
    end;
}