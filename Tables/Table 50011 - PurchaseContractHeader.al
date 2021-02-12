table 50011 "Purchase Contract Header"
{
    // //SOC-SC 10-09-15
    //   Changed calculation of the field "Qty. Received" and enabled it

    DrillDownPageID = "Purchase Contracts";
    LookupPageID = "Purchase Contracts";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TestField(Status, 0);
            end;
        }
        field(11; "Contract Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Status, 0);
            end;
        }
        field(12; "Delivery Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Status, 0);
                CheckDate();
            end;
        }
        field(13; "Delivery End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckDate();
            end;
        }
        field(14; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;

            trigger OnValidate()
            var
                recItem: Record Item;
                recProduct: Record Product;
                ContractMgt: Codeunit "Purchase Contract Checkoff Mgt";
                dGrossWt: Decimal;
                dNetWt: Decimal;
            begin
                TestField(Status, 0);

                "Quality Premium Code" := '';
                "Check-off %" := 0;
                "Item Description" := '';
                "Purch. Unit of Measure Code" := '';

                if recItem.Get("Item No.") then begin
                    //recItem.TESTFIELD("Item Tracking Code", '');
                    recItem.TestField("Purch. Unit of Measure");
                    recItem.TestField("Quality Premium Code");
                    ContractMgt.GetItemWt("Item No.", dGrossWt, dNetWt); //for testing if the item has the appropriate weight (Gross or Net)

                    "Item Description" := recItem.Description;
                    "Check-off %" := recItem."Checkoff %";
                    "Quality Premium Code" := recItem."Quality Premium Code";
                    "Purch. Unit of Measure Code" := recItem."Purch. Unit of Measure";

                    if ("Check-off %" = 0) or ("Quality Premium Code" = '') then begin
                        if recItem."Product Code" <> '' then begin
                            if recProduct.Get(recItem."Product Code") then begin
                                //"Item Description" := recProduct.Description;
                                if "Check-off %" = 0 then begin
                                    "Check-off %" := recProduct."Checkoff %";
                                end;
                                if "Quality Premium Code" = '' then begin
                                    "Quality Premium Code" := recProduct."Quality Premium Code";
                                end;
                            end;
                        end;
                    end;

                end;
                UpdateBinCode();
            end;
        }
        field(15; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcFields("Qty. Received", "Qty. Settled");
                if Quantity < "Qty. Received" then
                    Error('Quantity cannot be less than Qty. Received');

                if Quantity < "Qty. Settled" then
                    Error('Quantity cannot be less than Qty. Settled');

                CalculateQtyPendingSettl();
            end;
        }
        field(17; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recPCLn: Record "Purchase Contract Line";
            begin
                CheckDate();

                recPCLn.Reset();
                recPCLn.SetRange("Contract No.", "No.");
                recPCLn.SetRange("Transaction Type", recPCLn."Transaction Type"::Settlement);
                recPCLn.SetRange("Post Invoice to Pay", true);
                if recPCLn.FindSet() then begin
                    recPCLn.ModifyAll("Posting Date", "Posting Date");
                end;
            end;
        }
        field(18; "Qty. Received"; Decimal)
        {
            CalcFormula = Sum ("Posted Receipt Line".Quantity WHERE("Contract No." = FIELD("No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Quality Premium Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Commodity Settings";
        }
        field(22; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Check-off Amount"; Decimal)
        {
            CalcFormula = Sum ("Purchase Contract Line"."Check-off Amount" WHERE("Contract No." = FIELD("No."),
                                                                                 "Transaction Type" = CONST(Invoice)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Closed;
        }
        field(31; "Total Amount"; Decimal)
        {
            CalcFormula = Sum ("Purchase Contract Line"."Settlement Line Amount" WHERE("Contract No." = FIELD("No."),
                                                                                       "Transaction Type" = CONST(Settlement)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Qty. Settled"; Decimal)
        {
            CalcFormula = Sum ("Purchase Contract Line".Quantity WHERE("Contract No." = FIELD("No."),
                                                                       "Transaction Type" = CONST(Settlement)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Qty. Pending Settlement"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Calculated';
            Editable = false;
        }
        field(34; "Status Closed Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Qty. Pre-Received"; Decimal)
        {
            CalcFormula = Sum ("Purchase Contract Line"."Qty. Pre-Received" WHERE("Contract No." = FIELD("No."),
                                                                                  "Transaction Type" = CONST(Settlement)));
            Description = 'FF';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(40; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;

            trigger OnValidate()
            begin
                TestField(Status, 0);
                CalcFields("Qty. Received", "Qty. Settled");
                TestField("Qty. Received", 0);
                TestField("Qty. Settled", 0);
                UpdateBinCode();
            end;
        }
        field(41; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                            "Item No." = FIELD("Item No."),
                                                            "Unit of Measure Code" = FIELD("Purch. Unit of Measure Code"));
        }
        field(50; "Deferred Payment"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51; "Deferred Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Delivery Start Date", "Delivery End Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recPConLn: Record "Purchase Contract Line";
    begin
        recPConLn.Reset();
        recPConLn.SetRange("Contract No.", "No.");
        recPConLn.SetFilter("Recd/Settled Qty. Invoiced", '>%1', 0);
        if recPConLn.FindFirst() then begin
            Error('This Contract is already invoiced. It cannot be deleted.');
        end else begin
            recPConLn.SetRange("Recd/Settled Qty. Invoiced");
            if recPConLn.FindSet() then begin
                recPConLn.DeleteAll();
            end;
        end;

        CalcFields("Qty. Received");
        TestField("Qty. Received", 0);
    end;

    trigger OnInsert()
    var
        recRuppSetup: Record "Rupp Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recUserSetup: Record "User Setup";
    begin
        recRuppSetup.Get();
        recRuppSetup.TestField("Purchase Contract Nos");
        "No." := NoSeriesMgt.GetNextNo(recRuppSetup."Purchase Contract Nos", WorkDate, true);
        "Contract Date" := WorkDate;
        if recUserSetup.Get(UserId) then begin
            "Location Code" := recUserSetup."Default Location Code";
        end;
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';

    [Scope('Internal')]
    procedure CalculateQtyPendingSettl()
    begin
        CalcFields("Qty. Settled");
        "Qty. Pending Settlement" := Quantity - "Qty. Settled";
    end;

    [Scope('Internal')]
    procedure UpdateBinCode()
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        "Bin Code" := '';
        if ("Item No." <> '') and ("Location Code" <> '') then begin
            "Bin Code" := RuppFun.GetDefBinCode("Location Code", "Item No.", '', "Purch. Unit of Measure Code");
        end;
    end;

    [Scope('Internal')]
    procedure CheckDate()
    begin
        if "Posting Date" <> 0D then begin
            if "Delivery Start Date" <> 0D then begin
                if "Posting Date" < "Delivery Start Date" then
                    Error('Posting Date cannot be before Delivery Start Date');
            end;

            if "Delivery End Date" <> 0D then begin
                if "Posting Date" > "Delivery End Date" then
                    Error('Posting Date cannot be after Delivery End Date');
            end;
        end;
    end;
}

