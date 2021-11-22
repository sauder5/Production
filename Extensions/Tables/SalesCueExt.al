tableextension 69053 SalesCueExt extends "Sales Cue"
{
    fields
    {
        field(50100; "Missing License"; integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order), "Rupp Missing Reqd License" = FILTER(true)));
        }
        field(50101; "Missing Liability Waiver"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order), "Rupp Missing Reqd Liability" = FILTER(true)));
        }
        field(50102; "Missing Quality Release Waiver"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order), "Rupp Missing Reqd Quality Rel" = FILTER(true)));
        }
    }
}