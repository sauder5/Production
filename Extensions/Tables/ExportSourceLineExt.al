tableextension 80983 ExportSourceLine extends "Export Source Line"
{
    fields
    {
        field(51000; "Internal Lot No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(51001; "Unit Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Line Seed Weight in kg" := "Unit Seed Weight in g" * "Source Quantity" / 1000;
            end;
        }
        field(51002; "Line Seed Weight in kg"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Unit Seed Weight in g" := ROUND("Line Seed Weight in kg" * 1000 / "Source Quantity", 0.01);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if Type = Type::Item then
                    UpdateSeedInfo();
            end;
        }
        modify("Export Information Code")
        {
            trigger OnAfterValidate()
            begin
                if Type = Type::Item then
                    UpdateSeedInfo();
            end;
        }
        modify("Source Quantity")
        {
            trigger OnAfterValidate()
            begin
                if Type = Type::Item then
                    UpdateSeedInfo();
            end;
        }
    }

    var
        recWhseActLn: Record "Warehouse Activity Line";
        recRegWhseActLn: Record "Registered Whse. Activity Line";

    trigger OnAfterModify()
    begin
        UpdateSeedInfo();
    end;

    procedure UpdateSeedInfo()
    begin
        //SOC-SC 08-29-15
        IF "Source Type" = 36 THEN BEGIN
            IF "Source SubType" = 1 THEN BEGIN
                IF "Source ID" <> '' THEN BEGIN
                    IF Type = Type::Item THEN BEGIN
                        recWhseActLn.RESET();
                        recWhseActLn.SETRANGE("Activity Type", recWhseActLn."Activity Type"::Pick);
                        recWhseActLn.SETRANGE("Source Type", 37);
                        recWhseActLn.SETRANGE("Source Subtype", "Source SubType");
                        recWhseActLn.SETRANGE("Source No.", "Source ID");
                        recWhseActLn.SETRANGE("Item No.", "No.");
                        recWhseActLn.SETRANGE("Action Type", recWhseActLn."Action Type"::Take);
                        IF recWhseActLn.FINDFIRST() THEN BEGIN
                            "Internal Lot No." := recWhseActLn."Internal Lot No.";
                            IF recWhseActLn."Country of Origin Code" <> '' THEN
                                VALIDATE("Country of Origin Code", recWhseActLn."Country of Origin Code");
                            VALIDATE("Unit Seed Weight in g", recWhseActLn."Unit Seed Weight in g");
                            if MODIFY() then;
                        END ELSE BEGIN
                            recRegWhseActLn.RESET();
                            recRegWhseActLn.SETRANGE("Activity Type", recRegWhseActLn."Activity Type"::Pick);
                            recRegWhseActLn.SETRANGE("Source Type", 37);
                            recRegWhseActLn.SETRANGE("Source Subtype", "Source SubType");
                            recRegWhseActLn.SETRANGE("Source No.", "Source ID");
                            recRegWhseActLn.SETRANGE("Item No.", "No.");
                            recRegWhseActLn.SETRANGE("Action Type", recRegWhseActLn."Action Type"::Take);
                            IF recRegWhseActLn.FINDLAST() THEN BEGIN
                                "Internal Lot No." := recRegWhseActLn."Internal Lot No.";
                                IF recRegWhseActLn."Country of Origin Code" <> '' THEN
                                    VALIDATE("Country of Origin Code", recRegWhseActLn."Country of Origin Code");
                                VALIDATE("Unit Seed Weight in g", recRegWhseActLn."Unit Seed Weight in g");
                                if MODIFY() then;
                            END;
                        END;
                    END;
                END;
            END;
        END;
    end;
}