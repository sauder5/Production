pageextension 70143 PostedDepositExt extends "Posted Deposit"
{
    layout
    {

    }

    actions
    {
        addafter("&Navigate")
        {
            action("Link Payments")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    recPostedDepositLine: record "Posted Deposit Line";
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                    recCust: Record Customer;
                    iEntryNo: Integer;
                begin
                    iEntryNo := CurrPage.Subform.PAGE.GetEntryNo();

                    recPostedDepositLine.RESET();
                    recPostedDepositLine.SETRANGE("Entry No.", iEntryNo);
                    recPostedDepositLine.FINDFIRST();
                    IF recPostedDepositLine."Account Type" = recPostedDepositLine."Account Type"::Customer THEN BEGIN
                        recCust.GET(recPostedDepositLine."Account No.");
                        CustPmtLinkMgt.ShowCustPmtLinking(recCust);
                    END;
                end;
            }
        }
    }
}