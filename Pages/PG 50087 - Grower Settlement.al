page 50087 "Grower Settlement"
{
    // version GroProd

    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Lists;
    PopulateAllFields = false;
    SourceTable = "Settlement-Prepayment Ticket";

    layout
    {
        area(content)
        {
            group(General)
            {
                //                Editable = VisiblePost;
                field("Settlement No."; "Settlement No.")
                {
                }
                field("Vendor No."; "Vendor No.")
                {

                    trigger OnValidate();
                    begin
                        if not recVendor.GET("Vendor No.") then
                            CLEAR(recVendor);

                        GetGeneric;
                        "Production Lot No." := FindProdLot("Vendor No.", "Generic Name Code");
                    end;
                }
                field("recVendor.Name"; recVendor.Name)
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field("Generic Name Code"; "Generic Name Code")
                {

                    trigger OnValidate();
                    begin
                        GetGeneric;
                        "Production Lot No." := FindProdLot("Vendor No.", "Generic Name Code");
                    end;
                }
                field("recProdAtt.Description"; recProdAtt.Description)
                {
                    Caption = 'Generic Name Description';
                    Editable = false;
                }
                field(dAvailToSettle; dAvailToSettle)
                {
                    Caption = 'Available to Settle';
                    Editable = false;
                }
                field("Settlement Quantity"; "Settlement Quantity")
                {
                }
                field("recProdLot.""Purchase UOM"""; recProdLot."Purchase UOM")
                {
                    Caption = 'Purchase UOM Code';
                }
                group(Control1000000021)
                {
                    Caption = '';
                    field("Settlement Date"; "Settlement Date")
                    {
                    }
                    field("Settlement Type"; "Settlement Type")
                    {
                    }
                    field("Base Settlement Price"; "Base Settlement Price")
                    {
                    }
                    field("Futures Date"; "Futures Date")
                    {
                        Enabled = "Settlement Type" = "Settlement Type"::"Futures (New Crop)";
                    }
                    field("Deferred Payment"; "Deferred Payment")
                    {
                    }
                    field("Deferred Date"; "Deferred Date")
                    {
                        Enabled = "Deferred Payment" = TRUE;
                    }
                    field(Status; Status)
                    {
                        Editable = false;

                        trigger OnValidate();
                        begin
                            if Status = Status::Posted then
                                VisiblePost := false
                            else
                                VisiblePost := true;
                        end;
                    }
                    field("Date Posted"; "Date Posted")
                    {
                        Editable = false;
                    }
                }
            }
            group(Control1000000022)
            {
                part(Control1000000023; "Applied Amounts")
                {
                    Editable = false;
                    SubPageLink = "Settlement Ticket No." = FIELD("Settlement No.");
                }
            }
        }
        area(factboxes)
        {
            part(VendorStatisticsFactBox; "Vendor Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Vendor No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(New)
            {
                Image = NewDocument;
                Promoted = true;
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
        area(processing)
        {
            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = VisiblePost;

                trigger OnAction();
                var
                    cduReceiptMgt: Codeunit "Receipt Management";
                    recSettleTkt: Record "Settlement-Prepayment Ticket";
                begin
                    if not CheckSettlement then
                        exit;
                    Status := Status::Posted;
                    "Date Posted" := TODAY;
                    MODIFY;
                    cduReceiptMgt.ApplyReceipts(Rec."Settlement Type");
                    //CurrPage.CLOSE;

                    COMMIT;
                    recSettleTkt.SETFILTER("Settlement No.", "Settlement No.");
                    REPORT.RUN(50056, true, false, recSettleTkt);
                end;
            }
        }
        area(reporting)
        {
            action("Settlement Report")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction();
                var
                    recSettleTkt: Record "Settlement-Prepayment Ticket";
                begin
                    recSettleTkt.SETFILTER("Settlement No.", "Settlement No.");
                    REPORT.RUN(50056, true, false, recSettleTkt);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        if Status = Status::Posted then
            VisiblePost := false
        else
            VisiblePost := true;

        if not recVendor.GET("Vendor No.") then
            CLEAR(recVendor);

        //IF NOT recProdLot.GET("Production Lot No.") THEN
        //  ERROR('There was an error in initializing this grower settlement - No Production Lot');

        //GetGeneric;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        VisiblePost := true;
    end;

    var
        recVendor: Record Vendor;
        recProdAtt: Record "Product Attribute";
        recProdLot: Record "Production Lot";
        recGrowTkt: Record "Grower Ticket";
        dAvailToSettle: Decimal;
        VisiblePost: Boolean;

    local procedure GetGeneric();
    begin
        recProdAtt.RESET;
        recProdAtt.SETFILTER("Attribute Type", 'Generic Name');
        recProdAtt.SETFILTER(Code, "Generic Name Code");

        if not recProdAtt.FINDFIRST then
            CLEAR(recProdAtt);

        if ("Generic Name Code" = '') or ("Vendor No." = '') then
            exit;

        recGrowTkt.RESET;
        recGrowTkt.SETFILTER("Generic Name Code", "Generic Name Code");
        recGrowTkt.SETFILTER("Vendor No.", "Vendor No.");
        recGrowTkt.SETFILTER(Status, '%1', recGrowTkt.Status::Posted);
        recGrowTkt.SETFILTER("Remaining Quantity", '>0');
        recGrowTkt.CALCSUMS("Remaining Quantity");
        dAvailToSettle := recGrowTkt."Remaining Quantity";
    end;

    local procedure CheckPrepay();
    begin
        if not recVendor.GET("Vendor No.") then begin
            ERROR('Enter a valid vendor number for payment');
            exit;
        end;
        if "Settlement Date" = 0D then begin
            ERROR('Settlement date is required');
            exit;
        end;
        if "Prepayment Amount" = 0 then begin
            ERROR('Prepayment was selected - a prepayment amount is required');
            exit;
        end;
    end;

    local procedure CheckSettlement() retValue: boolean;
    var
        bOk: Boolean;
    begin
        if not recVendor.GET("Vendor No.") then begin
            ERROR('Enter a valid vendor number for this settlement');
            exit(false);
        end;
        if "Generic Name Code" = '' then begin
            ERROR('Generic Name Code is a required field');
            exit(false);
        end;
        if "Settlement Quantity" <= 0 then begin
            Error('Please enter a valid settlement quantity');
            exit(false);
        end;
        if "Base Settlement Price" <= 0 then begin
            bOk := Confirm('Do you want to post this settlement with a zero price', false);
            if not bOk then
                exit(false);
        end;
        if ("Settlement Type" = "Settlement Type"::"Futures (New Crop)") and ("Futures Date" = 0D) then begin
            ERROR('Futures date is required for a Futures (New Crop) settlement');
            exit(false);
        end;
        //IF "Location Code"='' THEN
        //  ERROR('Please enter a valid location code');
        //IF "Bin Code"='' THEN
        //  ERROR('Please enter a valid bin code');
        if "Settlement Date" = 0D then
            "Settlement Date" := TODAY;

        if "Settlement Type" = "Settlement Type"::Cash then begin
            bOk := CheckGrowerTickets(Rec);
            exit(bOk);
        end;
        exit(true);
    end;

    local procedure CheckGrowerTickets(recsettle: Record "Settlement-Prepayment Ticket") retValue: Boolean;
    var
        recGrowerTkt: Record "Grower Ticket";
    begin

        if recsettle."Settlement Type" = recsettle."Settlement Type"::Cash then
            with recGrowerTkt do begin
                RESET;
                SETFILTER("Vendor No.", recsettle."Vendor No.");
                SETFILTER("Generic Name Code", recsettle."Generic Name Code");
                SETFILTER(Status, '%1', Status::Posted);
                SETCURRENTKEY("Posting Date");

                CALCSUMS("Remaining Quantity");
                if "Remaining Quantity" < recsettle."Settlement Quantity" then begin
                    ERROR('Insufficent quantity available of %1 to satisfy settled quantity of %2', "Remaining Quantity", recsettle."Settlement Quantity");
                    exit(false);
                end else
                    exit(true);
            end;
    end;

    local procedure FindProdLot(VendorNo: Code[20]; GenericName: Code[20]) FoundLot: Code[20];
    var
        recProdLot: Record "Production Lot";
    begin
        CLEAR(FoundLot);
        if (VendorNo = '') or (GenericName = '') then
            exit(FoundLot);

        recProdLot.RESET;
        recProdLot.SETFILTER("Vendor Number", VendorNo);
        recProdLot.SETFILTER("Generic Name Code", GenericName);
        recProdLot.SETFILTER(Status, '%1', recProdLot.Status::Open);

        if recProdLot.FINDSET then begin
            repeat
                if recProdLot."Quantity Received" > recProdLot."Quantity Settled" then
                    exit(recProdLot."Production Lot No.");
            until recProdLot.NEXT = 0;
        end;

        exit(FoundLot);
    end;
}

