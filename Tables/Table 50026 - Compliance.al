table 50026 Compliance
{
    // //SOC-SC 01-05-16
    //   Added code in Onvalidate of certian fields to update the sales lines

    DrillDownPageID = Compliances;
    LookupPageID = Compliances;

    fields
    {
        field(1; "Waiver Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Compliance Group"."Waiver Code";

            trigger OnValidate()
            var
                recItemComplGrp: Record "Compliance Group";
            begin
                if recItemComplGrp.Get("Waiver Code") then begin
                    "Vendor No." := recItemComplGrp."Vendor No.";
                end else begin
                    "Vendor No." := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = Customer;
        }
        field(3; "Ship-to Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(4; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Internal use';
            Editable = false;
            TableRelation = Vendor;
        }
        field(11; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = License,"Liability Waiver","Quality Release Waiver";
        }
        field(20; "License No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("License No.")); //SOC-SC 01-05-16

                if "License No." <> '' then begin
                    "License Issued Date" := WorkDate;
                end else begin
                    "License Issued Date" := 0D;
                end;
            end;
        }
        field(21; "License Issued Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("License No.");
            end;
        }
        field(22; "License Expiration Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("License No.");
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("License Expiration Date")); //SOC-SC 01-05-16
            end;
        }
        field(30; "Liability Waiver Signed"; Boolean)
        {

            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Liability Waiver Signed")); //SOC-SC 01-05-16

                if "Liability Waiver Signed" then begin
                    "Liability Waiver Signed Date" := WorkDate;
                    "Liability Waiver Start Date" := WorkDate;
                end else begin
                    "Liability Waiver Signed Date" := 0D;
                    "Liability Waiver Start Date" := 0D;
                end;
            end;
        }
        field(31; "Liability Waiver Signed Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Liability Waiver Signed");
            end;
        }
        field(32; "Quality Release Signed"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Quality Release Signed")); //SOC-SC 01-05-16

                if "Quality Release Signed" then begin
                    "Quality Release Signed Date" := WorkDate;
                end else begin
                    "Quality Release Signed Date" := 0D;
                end;
            end;
        }
        field(33; "Quality Release Signed Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Quality Release Signed");
            end;
        }
        field(40; "Liability Waiver Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Liability Waiver Signed");
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Liability Waiver Start Date")); //SOC-SC 01-05-16
            end;
        }
        field(41; "Liability Waiver End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Liability Waiver Signed");
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Liability Waiver End Date")); //SOC-SC 01-05-16
            end;
        }
        field(42; "Quality Release Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Quality Release Signed");
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Quality Release Start Date")); //SOC-SC 01-05-16
            end;
        }
        field(43; "Quality Release End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Quality Release Signed");
                //UpdateSalesLines(FALSE);
                ComplianceMgt.UpdateSalesLineOnModify(Rec, FieldNo("Quality Release End Date")); //SOC-SC 01-05-16
            end;
        }
    }

    keys
    {
        key(Key1; "Waiver Code", "Customer No.", "Ship-to Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ComplianceMgt: Codeunit "Compliance Management";
    begin
        UpdateSalesLines(true);
    end;

    trigger OnInsert()
    begin
        UpdateSalesLines(false);
    end;

    var
        ComplianceMgt: Codeunit "Compliance Management";

    [Scope('Internal')]
    procedure UpdateSalesLines(bDelete: Boolean)
    var
        ComplianceMgt: Codeunit "Compliance Management";
    begin
        ComplianceMgt.UpdateSalesLinesForCompliance(Rec, bDelete);
    end;
}

