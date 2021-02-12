report 50041 "Check Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CheckRegister.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            DataItemTableView = SORTING("Employee No.", "Posting Date", "Document Type", "Document No.");
            column(EmployeeNo; "Payroll Ledger Entry"."Employee No.")
            {
            }
            column(PayDate; "Payroll Ledger Entry"."Pay Date")
            {
            }
            column(ControlCode; "Payroll Ledger Entry"."Payroll Control Code")
            {
            }
            column(Department; "Payroll Ledger Entry"."Global Dimension 1 Code")
            {
            }
            column(PayCheckAmount; "Payroll Ledger Entry"."Amount on Pay Check")
            {
            }
            column(Amount; "Payroll Ledger Entry".Amount)
            {
            }
            column(ControlType; "Payroll Ledger Entry"."Payroll Control Type")
            {
            }
            column(Earnings; gdEarnings)
            {
            }
            column(Deductions; gdDeductions)
            {
            }
            column(CheckNo; "Payroll Ledger Entry"."Check No.")
            {
            }
            column(FirstName; EmployeeRec."First Name")
            {
            }
            column(LastName; EmployeeRec."Last Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                gdEarnings := 0;
                gdDeductions := 0;
                if "Pay Date" <> gPayDate then
                    CurrReport.Skip;

                if "Payroll Control Type" = "Payroll Control Type"::Earnings then
                    gdEarnings := "Amount on Pay Check"
                else
                    gdDeductions := "Amount on Pay Check";

                if not EmployeeRec.Get("Employee No.") then
                    Clear(EmployeeRec);
            end;

            trigger OnPostDataItem()
            begin
                Deductions.SetFilter("Pay Date", '%1', gPayDate);
            end;
        }
        dataitem(Deductions; "Payroll Ledger Entry")
        {
            DataItemTableView = SORTING("Payroll Control Code", "Posting Date") WHERE("Payroll Control Type" = FILTER(<> Earnings), Amount = FILTER(< 0));
            column(Deduction; Deductions."Payroll Control Code")
            {
            }
            column(DeductionAmt; Amount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Pay Date" <> gPayDate then
                    CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(gPaydate; gPayDate)
                {
                    Caption = 'Payroll Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        gdEarnings: Decimal;
        gdDeductions: Decimal;
        EmployeeRec: Record Employee;
        gPayDate: Date;
}

