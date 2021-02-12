tableextension 70144 PostedDepositLineExt extends "Posted Deposit Line"
{
    fields
    {
        field(51000; "Amount Linked to Sales Orders"; Decimal)
        {
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
        }
        field(51001; "Amount Remaining to Link"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Remaining Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
        }
        field(51003; "Amt. Linked to Sales Orders"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Customer Payment Link"."Amount to Link" WHERE ("Payment CLE No." = FIELD ("Entry No."), "Invoice CLE No." = FILTER (0), Cancelled = FILTER (false), Processed = FILTER (false)));
        }
        field(51004; "Amount Remaining"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE ("Cust. Ledger Entry No." = FIELD ("Entry No.")));
        }
    }
    procedure UpdateAmtRemainingtoLink()
    begin
        CALCFIELDS("Amt. Linked to Sales Orders", "Amount Remaining");
        "Amount Remaining to Link" := "Amount Remaining" - "Amt. Linked to Sales Orders";
    end;
}