page 50086 "Settlement List"
{
    // version GroProd

    //    CardPageID = "Grower Settlement";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Settlement-Prepayment Ticket";
    CardPageId = "Grower Settlement";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Settlement No."; "Settlement No.")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("recVendor.Name"; recVendor.Name)
                {
                    Caption = 'Name';
                }
                field("Item No."; "Item No.")
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field("Settlement Quantity"; "Settlement Quantity")
                {
                }
                field("Settlement Date"; "Settlement Date")
                {
                }
                field("Base Settlement Price"; "Base Settlement Price")
                {
                }
                field("Settlement Type"; "Settlement Type")
                {
                }
                field("Prepayment Amount"; "Prepayment Amount")
                {
                }
                field("Settled Quantity"; "Settled Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field(Status; Status)
                {
                }
                field("Date Posted"; "Date Posted")
                {
                }
                field("Futures Date"; "Futures Date")
                {
                }
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

                trigger OnAction();
                var
                    cduReceiptMgt: Codeunit "Receipt Management";
                begin
                    CheckSettlement;
                    Status := Status::Posted;
                    "Date Posted" := TODAY;
                    MODIFY;
                    cduReceiptMgt.ApplyReceipts(Rec."Settlement Type");
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
        if not recVendor.GET("Vendor No.") then
            CLEAR(recVendor);
    end;

    var
        recVendor: Record Vendor;

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

    local procedure CheckSettlement();
    begin
        if not recVendor.GET("Vendor No.") then
            ERROR('Enter a valid vendor number for this settlement');

        if "Generic Name Code" = '' then
            ERROR('Generic Name Code is a required field');
        if "Settlement Quantity" <= 0 then
            ERROR('Please enter a valid settlement quantity');
        if "Base Settlement Price" <= 0 then
            ERROR('Please enter a valid Base Settlement Price');
        //IF "Location Code"='' THEN
        //  ERROR('Please enter a valid location code');
        //IF "Bin Code"='' THEN
        //  ERROR('Please enter a valid bin code');
        if "Settlement Date" = 0D then
            "Settlement Date" := TODAY;

        if "Settlement Type" = "Settlement Type"::Cash then
            CheckGrowerTickets(Rec);
    end;

    local procedure CheckGrowerTickets(recsettle: Record "Settlement-Prepayment Ticket");
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
                if "Remaining Quantity" < recsettle."Settlement Quantity" then
                    ERROR('Insufficent quantity available of %1 to satisfy settled quantity of %2', "Remaining Quantity", recsettle."Settlement Quantity");
            end;
    end;
}

