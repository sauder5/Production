page 50111 "Production Lot List"
{
    // version GroProd

    CardPageID = "Production Lot";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Tickets,View';
    SourceTable = "Production Lot";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production Lot No."; "Production Lot No.")
                {
                }
                field("Vendor Number"; "Vendor Number")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Farm No."; "Farm No.")
                {
                }
                field("Farm Name"; "Farm Name")
                {
                }
                field("Farm Field No."; "Farm Field No.")
                {
                }
                field("Field Name"; "Field Name")
                {
                }
                field("Farm Field Acreage"; "Farm Field Acreage")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field("Estimated Qty"; "Estimated Qty")
                {
                }
                field("Purchase UOM"; "Purchase UOM")
                {
                }
                field("Prod. Lot Entry Date"; "Prod. Lot Entry Date")
                {
                }
                field("First Receipt Date"; "First Receipt Date")
                {
                }
                field("Last Receipt Date"; "Last Receipt Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("All Scale Tickets")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction();
                begin
                    recScaleTkt.RESET;
                    recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                    pageScaleTkts.SETTABLEVIEW(recScaleTkt);
                    pageScaleTkts.RUN;
                end;
            }
            action("Open Scale Tickets")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction();
                begin
                    recScaleTkt.RESET;
                    recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                    recScaleTkt.SETFILTER(Status, '%1', recScaleTkt.Status::Open);
                    pageScaleTkts.SETTABLEVIEW(recScaleTkt);
                    pageScaleTkts.RUN;
                end;
            }
            action("Posted Scale Tickets")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction();
                begin
                    recScaleTkt.RESET;
                    recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                    recScaleTkt.SETFILTER(Status, '%1', recScaleTkt.Status::Posted);
                    pageScaleTkts.SETTABLEVIEW(recScaleTkt);
                    pageScaleTkts.RUN;
                end;
            }
            action("Grower Ticket List")
            {
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction();
                var
                    recVendor: Record Vendor;
                    pageGrowerTck: Page "Grower Ticket List";
                begin

                    PAGE.RUN(50083);
                end;
            }
        }
        area(creation)
        {
            action("Create Scale Ticket")
            {
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction();
                var
                    recScaleTicket: Record "Scale Ticket Header";
                    pageScaleTkt: Page "Scale Ticket";
                begin
                    recScaleTicket.Init("Production Lot No.", recScaleTicket);
                    pageScaleTkt.SETRECORD(recScaleTicket);
                    pageScaleTkt.RUN;
                end;
            }
            action("Create Settlement")
            {
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    recSettlement: Record "Settlement-Prepayment Ticket";
                    pageSettlement: Page "Grower Settlement";
                begin
                    recSettlement.Init("Production Lot No.");
                    pageSettlement.SETRECORD(recSettlement);
                    pageSettlement.RUN;
                end;
            }
        }
        area(reporting)
        {
            action("Certification Report")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction();
                var
                    rptCertification: Report "Certification Report";
                    recProdLot: Record "Production Lot";
                begin
                    recProdLot.SETFILTER("Production Lot No.", "Production Lot No.");
                    REPORT.RUN(50064, true, false, recProdLot);
                end;
            }
            action("Settlement Report")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction();
                var
                    rptCertification: Report "Certification Report";
                    recProdLot: Record "Production Lot";
                begin
                    //recProdLot.SETFILTER("Production Lot No.", "Production Lot No.");

                    recProdLot.SETFILTER("Production Lot No.", "Production Lot No.");
                    REPORT.RUN(50065, true, false, recProdLot);
                end;
            }
        }
    }

    var
        pageScaleTkts: Page "Scale Ticket List";
        recScaleTkt: Record "Scale Ticket Header";
}

