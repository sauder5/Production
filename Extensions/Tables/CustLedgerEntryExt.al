tableextension 60021 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(51000; "Seasonal Disc. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51010; "Cust. Payment Link Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist ("Customer Payment Link" WHERE ("Customer No." = FIELD ("Customer No."), "Invoice CLE No." = FIELD ("Entry No."), Processed = CONST (false), Cancelled = CONST (false)));
        }
        field(51020; "Season Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51021; "Requested Seasonal Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Customer Payment Link"."Requested Amount" WHERE ("Payment CLE No." = FIELD ("Entry No."), Request = FILTER (true)));
        }
        field(51022; "Linked Seasonal Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Customer Payment Link"."Amount to Link" WHERE ("Payment CLE No." = FIELD ("Entry No."), Request = FILTER (false), Processed = FILTER (false), Cancelled = FILTER (false)));
        }
        field(51024; "Linked Seasonal Discount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Customer Payment Link"."Effective Discount Amt to Link" WHERE ("Payment CLE No." = FIELD ("Entry No."), Request = FILTER (false), Processed = FILTER (false), Cancelled = FILTER (false)));
        }
        field(51025; "Requested Seasonal Discount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Customer Payment Link"."Requested Discount" WHERE (Request = CONST (true), Cancelled = CONST (false), "Payment CLE No." = FIELD ("Entry No.")));
        }
        field(51030; "Requested Fall Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateInsertRequestedAmt();
            end;
        }
        field(51031; "Requested Spring Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateInsertRequestedAmt();
            end;
        }
    }
    local procedure UpdateInsertRequestedAmt()
    var
        cuCustPmtLink: Codeunit "Cust. Payment Link Mgt.";
    begin
        cuCustPmtLink.InsertUpdateRequest(Rec, CurrFieldNo);
    end;

    trigger OnBeforeInsert()
    var
        recCustomer: Record Customer;
    begin
        if recCustomer.Get("Customer No.") then
            "Customer Name" := recCustomer.Name;
    end;
}