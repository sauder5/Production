table 50012 "Purchase Contract Line"
{
    // //SOC-SC 08-06-15
    //   Added field
    //     120; Vomitoxin Test Result; Decimal
    // 
    // //SOC-SC 10-06-15
    //   Fixed Invoice Unit Cost
    // 
    // //SOC-SC 10-09-15
    //   Fixed rounding of Check-off Unit Price calculation

    DrillDownPageID = "Purchase Contract Lines";
    LookupPageID = "Purchase Contract Lines";

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Purchase Contract Header";
        }
        field(2; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            OptionMembers = Settlement,Receipt,Invoice;

            trigger OnValidate()
            var
                recPurchCont: Record "Purchase Contract Header";
            begin
                /*IF "Transaction Type" <> "Transaction Type"::Receipt THEN BEGIN
                  recPurchCont.GET("Contract No.");
                  "Posting Date"  := recPurchCont."Posting Date";
                END;
                */

            end;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item;
        }
        field(11; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            ValidateTableRelation = false;
        }
        field(13; "Quality Premium Code"; Code[20])
        {
            CalcFormula = Lookup ("Purchase Contract Header"."Quality Premium Code" WHERE("No." = FIELD("Contract No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Check-off Payment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Vendor;
        }
        field(23; "Transaction Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Transaction Type", "Transaction Type"::Settlement);
                TestField("Post Invoice to Pay");
            end;
        }
        field(25; "Creation Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(30; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                //TESTFIELD("Transaction Type", "Transaction Type"::Settlement);
                case "Transaction Type" of
                    "Transaction Type"::Settlement:
                        begin
                            if "Item No." = '' then begin
                                InitRecord();
                            end;
                            UpdateSettLineAmount();
                            UpdateInvoiceCost();
                        end;
                    "Transaction Type"::Invoice:
                        begin
                            UpdateInvoiceCost();
                            UpdateQtyNotRecd();
                        end;
                    "Transaction Type"::Receipt:
                        begin
                            UpdateQtyNotInvoiced();
                        end;
                end;
            end;
        }
        field(31; "Settlement Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Transaction Type", "Transaction Type"::Settlement);
                UpdateSettLineAmount();
            end;
        }
        field(32; "Settlement Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
            Editable = false;
        }
        field(33; "Post Invoice to Pay"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Post Invoice to Pay" then begin
                    Validate("Invoice %", 100);
                end else begin
                    Validate("Invoice %", 0);
                end;
            end;
        }
        field(34; "Invoice %"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestValues();
                TestField("Transaction Type", "Transaction Type"::Settlement);
                if "Invoice %" = 0 then begin
                    if "Post Invoice to Pay" then begin
                        Error('"Invoice % cannot be zero');
                    end;
                end;
                UpdateQtyNotInvoiced();
            end;
        }
        field(35; "Recd/Settled Qty. Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateQtyNotInvoiced();
            end;
        }
        field(36; "Recd/Settled Qty. Not Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                //Nothing here
            end;
        }
        field(37; "Settled Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Settlement Invoiced"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Premium/ Discount Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceCost();
            end;
        }
        field(41; "Premium/ Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(42; "Check-off %"; Decimal)
        {
            CalcFormula = Lookup ("Purchase Contract Header"."Check-off %" WHERE("No." = FIELD("Contract No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Check-off Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(44; "Check-off Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(45; "Invoice Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                UpdateInvoicedAmount();
            end;
        }
        field(46; "Invoice Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(47; "Invoiced Line Received Qty"; Decimal)
        {

            trigger OnValidate()
            begin
                UpdateQtyNotRecd();
            end;
        }
        field(48; "Invoiced Line Qty Yet To Rcv"; Decimal)
        {
            Description = 'Calculated';
            Editable = false;
        }
        field(50; "Purch. Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(51; "Purch. Invoice Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(52; "Purchase Order No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(53; "Purchase Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Qty. Recd"; Decimal)
        {
            CalcFormula = Sum ("Purch. Rcpt. Line".Quantity WHERE("Purchase Contract No." = FIELD("Contract No."),
                                                                  "Purchase Contract Inv Line No." = FIELD("Line No.")));
            Description = 'FF';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(61; "Qty. Pre-Received"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'MAYBE DELETE';
            Editable = false;
            Enabled = false;
        }
        field(70; "Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(71; "Receipt Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(72; "Purch. Receipt Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(100; "Scale Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(101; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(102; Moisture; Decimal)
        {
            Description = 'From Receipt Line';
            DataClassification = CustomerContent;
        }
        field(103; Splits; Decimal)
        {
            Description = 'From Receipt Line';
            DataClassification = CustomerContent;
        }
        field(104; "Test Weight"; Decimal)
        {
            Description = 'From Receipt Line';
            DataClassification = CustomerContent;
        }
        field(105; "Shrink %"; Decimal)
        {
            Description = 'From Receipt Line';
            DataClassification = CustomerContent;
        }
        field(106; "Recd. Gross Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(107; "Recd. Shrink Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(108; "Recd. Net Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(110; "Recd. Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(111; "Recd. Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
            Editable = false;
        }
        field(112; "Recd. Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(113; "Recd. Unit Premium/Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
            Editable = false;
        }
        field(115; "Recd. Qty. to Print"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Internally used for Settlement Detail report';
            Editable = false;
        }
        field(120; "Vomitoxin Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
            MaxValue = 99;
            MinValue = 0;
        }
        field(130; "Recd. Splits Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(131; "Recd. Test Weight Unit Disc"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(132; "Recd. Vomitoxin Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(133; "Recd. Seed Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'From Receipt Line';
        }
        field(135; "Recd. Splits Premium Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
        }
        field(136; "Recd. Test Weight Disc Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
        }
        field(137; "Recd. Vomitoxin Disc Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
        }
        field(138; "Recd. Seed Premium Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Transaction Type", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Check-off Amount";
        }
        key(Key2; "Transaction Date")
        {
        }
        key(Key3; "Sequence No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recPurchContract: Record "Purchase Contract Header";
    begin
        if recPurchContract.Get("Contract No.") then begin
            recPurchContract.TestField(Status, recPurchContract.Status::Open);
        end;
        TestField("Settlement Invoiced", false);
    end;

    trigger OnInsert()
    begin
        InitRecord();
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';

    [Scope('Internal')]
    procedure UpdateSettLineAmount()
    begin
        "Settlement Line Amount" := Quantity * "Settlement Unit Cost";
    end;

    [Scope('Internal')]
    procedure UpdateQtyNotInvoiced()
    begin
        "Recd/Settled Qty. Not Invoiced" := Quantity - "Recd/Settled Qty. Invoiced";
    end;

    [Scope('Internal')]
    procedure UpdateInvoiceCost()
    var
        dUnitPrice: Decimal;
    begin
        CalcFields("Check-off %");
        "Premium/ Discount Amount" := "Premium/ Discount Unit Cost" * Quantity;
        dUnitPrice := "Settlement Unit Cost" * "Invoice %" / 100;
        //"Check-off Unit Cost" := ROUND((dUnitPrice) *  "Check-off %"/100, 0.01);
        "Check-off Unit Cost" := Round((dUnitPrice) * "Check-off %" / 100, 0.00001); //SOC-SC 10-09-15
        "Check-off Amount" := "Check-off Unit Cost" * Quantity;
        //VALIDATE("Invoice Unit Cost", (dUnitPrice - "Check-off Unit Cost" + "Premium/ Discount Unit Cost")); //SOC-SC 10-06-15 commenting
        Validate("Invoice Unit Cost", (dUnitPrice - "Check-off Unit Cost")); //SOC-SC 10-06-15
    end;

    [Scope('Internal')]
    procedure TestValues()
    begin
        TestField("Item No.");
        TestField("Purch. Unit of Measure Code");
        TestField("Vendor No.");
    end;

    [Scope('Internal')]
    procedure UpdateInvoicedAmount()
    begin
        "Invoice Line Amount" := Quantity * "Invoice Unit Cost";
    end;

    [Scope('Internal')]
    procedure UpdateQtyNotRecd()
    begin
        "Invoiced Line Qty Yet To Rcv" := Quantity - "Invoiced Line Received Qty";
    end;

    [Scope('Internal')]
    procedure InitRecord()
    var
        recPurchCont: Record "Purchase Contract Header";
    begin
        recPurchCont.Get("Contract No.");
        recPurchCont.TestField("Vendor No.");
        recPurchCont.TestField("Item No.");
        recPurchCont.TestField("Purch. Unit of Measure Code");

        if "Item No." = '' then
            "Item No." := recPurchCont."Item No.";

        if "Vendor No." = '' then
            "Vendor No." := recPurchCont."Vendor No.";

        if "Purch. Unit of Measure Code" = '' then
            "Purch. Unit of Measure Code" := recPurchCont."Purch. Unit of Measure Code";

        "Transaction Date" := Today;
        if "Transaction Type" <> "Transaction Type"::Receipt then
            "Posting Date" := recPurchCont."Posting Date";

        if "Sequence No." = 0 then
            "Sequence No." := GetLastSequenceNo() + 1;

        "Creation Date" := Today;
    end;

    [Scope('Internal')]
    procedure GetLastSequenceNo() retLastSeqNo: Integer
    var
        recPurchContractLn: Record "Purchase Contract Line";
    begin
        retLastSeqNo := 0;

        recPurchContractLn.SetCurrentKey("Sequence No.");
        if recPurchContractLn.FindLast() then begin
            retLastSeqNo := recPurchContractLn."Sequence No.";
        end;
    end;
}

