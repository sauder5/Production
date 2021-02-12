pageextension 67023 SalesPriceWksExt extends "Sales Price Worksheet"
{
    layout
    {
        addbefore(Control1)
        {
            field("Batch Name"; gcBatchName)
            {
                ApplicationArea = all;
            }
        }
        modify("Item Description")
        {
            Visible = false;
            Editable = false;
        }
        addafter("Current Unit Price")
        {
            field("Current Unit Price per CUOM"; "Current Unit Price per CUOM")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("New Unit Price")
        {
            field("New Unit Price per CUOM"; "New Unit Price per CUOM")
            {
                ApplicationArea = all;
            }
            field("Common UOM"; "Common UOM")
            {
                ApplicationArea = all;
            }
            field("Qty. per Common UOM"; "Qty. per Common UOM")
            {
                ApplicationArea = all;
            }
        }
        modify("Allow Invoice Disc.")
        {
            Visible = false;
        }
        modify("Price Includes VAT")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Visible = false;
        }
        modify("Allow Line Disc.")
        {
            Visible = false;
        }
    }

    actions
    {
        modify("Suggest &Item Price on Wksh.")
        {
            Visible = false;
        }
    }

    var
        gcBatchName: Code[10];

    local procedure ValidateBatchName(BatchName: Code[10])
    begin
        //SOC-SC 10-20-15
        SETFILTER("Batch Code", '%1', BatchName);
        CurrPage.UPDATE();
    end;

    trigger OnOpenPage()
    begin
        ValidateBatchName(gcBatchName);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Batch Code" := gcBatchName;
    end;
}