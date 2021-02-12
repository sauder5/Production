tableextension 67321 WarehouseShipLineExt extends "Warehouse Shipment Line"
{
    fields
    {
        field(50050; "Create Pick for Qty. to Pick"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Warehouse Shipment Header"."Create Pick for Qty. to Pick" WHERE("No." = FIELD("No.")));
        }
        field(50121; "Missing Reqd License"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Line"."Missing Reqd License" WHERE("Document No." = FIELD("Source No."), "Line No." = FIELD("Source Line No."), "No." = FIELD("Item No.")));
        }
        field(50123; "Missing Reqd Liability Waiver"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Line"."Missing Reqd Liability Waiver" WHERE("Document No." = FIELD("Source No."), "Line No." = FIELD("Source Line No."), "No." = FIELD("Item No.")));
        }
        field(50125; "Missing Reqd Quality Release"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Line"."Missing Reqd Quality Release" WHERE("Document No." = FIELD("Source No."), "Line No." = FIELD("Source Line No."), "No." = FIELD("Item No.")));
        }
        field(51000; "Qty. to Pick"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51005; "Item Tracking Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item."Item Tracking Code" WHERE("No." = FIELD("Item No.")));
        }
        modify("Qty. to Pick")
        {
            trigger OnAfterValidate()
            var
                dQtyLeft: Decimal;
            begin
                //SOC-SC 10-30-14
                CALCFIELDS("Pick Qty.");
                dQtyLeft := "Qty. Outstanding" - ("Qty. Picked" - "Qty. Shipped") - "Pick Qty.";
                IF "Qty. to Pick" > dQtyLeft THEN
                    ERROR('Qty. to Pick cannot be greater than %1', dQtyLeft);
                //SOC-SC 10-30-14
            end;
        }
    }
    var
        RuppFn: Codeunit "Rupp Functions";

    trigger OnAfterDelete()
    begin
        RuppFn.UpdateHdrShpgStatusFromWhseShptLn(Rec, true);
    end;
}