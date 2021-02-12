report 50038 "Update Missing Compliances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/UpdateMissingCompliances.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {

            trigger OnAfterGetRecord()
            var
                codeCompliance: Codeunit "Compliance Management";
            begin
                codeCompliance.UpdateSalesLineCompliance("Sales Line");
                CurrReport.Skip;
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {

            trigger OnAfterGetRecord()
            begin
                CalcFields("Sales Header"."Missing Reqd License", "Sales Header"."Missing Reqd Liability Waiver", "Sales Header"."Missing Reqd Quality Release");
                "Sales Header".Modify;
                CurrReport.Skip;
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

