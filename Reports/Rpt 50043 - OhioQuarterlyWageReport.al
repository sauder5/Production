report 50043 "Ohio Quarterly Wage Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/OhioQuarterlyWageReport.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(County = FILTER('OH' | 'WI' | 'IL'));
            PrintOnlyIfDetail = true;
            column(SocSec; Employee."Social Security No.")
            {
            }
            column(LastName; Employee."Last Name")
            {
            }
            column(FirstName; CopyStr(Employee."First Name", 1, 1))
            {
            }
            column(MiddleName; CopyStr(Employee."Middle Name", 1, 1))
            {
            }
            dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = WHERE("Payroll Control Type" = FILTER(Earnings));
                column(Amount; "Payroll Ledger Entry".Amount)
                {
                }
            }
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
}

