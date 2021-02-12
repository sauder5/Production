table 50033 "Contract Rcpt-Invoice Link"
{
    // //SOC-SC 08-06-15
    //   Added field
    //     70; Vomitoxin Test Result; Decimal

    DrillDownPageID = "Contract Rcpt-Invoice Links";
    LookupPageID = "Contract Rcpt-Invoice Links";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Receipt Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Contract Receipt Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Settlement Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Invoice Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Created By"; Code[40])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Quantity Linked"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Scale Ticket No."; Code[20])
        {
            CalcFormula = Lookup ("Posted Receipt Line"."Ticket No." WHERE("Receipt No." = FIELD("Receipt No."),
                                                                           "Line No." = FIELD("Receipt Line No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Receipt Date"; Date)
        {
            CalcFormula = Lookup ("Posted Receipt Line"."Receipt Date" WHERE("Receipt No." = FIELD("Receipt No."),
                                                                             "Line No." = FIELD("Receipt Line No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; Moisture; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Moisture Test Result" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; Splits; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Splits Test Result" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Test Weight"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Test Weight Result" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Shrink %"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Shrink %" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56; "Recd. Gross Qty."; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Gross Quantity in Purchase UOM" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; "Recd. Shrink Qty."; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Shrink Qty." WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Recd. Net Qty."; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Net Quantity in Purchase UOM" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Check-off %"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Check-off %" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Unit Premium/Discount"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Unit Premium/Discount" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Premium/Discount Amount"; Decimal)
        {
            CalcFormula = Lookup ("Purchase Contract Line"."Premium/ Discount Amount" WHERE("Contract No." = FIELD("Contract No."),
                                                                                            "Transaction Type" = CONST(Invoice),
                                                                                            "Line No." = FIELD("Invoice Line No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Check-off Amount"; Decimal)
        {
            CalcFormula = Lookup ("Purchase Contract Line"."Check-off Amount" WHERE("Contract No." = FIELD("Contract No."),
                                                                                    "Transaction Type" = CONST(Invoice),
                                                                                    "Line No." = FIELD("Invoice Line No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Vomitoxin Test Result"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Vomitoxin Test Result" WHERE("No." = FIELD("Receipt No.")));
            Description = 'SOC FF';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

