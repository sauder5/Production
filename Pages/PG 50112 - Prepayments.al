page 50112 Prepayments
{
    // version GroProd

    PageType = List;
    SourceTable = "Prepayment Amounts";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prepayment No."; "Prepayment No.")
                {
                }
                field("Vendor No."; "Vendor No.")
                {

                    trigger OnValidate();
                    begin
                        if not recVendor.GET("Vendor No.") then
                            CLEAR(recVendor);
                    end;
                }
                field(VendorName; recVendor.Name)
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field("Prepayment Date"; "Prepayment Date")
                {
                }
                field("Prepayment Amount"; "Prepayment Amount")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Amount Consumed"; "Amount Consumed")
                {
                    Editable = false;
                }
                field("Amount Remaining"; "Amount Remaining")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
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
                    CheckPrepay;
                    cduReceiptMgt.CreatePaymentFromSettlement(Rec)
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
        cduReceiptMgt: Codeunit "Receipt Management";
        recVendor: Record Vendor;

    local procedure CheckPrepay();
    var
        recVendor: Record Vendor;
    begin
        if not recVendor.GET("Vendor No.") then begin
            ERROR('Enter a valid vendor number for payment');
            exit;
        end;
        if "Prepayment Date" = 0D then begin
            ERROR('Prepay date is required');
            exit;
        end;
        if "Prepayment Amount" = 0 then begin
            ERROR('Prepayment was selected - a prepayment amount is required');
            exit;
        end;
    end;
}

