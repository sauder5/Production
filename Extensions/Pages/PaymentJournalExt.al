pageextension 60256 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Vendor Name"; gsVendorName)
            {
                ApplicationArea = all;
            }
            field("Posting Desc"; gsPostingDesc)
            {
                ApplicationArea = all;
            }
            field("Contract No."; gsContractNo)
            {
                ApplicationArea = all;
            }
        }
        modify(CurrentJnlBatchName)
        {
            ApplicationArea = all;
            trigger OnAfterValidate()
            begin
                gsVendorName := GetVendorName();
                GetContractNo(gsPostingDesc, gsContractNo);
            end;
        }
    }

    actions
    {
        addafter(GenerateEFT)
        {
            action("Suggest Check-off")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    repSuggestCheckoff: Report "Suggest Check-off";
                begin
                    clear(repSuggestCheckoff);
                    repSuggestCheckoff.SetJnlTemplBatch("Journal Template Name", "Journal Batch Name");
                    repSuggestCheckoff.RunModal();
                    clear(repSuggestCheckoff);
                end;
            }
        }
    }

    var
        gsVendorName: Text[50];
        gsPostingDesc: Text[50];
        gsContractNo: Text[20];

    trigger OnOpenPage()
    begin
        gsVendorName := '';
        gsPostingDesc := '';
    end;

    trigger OnAfterGetRecord()
    begin
        gsVendorName := GetVendorName();
    end;

    local procedure GetVendorName() retVendorName: Text[50]
    var
        recVendor: Record Vendor;
    begin
        clear(retVendorName);
        if "Account Type" = "Account Type"::Vendor then
            if recVendor.get("Account No.") then
                retVendorName := recVendor.Name;
    end;

    local procedure GetContractNo(var retPostingDesc: Text[50]; var retContractNo: Text[20])
    var
        recPIH: Record "Purch. Inv. Header";
    begin
        retContractNo := '';
        retPostingDesc := '';
        IF "Account Type" = "Account Type"::Vendor THEN
            IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                IF recPIH.GET("Applies-to Doc. No.") THEN BEGIN
                    recPIH.CALCFIELDS("Purchase Contract No.");
                    retContractNo := recPIH."Purchase Contract No.";
                    retPostingDesc := recPIH."Posting Description";
                END;
    end;
}