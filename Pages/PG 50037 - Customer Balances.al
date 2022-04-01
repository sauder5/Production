page 50037 "Customer Balances"
{
    Caption = 'Customer Balances';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Customer";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.") { }
                field(Name; Name) { }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)") { }
                field("Payment Terms Code"; "Payment Terms Code") { }
                field("Other Amounts"; "Other Amounts") { }
                field(Balance; Balance)
                {

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.", "No.");
                        CopyFilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        CopyFilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        CopyFilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field("Remaining Seasonal Discount"; "Remaining Seasonal Discount") { }
                field("Outstanding Orders"; "Outstanding Orders") { }
                field("Outstanding Invoices"; "Outstanding Invoices") { }
                field("Shipped Not Invoiced"; "Shipped Not Invoiced") { }
                field("Potential Deposit Fall Amount"; "Potential Deposit Fall Amount") { }
                field("Potential Deposit Spring Amt"; "Potential Deposit Spring Amt") { }
                field("Potential Deposit Amount"; "Potential Deposit Amount") { }
                field(gdTotalBalance; gdTotalBalance)
                { Caption = 'Total Balance'; }
                field(gdRemainingCredit; gdRemainingCredit)
                { Caption = 'Remaining Credit'; }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Balance, "Remaining Seasonal Discount", "Potential Deposit Amount", "Outstanding Orders", "Outstanding Invoices", "Shipped Not Invoiced");
        //gdRemainingSeasDisc := "Total Potential Rem Amount" * -1;
        gdRemainingSeasDisc := "Remaining Seasonal Discount";

        gdPotentialDepAmt := "Potential Deposit Amount";
        gdTotalBalance := Balance + gdRemainingSeasDisc + gdPotentialDepAmt + "Outstanding Orders" + "Outstanding Invoices" + "Shipped Not Invoiced";
        if "Credit Limit (LCY)" = 0 then begin
            gdRemainingCredit := 0;
        end else begin
            gdRemainingCredit := "Credit Limit (LCY)" - gdTotalBalance;
            if gdRemainingCredit < 0 then
                gdRemainingCredit := 0;
        end;
    end;

    var
        gdRemainingSeasDisc: Decimal;
        gdPotentialDepAmt: Decimal;
        gdTotalBalance: Decimal;
        gdRemainingCredit: Decimal;
}


