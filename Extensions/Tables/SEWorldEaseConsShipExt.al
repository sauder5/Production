tableextension 80603 SEWorldEaseConsShipExt extends "SE World Ease Consol. Shipment"
{
    fields
    {
        field(51000; "Unit Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Line Seed Weight in g" := "Unit Seed Weight in g" * Quantity;
            end;
        }
        field(51001; "Line Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Unit Seed Weight in g" := ROUND("Line Seed Weight in g" / Quantity, 0.01);
            end;
        }
        field(51002; "Internal Lot No."; Code[40])
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Country of Origin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}