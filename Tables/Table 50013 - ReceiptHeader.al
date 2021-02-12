table 50013 "Receipt Header"
{
    // //SOC-SC 08-06-15
    //   Added field:
    //     36; Vomitoxin Test Result; Decimal

    DrillDownPageID = Receipts;
    LookupPageID = Receipts;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateRcptDateInLines();
            end;
        }
        field(11; "Primary Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(12; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Open,Processed;
        }
        field(13; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;

            trigger OnValidate()
            var
                recRcptLn: Record "Receipt Line";
                recBinContent: Record "Bin Content";
            begin
                if Status = Status::Processed then
                    Error('Cannot change Location Code since it has already been processed');
                UpdateBinCode();

                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "No.");
                if recRcptLn.FindSet() then begin
                    recRcptLn.ModifyAll("Location Code", "Location Code");
                    recRcptLn.ModifyAll("Bin Code", "Bin Code");
                end;
            end;
        }
        field(14; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnValidate()
            var
                recRcptLn: Record "Receipt Line";
            begin
                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "No.");
                if recRcptLn.FindSet() then begin
                    recRcptLn.ModifyAll("Bin Code", "Bin Code");
                end;
            end;
        }
        field(15; "Primary Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Primary Vendor No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;

            trigger OnValidate()
            var
                recItem: Record Item;
                recItemUOM: Record "Item Unit of Measure";
                recRuppSetup: Record "Rupp Setup";
                ContractMgt: Codeunit "Purchase Contract Checkoff Mgt";
                dGrossWt: Decimal;
                dNetWt: Decimal;
                CongratctMgt: Codeunit "Purchase Contract Checkoff Mgt";
            begin
                "Purch. Unit of Measure Code" := '';
                "Lbs per Purch. Unit of Measure" := 0;
                "Quality Premium Code" := '';
                "Check-off %" := 0;
                "Item Description" := '';
                ContractMgt.GetItemWt("Item No.", dGrossWt, dNetWt);

                if recItem.Get("Item No.") then begin
                    //recItem.TESTFIELD("Item Tracking Code", '');
                    recItem.TestField("Purch. Unit of Measure");
                    recItem.TestField("Quality Premium Code");
                    "Purch. Unit of Measure Code" := recItem."Purch. Unit of Measure";

                    recItemUOM.Get("Item No.", recItem."Base Unit of Measure");

                    if recItemUOM.Get("Item No.", recItem."Purch. Unit of Measure") then begin
                        if recRuppSetup.Get() then begin
                            if recRuppSetup."Item Wt for Receiving" = recRuppSetup."Item Wt for Receiving"::"Gross Wt" then begin
                                "Lbs per Purch. Unit of Measure" := Round(dGrossWt / recItemUOM."Qty. per Unit of Measure", 0.00001);
                            end else begin
                                "Lbs per Purch. Unit of Measure" := Round(dNetWt / recItemUOM."Qty. per Unit of Measure", 0.00001);
                            end;
                        end;
                    end;

                    "Quality Premium Code" := recItem."Quality Premium Code";
                    "Check-off %" := recItem."Checkoff %";
                    "Item Description" := recItem.Description;
                end;

                "Tare Wt (LB)" := 0;
                Validate("Gross Wt (LB)", 0);
                UpdateBinCode();
            end;
        }
        field(21; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(24; "Scale Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Gross Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateQuantity();
            end;
        }
        field(26; "Tare Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateQuantity();
            end;
        }
        field(27; "Net Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(29; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Moisture Test Result"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcShrink();
            end;
        }
        field(31; "Splits Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Test Weight Result"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Quality Premium Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Commodity Settings";
        }
        field(34; "Shrink %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                UpdateNetQtyInPurchUOM();
            end;
        }
        field(35; "Shrink Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(36; "Vomitoxin Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'SOC';
            MaxValue = 99;
            MinValue = 0;
        }
        field(37; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recRcptLn: Record "Receipt Line";
            begin
                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "No.");
                if recRcptLn.FindSet() then begin
                    recRcptLn.ModifyAll("Check-off %", "Check-off %");
                end;
            end;
        }
        field(38; "Unit Premium/Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; Farm; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(41; "Farm Field"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Lbs per Purch. Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51; "Gross Quantity in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52; "Net Quantity in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recItem: Record Item;
                recRcptLn: Record "Receipt Line";
            begin
                recItem.Get("Item No.");
                recItem.TestField("Item Tracking Code");

                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "No.");
                if recRcptLn.FindSet() then begin
                    recRcptLn.ModifyAll("Lot No.", "Lot No.");
                end;
            end;
        }
        field(70; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Contract Header"."No." WHERE("Vendor No." = FIELD("Primary Vendor No."),
                                                                    "Item No." = FIELD("Item No."),
                                                                    Status = FILTER(Open));

            trigger OnValidate()
            var
                recRcptLn: Record "Receipt Line";
                recContractHdr: Record "Purchase Contract Header";
            begin
                recContractHdr.Get("Contract No.");
                if recContractHdr."Delivery Start Date" <> 0D then begin
                    if recContractHdr."Delivery Start Date" > "Receipt Date" then
                        Error('The contract''s Delivery Start Date %1 is after the Receipt Date', recContractHdr."Delivery Start Date");
                end;

                if recContractHdr."Delivery End Date" <> 0D then begin
                    if recContractHdr."Delivery End Date" < "Receipt Date" then
                        Error('The contract''s Delivery End Date %1 is before the Receipt Date', recContractHdr."Delivery End Date");
                end;

                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "No.");
                recRcptLn.SetRange("Vendor No.", "Primary Vendor No.");
                if recRcptLn.FindSet() then begin
                    recRcptLn.ModifyAll("Contract No.", "Contract No.");
                end;
            end;
        }
        field(80; "Splits Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(81; "Test Weight Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(82; "Vomitoxin Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(83; "Seed Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recRcptLn: Record "Receipt Line";
    begin
        if Status = Status::Processed then
            Error('Cannot delete Receipt as it is already processed.');

        recRcptLn.Reset();
        recRcptLn.SetRange("Receipt No.", "No.");
        if recRcptLn.FindSet() then begin
            recRcptLn.DeleteAll();
        end;
    end;

    trigger OnInsert()
    var
        recRuppSetup: Record "Rupp Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recUserSetup: Record "User Setup";
    begin
        recRuppSetup.Get();
        recRuppSetup.TestField(recRuppSetup."Receipt Nos");
        "No." := NoSeriesMgt.GetNextNo(recRuppSetup."Receipt Nos", WorkDate, true);
        "Receipt Date" := WorkDate;

        if recUserSetup.Get(UserId) then begin
            Validate("Location Code", recUserSetup."Default Location Code");
        end;
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';

    [Scope('Internal')]
    procedure UpdateQuantity()
    begin
        if "Gross Wt (LB)" < "Tare Wt (LB)" then
            Error('Gross Wt cannot be greater than Tare Wt');

        "Net Wt (LB)" := "Gross Wt (LB)" - "Tare Wt (LB)";
        //Quantity := ROUND("Net Wt (LB)" / 2000, 0.01);

        if "Lbs per Purch. Unit of Measure" > 0 then begin
            "Gross Quantity in Purchase UOM" := Round("Net Wt (LB)" / "Lbs per Purch. Unit of Measure", 0.00001);
        end else begin
            "Gross Quantity in Purchase UOM" := 0;
        end;

        UpdateNetQtyInPurchUOM();
    end;

    [Scope('Internal')]
    procedure CalcShrink()
    var
        recQltyPremLn: Record "Commodity Settings Line";
    begin
        recQltyPremLn.Reset();
        recQltyPremLn.SetRange("Quality Premium Code", "Quality Premium Code");
        recQltyPremLn.SetRange("Test Type", recQltyPremLn."Test Type"::Moisture);
        recQltyPremLn.SetFilter("From Result", '<=%1', "Moisture Test Result");
        recQltyPremLn.SetFilter("To Result", '>=%1', "Moisture Test Result");
        if recQltyPremLn.FindFirst() then begin
            Validate("Shrink %", recQltyPremLn."Shrink %");
        end else begin
            Validate("Shrink %", 0);
        end;
    end;

    [Scope('Internal')]
    procedure UpdateLines()
    var
        recRcptLn: Record "Receipt Line";
        dLineQty: Decimal;
        dTotalQty: Decimal;
    begin
        recRcptLn.Reset();
        recRcptLn.SetRange("Receipt No.", "No.");
        //IF "Net Qty. in Common UOM" > 0 THEN BEGIN
        if "Net Quantity in Purchase UOM" > 0 then begin
            if recRcptLn.FindSet() then begin
                recRcptLn.CalcSums("Ratio %");
                if recRcptLn."Ratio %" <> 100 then
                    Error('Total Ratio % from all lines must be 100');

                recRcptLn.SetRange("Ratio %", 0);
                if recRcptLn.FindFirst() then
                    Error('There cannot be a line with zero Ratio %');

                recRcptLn.SetRange("Ratio %");

                recRcptLn.FindSet();
                dTotalQty := 0;
                repeat
                    CheckContractNo(recRcptLn);
                    dLineQty := Round("Net Quantity in Purchase UOM" * recRcptLn."Ratio %" / 100, 0.01, '=');
                    recRcptLn.Quantity := dLineQty;
                    recRcptLn."Gross Qty." := Round("Gross Quantity in Purchase UOM" * recRcptLn."Ratio %" / 100, 0.01, '=');
                    recRcptLn."Shrink Qty." := Round("Shrink Qty." * recRcptLn."Ratio %" / 100, 0.01, '=');
                    recRcptLn.Modify();
                    dTotalQty += dLineQty;
                until recRcptLn.Next = 0;
                recRcptLn.FindLast();
                dLineQty += "Net Quantity in Purchase UOM" - dTotalQty;
                recRcptLn.Quantity := Round(dLineQty, 0.01);
                recRcptLn.Modify();

            end else begin
                //InsertRcptLn();
                recRcptLn.Init();
                recRcptLn."Receipt No." := "No.";
                recRcptLn."Line No." := 10000;
                recRcptLn."Location Code" := "Location Code";
                recRcptLn."Bin Code" := "Bin Code";
                recRcptLn."Item No." := "Item No.";
                recRcptLn."Purch. Unit of Measure Code" := "Purch. Unit of Measure Code";
                recRcptLn."Receipt Date" := "Receipt Date";
                recRcptLn.Quantity := "Net Quantity in Purchase UOM";
                recRcptLn."Gross Qty." := "Gross Quantity in Purchase UOM";
                recRcptLn."Shrink Qty." := "Shrink Qty.";
                recRcptLn."Vendor No." := "Primary Vendor No.";
                recRcptLn."Ticket No." := "Scale Ticket No.";
                recRcptLn."Ratio %" := 100;
                recRcptLn."Quality Premium Code" := "Quality Premium Code";
                recRcptLn."Check-off %" := "Check-off %";
                recRcptLn."Lot No." := "Lot No.";
                recRcptLn."Contract No." := "Contract No.";
                recRcptLn.Insert();
            end;
        end else begin
            if recRcptLn.FindSet() then begin
                recRcptLn.ModifyAll(Quantity, 0);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateBinCode()
    var
        RuppFun: Codeunit "Rupp Functions";
    begin
        if "Bin Code" = '' then begin
            if ("Item No." <> '') and ("Location Code" <> '') then begin
                "Bin Code" := RuppFun.GetDefBinCode("Location Code", "Item No.", '', "Purch. Unit of Measure Code");
            end;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateNetQtyInPurchUOM()
    begin
        "Shrink Qty." := Round("Shrink %" * "Gross Quantity in Purchase UOM" / 100, 0.00001);
        "Net Quantity in Purchase UOM" := "Gross Quantity in Purchase UOM" - "Shrink Qty.";

        UpdateLines();
    end;

    [Scope('Internal')]
    procedure UpdateRcptDateInLines()
    var
        recRcptLn: Record "Receipt Line";
    begin
        recRcptLn.Reset();
        recRcptLn.SetRange("Receipt No.", "No.");
        if recRcptLn.FindSet() then begin
            recRcptLn.ModifyAll("Receipt Date", "Receipt Date");
        end;
    end;

    [Scope('Internal')]
    procedure CheckContractNo(RcptLn: Record "Receipt Line")
    var
        recContract: Record "Purchase Contract Header";
    begin
        recContract.Get(RcptLn."Contract No.");
        if RcptLn."Vendor No." <> recContract."Vendor No." then
            Error('Please check Vendor No. on the lines');
    end;
}

