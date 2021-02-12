report 50057 "Cancelled Quantity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CancelledQuantity.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Qty Cancelled Buffer"; "Qty Cancelled Buffer")
        {
            UseTemporary = true;
            column(OrderNum; "Qty Cancelled Buffer"."Document No.")
            {
            }
            column(Date; "Qty Cancelled Buffer".Date)
            {
            }
            column(LineNum; "Qty Cancelled Buffer"."Line No.")
            {
            }
            column(CustomerNum; "Qty Cancelled Buffer"."Sell-to Customer No.")
            {
            }
            column(ItemNum; "Qty Cancelled Buffer"."No.")
            {
            }
            column(Description; "Qty Cancelled Buffer".Description)
            {
            }
            column(Quantity; "Qty Cancelled Buffer"."Qty. Requested")
            {
            }
            column(CancelQty; "Qty Cancelled Buffer"."Qty. Cancelled")
            {
            }

            trigger OnAfterGetRecord()
            var
                bError: Boolean;
            begin
                Clear(recCustomer);
                bError := recCustomer.Get("Qty Cancelled Buffer"."Sell-to Customer No.");
            end;

            trigger OnPreDataItem()
            begin
                "Qty Cancelled Buffer".SetCurrentKey("Document No.", "No.");
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

    trigger OnPreReport()
    var
        recInvoiceHead: Record "Sales Invoice Header";
        bErr: Boolean;
        recSalesHead: Record "Sales Header";
    begin
        recSalesLine.SetFilter("Qty. Cancelled", '<>0');
        if recSalesLine.FindSet then
            repeat
                if not "Qty Cancelled Buffer".Get(recSalesLine."Document No.", recSalesLine."Line No.") then begin
                    "Qty Cancelled Buffer".TransferFields(recSalesLine);
                    if not recSalesHead.Get(recSalesLine."Document Type", recSalesLine."Document No.") then
                        Clear(recSalesHead);
                    "Qty Cancelled Buffer".Date := recSalesHead."Document Date";
                    "Qty Cancelled Buffer".Insert;
                end;
            until recSalesLine.Next = 0;

        recInvoiceLine.SetFilter("Qty. Cancelled", '<>0');
        if recInvoiceLine.FindSet then
            repeat
                if not recInvoiceHead.Get(recInvoiceLine."Document No.") then
                    Clear(recInvoiceHead);
                if not "Qty Cancelled Buffer".Get(recInvoiceHead."Order No.", recInvoiceLine."Line No.") then begin
                    "Qty Cancelled Buffer".TransferFields(recInvoiceLine);
                    "Qty Cancelled Buffer"."Document No." := recInvoiceHead."Order No.";
                    "Qty Cancelled Buffer".Date := recInvoiceHead."Document Date";
                    "Qty Cancelled Buffer".Insert;
                end;
            until recInvoiceLine.Next = 0;
    end;

    var
        recCustomer: Record Customer;
        recSalesLine: Record "Sales Line";
        recInvoiceLine: Record "Sales Invoice Line";
}

