report 50040 "HSA Deduction List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/HSADeductionList.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            DataItemTableView = SORTING("Payroll Control Code", "Posting Date", "Employee No.") WHERE("Payroll Control Code" = FILTER('HSA*'));
            RequestFilterFields = "Pay Date";
            column(EmployeeNumber; "Payroll Ledger Entry"."Employee No.")
            {
            }
            column(PostingDate; "Payroll Ledger Entry"."Posting Date")
            {
            }
            column(ControlCode; "Payroll Ledger Entry"."Payroll Control Code")
            {
            }
            column(Amount; "Payroll Ledger Entry".Amount)
            {
            }
            column(LastName; EmployeeRec."Last Name")
            {
            }
            column(FirstName; EmployeeRec."First Name")
            {
            }
            column(PayDate; "Payroll Ledger Entry"."Pay Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not EmployeeRec.Get("Employee No.") then
                    Clear(EmployeeRec);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EmployeeRec: Record Employee;
        DateRange: Text[30];
        CodeRange: Text[40];
}

