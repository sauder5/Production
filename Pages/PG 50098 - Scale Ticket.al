page 50098 "Scale Ticket"
{
    // version GroProd

    PageType = Card;
    SourceTable = "Scale Ticket Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = IsEditable;
                field("Scale Ticket No."; "Scale Ticket No.")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Paper Scale Ticket No."; "Paper Scale Ticket No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                    TableRelation = Location.Code;

                    trigger OnValidate();
                    begin
                        recGrowerTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                        recGrowerTkt.SETFILTER("Scale Ticket No.", "Scale Ticket No.");
                        recGrowerTkt.MODIFYALL("Location Code", "Location Code");
                    end;
                }
                field("Bin Code"; "Bin Code")
                {
                    TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));

                    trigger OnValidate();
                    begin
                        recGrowerTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                        recGrowerTkt.SETFILTER("Scale Ticket No.", "Scale Ticket No.");
                        recGrowerTkt.MODIFYALL("Bin Code", "Bin Code");
                    end;
                }
                field(Status; Status)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Gross Wgt (LB)"; "Gross Wgt (LB)")
                {

                    trigger OnValidate();
                    var
                        PageSplit: Page "Split Load";
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Tare Wgt (LB)"; "Tare Wgt (LB)")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Net Wgt (LB)"; "Net Wgt (LB)")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Moisture Test Result"; "Moisture Test Result")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Splits Test Result"; "Splits Test Result")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Test Weight Result"; "Test Weight Result")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Vomitoxin Test Result"; "Vomitoxin Test Result")
                {

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
            }
            part(SplitLoad; "Split Load")
            {
                Editable = IsEditable;
                SubPageLink = "Production Lot No." = FIELD("Production Lot No."),
                              "Scale Ticket No." = FIELD("Scale Ticket No.");
                UpdatePropagation = Both;
            }
            part(Control1000000007; "Grower Tickets")
            {
                Editable = IsEditable;
                SubPageLink = "Production Lot No." = FIELD("Production Lot No."),
                              "Scale Ticket No." = FIELD("Scale Ticket No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Scale Ticket")
            {
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsEditable;

                trigger OnAction();
                begin
                    if RctManage.CheckScaleTkt("Production Lot No.", "Scale Ticket No.") then begin
                        RctManage.PostScaleTkt("Production Lot No.", "Scale Ticket No.");
                        CurrPage.CLOSE;
                    end;
                end;
            }
            action("UnPost Scale Ticket")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = NOT IsEditable;

                trigger OnAction();
                begin
                    RctManage.UnPostScaleTkt(Rec);

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        if Status <> Status::Open then
            IsEditable := false
        else
            IsEditable := true;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recScaleTktDetail: Record "Scale Ticket Detail";
        recGrowerTkt: Record "Grower Ticket";
        IsEditable: Boolean;
        RctManage: Codeunit "Receipt Management";
}

