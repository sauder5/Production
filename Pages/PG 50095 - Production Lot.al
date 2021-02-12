page 50095 "Production Lot"
{
    // version GroProd

    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Tickets,View';
    SourceTable = "Production Lot";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Control1000000043)
                {
                    Editable = IsEditable;
                    caption = '';
                    field("Production Lot No."; "Production Lot No.")
                    {
                    }
                    field("Production Year"; "Production Year")
                    {
                        MinValue = 2015;
                        MaxValue = 2040;
                    }
                    field("Vendor Number"; "Vendor Number")
                    {
                        TableRelation = Vendor."No.";
                    }
                    field("Vendor Name"; "Vendor Name")
                    {
                        Editable = false;
                    }
                    field("Farm No."; "Farm No.")
                    {
                        Lookup = true;
                        LookupPageID = "Farm List";
                        TableRelation = Farm."Farm No.";
                    }
                    field("Farm Name"; "Farm Name")
                    {
                        Editable = false;
                    }
                    field("Farm Field No."; "Farm Field No.")
                    {
                        Lookup = true;
                        LookupPageID = "Farm Field List";
                        TableRelation = "Farm Field"."Farm Field No." WHERE("Farm No." = FIELD("Farm No."));
                    }
                    field("Field Name"; "Field Name")
                    {
                        Editable = false;
                    }
                    field("Farm Field Acreage"; "Farm Field Acreage")
                    {
                        Editable = false;
                    }
                    field("Item No."; "Item No.")
                    {
                        TableRelation = Item."No.";
                    }
                    field("Item Description"; "Item Description")
                    {
                        Editable = false;
                    }
                    field("Generic Name Code"; "Generic Name Code")
                    {
                        Editable = false;
                    }
                    field("Estimated Qty"; "Estimated Qty")
                    {
                        Editable = false;
                    }
                    field("Purchase UOM"; "Purchase UOM")
                    {
                        Editable = false;
                    }
                    field("Purchase UOM in LBS"; "Purchase UOM in LBS")
                    {
                        Caption = 'Purchase UOM in LBS';
                    }
                    field("Prod. Lot Entry Date"; "Prod. Lot Entry Date")
                    {
                        Editable = false;
                    }
                    field("First Receipt Date"; "First Receipt Date")
                    {
                        Editable = false;
                    }
                    field("Last Receipt Date"; "Last Receipt Date")
                    {
                        Editable = false;
                    }
                    field("Commodity  Code"; "Commodity  Code")
                    {
                        Editable = false;
                    }
                    field("Commodity Premium per UOM"; "Commodity Premium per UOM")
                    {
                        Editable = false;
                    }
                    field("Comm. Annual Prem. Per UOM"; "Comm. Annual Prem. Per UOM")
                    {
                    }
                }
                group(Control1000000050)
                {
                    Editable = IsEditable;
                    Caption = '';
                    field("Cropping Practice Code"; "Cropping Practice Code")
                    {
                    }
                    field("Cropping Premium per UOM"; "Cropping Premium per UOM")
                    {
                        Editable = false;
                    }
                    field("Additional Premium per UOM"; "Additional Premium per UOM")
                    {
                    }
                    field("Add. Annual Prem. per UOM"; "Add. Annual Prem. per UOM")
                    {
                    }
                    field("Out of Zone Premium per UOM"; "Out of Zone Premium per UOM")
                    {
                    }
                    field("Check off %"; "Check off %")
                    {
                        Editable = false;
                    }
                    field("Quantity Received"; "Quantity Received")
                    {
                        DrillDown = true;
                        DrillDownPageID = "Grower Tickets";
                        Editable = false;
                    }
                    field("Quantity Settled"; "Quantity Settled")
                    {
                        Editable = false;
                    }
                    field("Amount Settled"; "Amount Settled")
                    {
                        Editable = false;
                    }
                    field("Quantity Pending Settlement"; "Quantity Pending Settlement")
                    {
                        Editable = false;
                    }
                    field("Acres Planted"; "Acres Planted")
                    {
                    }
                    field("Seed Lot # Planted"; "Seed Lot # Planted")
                    {
                    }
                    field("Date of Planting"; "Date of Planting")
                    {
                    }
                    field("Row Spacing"; "Row Spacing")
                    {
                        OptionCaption = '" ,6"" to 13"",14"" or Greater,Broadcast"';
                    }
                    field("Previous Crop"; "Previous Crop")
                    {
                    }
                    field("If same crop, what Variety"; "If same crop, what Variety")
                    {
                    }
                    field(Class; Class)
                    {
                        OptionCaption = '" ,Certified,Identity Preserved,Info Only,Foundation,Noxious Weed Free,Quality Assurance,Registered,Source Identified"';
                    }
                }
                group(Control1000000042)
                {
                    caption = '';
                    field("Application #"; "Application #")
                    {
                    }
                    field(Status; Status)
                    {
                        OptionCaption = 'Open,Closed,Canceled';

                        trigger OnValidate();
                        var
                            recGrowerTkt: Record "Grower Ticket";
                            recScaleTkt: Record "Scale Ticket Header";
                        begin
                            if Status = Status::Closed then begin
                                recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
                                recScaleTkt.SETFILTER(Status, '%1', recScaleTkt.Status::Open);
                                recScaleTkt.MODIFYALL(Status, recScaleTkt.Status::Closed);
                                IsEditable := false
                            end else
                                IsEditable := true;
                        end;
                    }
                    field("Closed Date"; "Closed Date")
                    {
                        Editable = false;
                    }
                }
            }
            part(Control1000000040; Growers)
            {
                Editable = IsEditable;
                SubPageLink = "Production Lot No." = FIELD("Production Lot No.");
            }
            /*            part(Control1000000054; "Settlement List")
                        {
                            SubPageLink = "Production Lot No." = FIELD ("Production Lot No.");
                        }*/
        }
        area(factboxes)
        {
            systempart(Control1000000057; Notes)
            {
            }
        }
    }

    actions
    {
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

                    recGrowers.SETFILTER("Production Lot No.", "Production Lot No.");
                    recGrowers.CALCSUMS("Grower Share");
                    if recGrowers."Grower Share" <> 100 then
                        ERROR('Grower share total does not equal 100.  Cannot create Scale Ticket.');
                    if "Purchase UOM in LBS" = 0 then
                        ERROR('Purchase Unit of Measure in LBS is a required field');

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
                    recGrowers.SETFILTER("Production Lot No.", "Production Lot No.");
                    recGrowers.CALCSUMS("Grower Share");
                    if recGrowers."Grower Share" <> 100 then
                        ERROR('Grower share total does not equal 100.  Cannot create Settlement.');

                    recSettlement.Init("Production Lot No.");
                    pageSettlement.SETRECORD(recSettlement);
                    pageSettlement.RUN;
                end;
            }
        }
        area(processing)
        {
            action("All Scale Tickets")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;

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
                    if not recVendor.GET("Vendor Number") then
                        exit;

                    PAGE.RUN(50083, recVendor);
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
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        recScaleTkt.RESET;
        recScaleTkt.SETFILTER("Production Lot No.", "Production Lot No.");
        recScaleTkt.SETFILTER(Status, '%1', recScaleTkt.Status::Posted);
        if (recScaleTkt.FINDSET) and ("Production Lot No." > '') then
            IsEditable := false
        else
            IsEditable := true;
    end;

    trigger OnAfterGetRecord();
    var
        recScaleTkt: Record "Scale Ticket Header";
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Prod. Lot Entry Date" := TODAY;
    end;

    trigger OnOpenPage();
    begin
        IsEditable := true;
    end;

    var
        EnableDefer: Boolean;
        IsEditable: Boolean;
        recScaleTkt: Record "Scale Ticket Header";
        pageScaleTkts: Page "Scale Ticket List";
        recGrowers: Record "Production Grower";
}

