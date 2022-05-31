report 50062 "Remove Cancelled Orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/RemoveCancelledOrders.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order), "On Hold" = filter(''));
            column(OrderNum; "Sales Header"."No.")
            {
            }
            column(CustomerNum; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(CustomerName; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(TotalOutstanding; "Sales Header"."Total Outstanding Qty. (base)")
            {
            }
            column(ShipNotInvoiced; "Sales Header"."Shipped Not Invoiced Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Shipped Not Invoiced Amount", "Outstanding Amount ($)", "Total Outstanding Qty. (base)");
                if "Sales Header".Cancelled then begin
                    Delete;
                    CurrReport.Skip;
                    exit;
                end;

                if ("Shipped Not Invoiced Amount" > 0.0) or ("Outstanding Amount ($)" > 0.0) or ("Total Outstanding Qty. (base)" > 0) or
                    ("Shipped Not Invoiced" = true)
                   then begin
                    CurrReport.Skip;
                    exit;
                end;

                recSalesLine.Reset;
                recSalesLine.SetFilter("Document No.", "Sales Header"."No.");
                recSalesLine.SetFilter("Qty. to Invoice (Base)", '>0');
                if recSalesLine.FindSet then
                    CurrReport.Skip;

                recInvHead.SetCurrentKey("Order No.");
                recInvHead.SetFilter("Order No.", "No.");

                if recInvHead.FindLast then begin
                    recSalesLine.Reset;
                    recSalesLine.SetFilter("Document No.", "Sales Header"."No.");
                    recSalesLine.SetFilter("Qty. Cancelled", '>0');
                    if recSalesLine.FindSet then
                        repeat
                            if recInvLine.Get(recInvHead."No.", recSalesLine."Line No.") then
                                if recSalesLine."No." = recInvLine."No." then begin
                                    recInvLine."Qty. Cancelled" := recSalesLine."Qty. Cancelled";
                                    recInvLine.Modify;
                                end;
                        until recSalesLine.Next = 0;
                end;

                Delete;
                CurrReport.Skip;
            end;
        }
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order));

            trigger OnAfterGetRecord()
            begin
                if recSalesHead.Get("Sales Line"."Document Type", "Sales Line"."Document No.") then
                    CurrReport.Skip
                else
                    "Sales Line".Delete;
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
        recSalesLine: Record "Sales Line";
        recInvHead: Record "Sales Invoice Header";
        recInvLine: Record "Sales Invoice Line";
        recSalesHead: Record "Sales Header";
}

