report 50000 "Calc. Seasonal Disc. for Pymt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CalcSeasonalDiscforPymt.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code") WHERE("Document Type" = CONST(Payment));

            trigger OnAfterGetRecord()
            begin
                if "Document No." = '' then
                    CurrReport.Skip();
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
}

