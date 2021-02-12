report 50034 "Print Pkg Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PrintPkgLabel.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Package; Package)
        {
            DataItemTableView = WHERE("No." = CONST('P007902'));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                UPSlinkTransaction: Codeunit "UPSlink Transaction";
            begin
                UPSlinkTransaction.PrintPackageLabel(Package);
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

