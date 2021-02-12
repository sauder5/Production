pageextension 70144 PostedDepositSubformExt extends "Posted Deposit Subform"
{
    layout
    {
        addafter("Account No.")
        {
            field("Account Name"; gsAccountName)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Entry No.")
        {
            field("Amount Linked to Sales Orders"; "Amt. Linked to Sales Orders")
            {
                ApplicationArea = all;
            }
            field("Amount Remaining to Link"; "Amount Remaining to Link")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    var
        gsAccountName: Text[50];
        giEntryNo: Integer;
        RuppFun: Codeunit "Rupp Functions";

    trigger OnAfterGetRecord()
    begin
        UpdateAmtRemainingtoLink();
        gsAccountName := RuppFun.GetDepositAccountName("Account Type", "Account No.");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        giEntryNo := "Entry No.";
    end;

    procedure GetEntryNo() retEntryNo: Integer;
    begin
        retEntryNo := giEntryNo;
    end;
}