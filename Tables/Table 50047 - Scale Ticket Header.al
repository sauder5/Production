table 50047 "Scale Ticket Header"
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
        field(50; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                with recTicketDetail do begin
                    SETFILTER("Production Lot No.", "Production Lot No.");
                    SETFILTER("Scale Ticket No.", "Scale Ticket No.");
                    SETFILTER("Vendor No.", '');
                    if FINDSET then
                        MODIFYALL("Vendor No.", "Vendor No.");
                end;
            end;
        }
        field(60; "Farm No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Farm."Farm No.";

            trigger OnValidate();
            begin
                with recTicketDetail do begin
                    SETFILTER("Production Lot No.", "Production Lot No.");
                    SETFILTER("Scale Ticket No.", "Scale Ticket No.");
                    SETFILTER("Farm No.", '');
                    if FINDSET then
                        MODIFYALL("Farm No.", "Farm No.");
                end;
            end;
        }
        field(70; "Field No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Farm Field"."Farm Field No." WHERE("Farm No." = FIELD("Farm No."));

            trigger OnValidate();
            begin
                with recTicketDetail do begin
                    SETFILTER("Production Lot No.", "Production Lot No.");
                    SETFILTER("Scale Ticket No.", "Scale Ticket No.");
                    SETFILTER("Field No.", '');
                    if FINDSET then
                        MODIFYALL("Field No.", "Field No.");
                end;
            end;
        }
        field(80; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Paper Scale Ticket No."; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(100; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(110; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(120; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Posted,Canceled,Closed';
            OptionMembers = Open,Posted,Canceled,Closed;
        }
        field(130; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(140; "Gross Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Wgt (LB)" := "Gross Wgt (LB)" - "Tare Wgt (LB)";
                recTicketDetail.UpdateValue(UpdType::Gross, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                recGrowerTkt.UpdateValue(UpdType::Gross, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
            end;
        }
        field(150; "Tare Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Net Wgt (LB)" := "Gross Wgt (LB)" - "Tare Wgt (LB)";
                recTicketDetail.UpdateValue(UpdType::Tare, "Production Lot No.", "Scale Ticket No.", "Tare Wgt (LB)");
                recGrowerTkt.UpdateValue(UpdType::Tare, "Production Lot No.", "Scale Ticket No.", "Tare Wgt (LB)");
            end;
        }
        field(160; "Net Wgt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(170; "Moisture Test Result"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if recProdLot.GET("Production Lot No.") then
                    with recProdLot do begin
                        "Shrink %" := RcptManage.GetPremDiscAmtFromTest("Commodity  Code", Type::Moisture, "Moisture Test Result");
                        Rec.MODIFY;
                        recTicketDetail.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                        recGrowerTkt.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                    end;
            end;
        }
        field(180; "Moisture Discount per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(200; "Shrink %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(210; "Splits Test Result"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status <> Status::Posted then
                    if recProdLot.GET("Production Lot No.") then
                        with recProdLot do begin
                            "Splits Premium per UOM" := RcptManage.GetPremDiscAmtFromTest("Commodity  Code", Type::Splits, "Splits Test Result");
                            Rec.MODIFY;
                            recTicketDetail.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                            recGrowerTkt.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                        end;
            end;
        }
        field(220; "Splits Premium per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(230; "Test Weight Result"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status <> Status::Posted then
                    if recProdLot.GET("Production Lot No.") then
                        with recProdLot do begin
                            "Test Weight Discount per UOM" := RcptManage.GetPremDiscAmtFromTest("Commodity  Code", Type::"Test Weight", "Test Weight Result");
                            Rec.MODIFY;
                            recTicketDetail.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                            recGrowerTkt.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                        end;
            end;
        }
        field(240; "Test Weight Discount per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(250; "Vomitoxin Test Result"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status <> Status::Posted then
                    if recProdLot.GET("Production Lot No.") then
                        with recProdLot do begin
                            "Vomitoxin Discount per UOM" := RcptManage.GetPremDiscAmtFromTest("Commodity  Code", Type::Vomitoxin, "Vomitoxin Test Result");
                            Rec.MODIFY;
                            recTicketDetail.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                            recGrowerTkt.UpdateValue(UpdType::Premium, "Production Lot No.", "Scale Ticket No.", "Gross Wgt (LB)");
                        end;
            end;
        }
        field(260; "Vomitoxin Discount per UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(270; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Production Lot No.", "Scale Ticket No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if Status = Status::Posted then
            ERROR('Scale ticket has been posted and cannot be deleted')
        else begin
            recGrowerTkt.SETFILTER("Production Lot No.", Rec."Production Lot No.");
            recGrowerTkt.SETFILTER("Scale Ticket No.", Rec."Scale Ticket No.");
            recGrowerTkt.DELETEALL;

            recTicketDetail.SETFILTER("Production Lot No.", Rec."Production Lot No.");
            recTicketDetail.SETFILTER("Scale Ticket No.", Rec."Scale Ticket No.");
            recTicketDetail.DELETEALL;
        end;
    end;

    trigger OnModify();
    var
        recGrowerTkt: Record "Grower Ticket";
    begin
        if Rec.Status <> xRec.Status then begin
            recGrowerTkt.SETFILTER("Production Lot No.", Rec."Production Lot No.");
            recGrowerTkt.SETFILTER("Scale Ticket No.", Rec."Scale Ticket No.");
            recGrowerTkt.SETFILTER(Status, '%1', recGrowerTkt.Status::Open);
            recGrowerTkt.MODIFYALL(Status, xRec.Status);
        end;
    end;

    var
        recTicketDetail: Record "Scale Ticket Detail";
        recGrowerTkt: Record "Grower Ticket";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Type: Option " ",Splits,Moisture,"Test Weight",Vomitoxin;
        UpdType: Option Gross,Tare,Premium;
        RcptManage: Codeunit "Receipt Management";
        recProdLot: Record "Production Lot";

    procedure Init(ProdLot: Code[20]; var recScaleTkt: Record "Scale Ticket Header");
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recScaleDtl: Record "Scale Ticket Detail";
        recGrowerTkt: Record "Grower Ticket";
    begin
        if not recProdLot.GET(ProdLot) then
            CLEAR(recProdLot);
        with recScaleTkt do begin
            RESET;
            "Production Lot No." := ProdLot;
            "Scale Ticket No." := NoSeriesMgt.GetNextNo('R_SCALETKT', TODAY(), true);
            "Vendor No." := recProdLot."Vendor Number";
            VALIDATE("Receipt Date", TODAY());
            INSERT;
            Validate("Moisture Test Result");
            Validate("Splits Test Result");
            Validate("Test Weight Result");
            Validate("Vomitoxin Test Result");
            recScaleDtl.Init("Production Lot No.", "Scale Ticket No.");
            recGrowerTkt.Init("Production Lot No.", "Scale Ticket No.");
        end;
    end;
}

