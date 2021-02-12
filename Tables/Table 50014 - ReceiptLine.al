table 50014 "Receipt Line"
{
    DrillDownPageID = "Receipt Lines";
    LookupPageID = "Receipt Lines";

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Receipt Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item;

            trigger OnValidate()
            begin
                //UpdateBinCode();
            end;
        }
        field(12; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            var
                recRcptLn: Record "Receipt Line";
            begin
                recRcptLn.Reset();
                recRcptLn.SetRange("Receipt No.", "Receipt No.");
                recRcptLn.SetRange("Vendor No.", "Vendor No.");
                recRcptLn.SetFilter("Line No.", '<>%1', "Line No.");
                if recRcptLn.FindFirst() then
                    Error('You cannot have the same vendor on different lines');
            end;
        }
        field(14; "Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Ratio %"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                //IF (("Ratio %" *100) MOD 100) > 0 THEN
                //  ERROR('Please enter a whole number (with no decimals)');
            end;
        }
        field(16; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                UpdateBinCode();
            end;
        }
        field(18; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(19; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(20; Received; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Purchase Doc Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(31; "Purchase Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Purchase Doc Type"));
        }
        field(32; "Purchase Doc Line No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FIELD("Purchase Doc Type"),
                                                              "Document No." = FIELD("Purchase Doc No."));
        }
        field(33; "Quality Premium Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Commodity Settings";
        }
        field(34; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Unit Premium/Discount"; Decimal)
        {
            CalcFormula = Lookup ("Receipt Header"."Unit Premium/Discount" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Gross Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(41; "Shrink Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recItem: Record Item;
            begin
                recItem.Get("Item No.");
                recItem.TestField("Item Tracking Code");
            end;
        }
        field(70; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Contract Header"."No." WHERE("Vendor No." = FIELD("Vendor No."),
                                                                    "Item No." = FIELD("Item No."),
                                                                    Status = FILTER(Open));
        }
    }

    keys
    {
        key(Key1; "Receipt No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Ratio %";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Received, false);
    end;

    trigger OnInsert()
    var
        recRcptHdr: Record "Receipt Header";
    begin
        recRcptHdr.Get("Receipt No.");
        "Item No." := recRcptHdr."Item No.";
        "Receipt Date" := recRcptHdr."Receipt Date";
        "Location Code" := recRcptHdr."Location Code";
        "Bin Code" := recRcptHdr."Bin Code";
        "Quality Premium Code" := recRcptHdr."Quality Premium Code";
        "Check-off %" := recRcptHdr."Check-off %";
        "Purch. Unit of Measure Code" := recRcptHdr."Purch. Unit of Measure Code";
        "Lot No." := recRcptHdr."Lot No.";
        "Ticket No." := recRcptHdr."Scale Ticket No.";
        "Contract No." := recRcptHdr."Contract No.";
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';

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
}

