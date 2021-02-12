pageextension 70141 DepositSubformExt extends "Deposit Subform"
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
        addafter("Reason Code")
        {
            field("Spring Amount"; "Spring Amount")
            {
                applicationarea = all;
            }
            field("Fall Amount"; "Fall Amount")
            {
                applicationarea = all;
            }
            field("Spring Discount"; "Spring Discount")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Fall Discount"; "Fall Discount")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Seasonal Discount"; "Seasonal Discount")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Potential Fall Amount"; "Potential Fall Amount")
            {
                applicationarea = all;
            }
            field("Potential Spring Amount"; "Potential Spring Amount")
            {
                applicationarea = all;
            }
            field("Potential Amount"; "Potential Amount")
            {
                applicationarea = all;
            }
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                gsAccountName := RuppFun.GetDepositAccountName("Account Type", "Account No.")
            end;
        }
    }

    actions
    {
    }

    var
        gsAccountName: Text[50];
        RuppFun: Codeunit "Rupp Functions";

    trigger OnAfterGetRecord()
    begin
        gsAccountName := RuppFun.GetDepositAccountName("Account Type", "Account No.")
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        gsAccountName := RuppFun.GetDepositAccountName("Account Type", "Account No.")
    end;
}