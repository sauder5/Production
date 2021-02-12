page 50033 Compliance
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Compliance;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Waiver Code"; "Waiver Code")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(gsCustName; gsCustName)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    QuickEntry = false;
                }
                field("Code"; Code)
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Visible = false;
                }
                field("License No."; "License No.")
                {
                }
                field("License Issued Date"; "License Issued Date")
                {
                }
                field("License Expiration Date"; "License Expiration Date")
                {
                }
                field("Liability Waiver Signed"; "Liability Waiver Signed")
                {
                }
                field("Liability Waiver Signed Date"; "Liability Waiver Signed Date")
                {
                }
                field("Liability Waiver Start Date"; "Liability Waiver Start Date")
                {
                }
                field("Liability Waiver End Date"; "Liability Waiver End Date")
                {
                }
                field("Quality Release Signed"; "Quality Release Signed")
                {
                }
                field("Quality Release Signed Date"; "Quality Release Signed Date")
                {
                }
                field("Quality Release Start Date"; "Quality Release Start Date")
                {
                }
                field("Quality Release End Date"; "Quality Release End Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        gsCustName := GetCustName();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        gsCustName := GetCustName();
    end;

    var
        gsCustName: Text[50];

    local procedure GetCustName() retCustName: Text[50]
    var
        recCust: Record Customer;
    begin
        if recCust.Get("Customer No.") then begin
            retCustName := recCust.Name;
        end;
    end;
}

