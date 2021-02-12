pageextension 82303 PayrollJournalExt extends "Payroll Journal"
{
    layout
    {
        addafter("Seasonal Wages")
        {
            field("Check Printed"; "Check Printed")
            {
                ApplicationArea = all;
            }
            field("Check Exported"; "Check Exported")
            {
                ApplicationArea = all;
            }
            field("Check Transmitted"; "Check Transmitted")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("<Action25>")
        {
            action("Print Remittances")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    PayrollJnlLine: Record "Payroll Journal Line";
                    PayrollJnlTemplate: Record "Payroll Journal Template";
                    RuppRemittance: Report "Rupp Remittance Advice";
                begin
                    PayrollJnlLine.RESET;
                    PayrollJnlLine := Rec;
                    PayrollJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    PayrollJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    PayrollJnlTemplate.GET("Journal Template Name");

                    RuppRemittance.SetPayrollJnlLine(PayrollJnlLine);
                    RuppRemittance.RUNMODAL;
                    CLEAR(RuppRemittance);
                end;
            }
        }
        modify("<Action1240470020>")
        {
            trigger OnAfterAction()
            begin
                UpdatePayrollACHDate();
            end;
        }
        modify("<Action1240470021>")
        {
            trigger OnAfterAction()
            begin
                UpdatePayrollACHDate();
            end;
        }
    }

    local procedure UpdatePayrollACHDate()
    var
        recPayrollJournalLine: Record "Payroll Journal Line";
    begin
        recPayrollJournalLine.RESET;
        recPayrollJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        IF recPayrollJournalLine.FINDSET(TRUE, FALSE) THEN BEGIN

            REPEAT
                recPayrollJournalLine.CalcACHEffectiveDate();
                recPayrollJournalLine.MODIFY;
            UNTIL recPayrollJournalLine.NEXT = 0;
        END;
        COMMIT;
    end;
}