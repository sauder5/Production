table 50048 "Scale Ticket Detail"
{
    // version GroProd


    fields
    {
        field(10; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Production Lot"."Production Lot No.";
        }
        field(20; "Scale Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Scale Ticket Header"."Scale Ticket No.";
        }
        field(30; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            var
                recVendor: Record Vendor;
            begin
                if recVendor.GET("Vendor No.") then
                    VALIDATE("Vendor Name", recVendor.Name);
            end;
        }
        field(50; "Vendor Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(60; "Farm No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Farm."Farm No.";
        }
        field(70; "Field No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Farm Field"."Farm Field No." WHERE("Farm No." = FIELD("Farm No."));
        }
        field(100; "Split Load %"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then begin
                    "Gross Wgt (LB)" := ROUND(recScaleTkt."Gross Wgt (LB)" * ("Split Load %" / 100), 0.01);
                    "Tare Wgt (LB)" := ROUND(recScaleTkt."Tare Wgt (LB)" * ("Split Load %" / 100), 0.01);
                    VALIDATE("Gross Wgt (LB)");
                end;
            end;
        }
        field(110; "Gross Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Wgt (LB)" := "Gross Wgt (LB)" - "Tare Wgt (LB)";
                VALIDATE("Net Wgt (LB)");
            end;
        }
        field(120; "Tare Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Wgt (LB)" := "Gross Wgt (LB)" - "Tare Wgt (LB)";
                VALIDATE("Net Wgt (LB)");
            end;
        }
        field(130; "Net Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if recProdLot.GET("Production Lot No.") then
                    if recProdLot."Purchase UOM in LBS" > 0 then
                        "Gross Qty In Purchase UOM" := ROUND("Net Wgt (LB)" / recProdLot."Purchase UOM in LBS", 0.01);
                VALIDATE("Gross Qty In Purchase UOM");
            end;
        }
        field(150; "Gross Qty In Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate();
            begin
                if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then
                    VALIDATE("Shrink Qty", ROUND("Gross Qty In Purchase UOM" * (recScaleTkt."Shrink %" / 100), 0.01));
                VALIDATE("Net Qty In UOM");
            end;
        }
        field(220; "Shrink Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(290; "Net Qty In UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Qty In UOM" := "Gross Qty In Purchase UOM" - "Shrink Qty";
            end;
        }
        field(330; "Total Prem/Disc Per UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if not recProdLot.GET(Rec."Production Lot No.") then
                    CLEAR(recProdLot);
                if not recScaleTkt.GET(Rec."Production Lot No.", Rec."Scale Ticket No.") then
                    CLEAR(recScaleTkt);

                VALIDATE("Gross Wgt (LB)");

                "Total Prem/Disc Per UOM" := recProdLot."Commodity Premium per UOM" - recScaleTkt."Moisture Discount per UOM" + recScaleTkt."Splits Premium per UOM"
                    - recScaleTkt."Test Weight Discount per UOM" - recScaleTkt."Vomitoxin Discount per UOM";
            end;
        }
    }

    keys
    {
        key(Key1; "Production Lot No.", "Scale Ticket No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Init("Production Lot No.", "Scale Ticket No.");
    end;

    var
        recTicketDetail: Record "Scale Ticket Detail";
        LineNum: Integer;
        recProdLot: Record "Production Lot";
        recScaleTkt: Record "Scale Ticket Header";
        opTestType: Option " ",Splits,Moisture,"Test Weight",Vomitoxin;
        RcptManage: Codeunit "Receipt Management";
        pLot: Code[20];
        sTkt: Code[20];

    procedure Init(ProdLot: Code[20]; ScaleTkt: Code[20]);
    var
        RemainingSplit: Decimal;
    begin

        VALIDATE("Production Lot No.", ProdLot);
        VALIDATE("Scale Ticket No.", ScaleTkt);

        with recTicketDetail do begin
            SETFILTER("Production Lot No.", Rec."Production Lot No.");
            SETFILTER("Scale Ticket No.", Rec."Scale Ticket No.");

            CALCSUMS("Split Load %");
            RemainingSplit := 100 - "Split Load %";

            if FINDLAST then
                LineNum := "Line No." + 10
            else
                LineNum := 10;
        end;
        VALIDATE("Line No.", LineNum);
        VALIDATE("Split Load %", RemainingSplit);

        if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then begin
            VALIDATE("Gross Wgt (LB)", ROUND(recScaleTkt."Gross Wgt (LB)" * ("Split Load %" / 100), 0.01));
            VALIDATE("Tare Wgt (LB)", ROUND(recScaleTkt."Tare Wgt (LB)" * ("Split Load %" / 100), 0.01));
        end;

        if recProdLot.GET("Production Lot No.") then begin
            VALIDATE("Vendor No.", recProdLot."Vendor Number");
            VALIDATE("Farm No.", recProdLot."Farm No.");
            VALIDATE("Field No.", recProdLot."Farm Field No.");
        end;

        VALIDATE("Total Prem/Disc Per UOM");
        INSERT;
    end;

    procedure UpdateValue(Type: Option Gross,Tare,Premium; ProdLot: Code[20]; ScaleTkt: Code[20]; Value: Decimal);
    var
        recScaleDetail: Record "Scale Ticket Detail";
    begin
        with recScaleDetail do begin
            RESET;
            SETFILTER("Production Lot No.", ProdLot);
            SETFILTER("Scale Ticket No.", ScaleTkt);
            if FINDSET then begin
                repeat
                    case Type of
                        Type::Gross:
                            VALIDATE("Gross Wgt (LB)", ROUND(Value * ("Split Load %" / 100), 0.01));
                        Type::Tare:
                            VALIDATE("Tare Wgt (LB)", ROUND(Value * ("Split Load %" / 100), 0.01));
                        Type::Premium:
                            VALIDATE("Total Prem/Disc Per UOM");
                    end;
                    MODIFY;
                until recScaleDetail.NEXT = 0;
            end;
        end;
    end;
}

