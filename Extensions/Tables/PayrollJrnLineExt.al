tableextension 80302 PayrollJrnLineExt extends "Payroll Journal Line"
{
    fields
    {
        field(50000; "ACH Effective Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }
    var
        FromCorrectionProcess: Boolean;

    trigger OnAfterInsert()
    begin
        CalcACHEffectiveDate();
    end;

    procedure CalcACHEffectiveDate()
    begin
        IF "Posting Date" = 0D THEN
            VALIDATE("ACH Effective Date", 0D)
        ELSE
            VALIDATE("ACH Effective Date", CALCDATE('2D', "Posting Date"));
    end;

    procedure SetFromCorrectionProcess(pValue: Boolean)
    begin
        FromCorrectionProcess := pValue
    end;
}
