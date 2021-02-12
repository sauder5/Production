page 50032 Compliances
{
    CardPageID = Compliance;
    PageType = List;
    SourceTable = Compliance;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Waiver Code"; "Waiver Code")
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; gsCustomerName)
                {
                    Editable = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    Visible = false;
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
        gsCustomerName := GetCustName("Customer No.");
    end;

    var
        gsCustomerName: Text[50];

    local procedure GetCustName(CustNo: Code[20]) retCustName: Text[50]
    var
        recCust: Record Customer;
    begin
        retCustName := '';
        if recCust.Get(CustNo) then begin
            retCustName := recCust.Name;
        end;
    end;
}

