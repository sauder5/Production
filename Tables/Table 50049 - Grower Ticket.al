table 50049 "Grower Ticket"
{
    // version GroProd


    fields
    {
        field(10; "Grower Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Scale Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Scale Ticket Header"."Scale Ticket No.";
        }
        field(30; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Production Lot"."Production Lot No.";
        }
        field(40; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(60; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));
        }
        field(80; "Grower Share %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Posted,Canceled,Closed';
            OptionMembers = Open,Posted,Canceled,Closed;

            trigger OnValidate();
            begin
                if Status = Status::Posted then
                    if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then
                        "Posting Date" := recScaleTkt."Posting Date";
            end;
        }
        field(100; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(110; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(120; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(150; "Gross Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Net Wgt (LB)", "Gross Wgt (LB)" - "Tare Wgt (LB)");
            end;
        }
        field(160; "Tare Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Net Wgt (LB)", "Gross Wgt (LB)" - "Tare Wgt (LB)");
            end;
        }
        field(170; "Net Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Gross Qty in Purchase UOM");
            end;
        }
        field(180; "Gross Qty in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if recProdLot.GET("Production Lot No.") then
                    "Gross Qty in Purchase UOM" := ROUND("Net Wgt (LB)" / recProdLot."Purchase UOM in LBS", 0.01);
                VALIDATE("Shrink Qty per UOM");
            end;
        }
        field(190; "Shrink Qty per UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if recScaleTkt.GET("Production Lot No.", "Scale Ticket No.") then
                    "Shrink Qty per UOM" := ROUND("Gross Qty in Purchase UOM" * (recScaleTkt."Shrink %" / 100), 0.01);
                VALIDATE("Net Qty in Purchase UOM");
            end;
        }
        field(200; "Net Qty in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Qty in Purchase UOM" := "Gross Qty in Purchase UOM" - "Shrink Qty per UOM";
                VALIDATE("Settled Quantity");
            end;
        }
        field(210; "Total Premi / Disc per UOM"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if not recProdLot.GET(Rec."Production Lot No.") then
                    CLEAR(recProdLot);
                if not recScaleTkt.GET(Rec."Production Lot No.", Rec."Scale Ticket No.") then
                    CLEAR(recScaleTkt);

                VALIDATE("Gross Qty in Purchase UOM");

                "Total Premi / Disc per UOM" := recProdLot."Commodity Premium per UOM" + recProdLot."Cropping Premium per UOM" + recProdLot."Additional Premium per UOM" +
                                              recProdLot."Out of Zone Premium per UOM" - recScaleTkt."Moisture Discount per UOM" + recScaleTkt."Splits Premium per UOM" -
                                              recScaleTkt."Test Weight Discount per UOM" - recScaleTkt."Vomitoxin Discount per UOM";
            end;
        }
        field(300; "Settled Quantity"; Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate();
            var
                recAppliedAmt: Record "Settlement Applied Amounts";
            begin
                recAppliedAmt.RESET;
                recAppliedAmt.SETFILTER("Grower Ticket No.", "Grower Ticket No.");
                recAppliedAmt.CALCSUMS("Quantity Applied");
                "Settled Quantity" := recAppliedAmt."Quantity Applied";

                VALIDATE("Remaining Quantity", "Net Qty in Purchase UOM" - "Settled Quantity");
            end;
        }
        field(320; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(330; "Transaction ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(340; "Item Journal Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(350; "Value Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(360; "Carrying Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                AccountingPeriod: Record "Accounting Period";
                FiscalDateEnd: Date;
                MonthCalc: Integer;
            begin
            end;
        }
        field(370; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

            trigger OnValidate();
            var
                recItem: Record Item;
            begin
                CLEAR(recItem);
                if recItem.GET("Item No.") then begin
                    VALIDATE("Generic Name Code", recItem."Generic Name Code");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Grower Ticket No.")
        {
        }
        key(Key2; "Vendor No.")
        {
        }
        key(Key3; "Generic Name Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recGrowerTkt: Record "Grower Ticket";
        recProdLot: Record "Production Lot";
        recScaleTkt: Record "Scale Ticket Header";
        x: Integer;

    procedure Init(ProdLot: Code[20]; ScaleTkt: Code[20]);
    var
        recProdLot: Record "Production Lot";
        recScaleTkt: Record "Scale Ticket Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recScaleTktDetail: Record "Scale Ticket Detail";
        recGrowers: Record "Production Grower";
        recVendor: Record Vendor;
    begin
        VALIDATE("Production Lot No.", ProdLot);
        VALIDATE("Scale Ticket No.", ScaleTkt);

        CLEAR(recScaleTkt);
        CLEAR(recProdLot);

        if recScaleTkt.GET(ProdLot, ScaleTkt) then;
        if recProdLot.GET(ProdLot) then;

        VALIDATE("Receipt Date", recScaleTkt."Receipt Date");
        VALIDATE("Generic Name Code", recProdLot."Generic Name Code");
        VALIDATE("Item No.", recProdLot."Item No.");

        recGrowers.SETFILTER("Production Lot No.", "Production Lot No.");
        if recGrowers.FINDSET then begin
            repeat
                "Grower Ticket No." := NoSeriesMgt.GetNextNo('R_GROWTKT', TODAY(), true);
                VALIDATE("Grower Share %", recGrowers."Grower Share");
                VALIDATE("Vendor No.", recGrowers."Vendor No.");
                VALIDATE("Total Premi / Disc per UOM");
                INSERT;
            until recGrowers.NEXT = 0;
        end;
    end;

    procedure UpdateValue(Type: Option Gross,Tare,Premium,Generic; ProdLot: Code[20]; ScaleTkt: Code[20]; Value: Decimal);
    var
        recGrowerTkt: Record "Grower Ticket";
    begin
        with recGrowerTkt do begin
            RESET;
            SETFILTER("Production Lot No.", ProdLot);
            SETFILTER("Scale Ticket No.", ScaleTkt);
            if recProdLot.GET(ProdLot) then;

            if FINDSET then begin
                repeat
                    case Type of
                        Type::Gross:
                            VALIDATE("Gross Wgt (LB)", ROUND(Value * ("Grower Share %" / 100), 0.01));
                        Type::Tare:
                            VALIDATE("Tare Wgt (LB)", ROUND(Value * ("Grower Share %" / 100), 0.01));
                        Type::Premium:
                            VALIDATE("Total Premi / Disc per UOM");
                        Type::Generic:
                            VALIDATE("Generic Name Code", recProdLot."Generic Name Code");
                    end;
                    MODIFY;
                until recGrowerTkt.NEXT = 0;
            end;
        end;
    end;

    procedure CalcCarryingCharge();
    var
        AccountingPeriod: Record "Accounting Period";
        FiscalDateEnd: Date;
        MonthCalc: Integer;
    begin
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year", true);
        AccountingPeriod."Starting Date" := "Receipt Date";
        if AccountingPeriod.FIND('>=') then
            FiscalDateEnd := CALCDATE('+1Y-1D', AccountingPeriod."Starting Date")
        else
            FiscalDateEnd := 99991231D;

        "Carrying Charge Amount" := 0;

        if TODAY > FiscalDateEnd then begin
            if Today() > FiscalDateEnd then Begin
                MonthCalc := (Today - FiscalDateEnd) / 30;
                CalcMonths(FiscalDateEnd, MonthCalc);
                "Carrying Charge Amount" := MonthCalc * "Remaining Quantity" * 0.1;
            end else
                "Carrying Charge Amount" := 0;
        end;
    end;

    procedure CalcMonths(fiscalEndDate: date; MonthCount: Integer);
    var
        lFromDate: Date;
        lToDate: Date;

    begin
        IF fiscalEndDate < Today THEN BEGIN
            lFromDate := fiscalEndDate;
            lToDate := Today;
            monthCount := 0;
            lFromDate := CALCDATE('+1M', lFromDate);
            WHILE lFromDate < lToDate DO BEGIN
                monthCount += 1;
                lFromDate := CALCDATE('+1M', lFromDate);
            END;
        end;
    end;
}

