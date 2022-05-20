pageextension 60021 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Blocked Reason Code"; "Blocked Reason Code")
            {
                applicationarea = all;
            }
            field("Protected Customer"; "Protected Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("Phone No.")
        {
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Salesperson Code"; "Location Code")
        addafter("Location Code")
        {
            field(TerritoryCode; "Territory Code")
            {
                applicationarea = all;
            }
            field(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
                applicationarea = all;
            }
            field(CustomerPostingGroup; "Customer Posting Group")
            {
                applicationarea = all;
            }
            field(PaymentTermsCode; "Payment Terms Code")
            {
                applicationarea = all;
            }
            field(PaymentMethodCode; "Payment Method Code")
            {
                applicationarea = all;
            }
            field(ShippingAgentCode; "Shipping Agent Code")
            {
                applicationarea = all;
            }
            field(E_ShipAgentService; "E-Ship Agent Service")
            {
                applicationarea = all;
            }
            field(FreightChargesOption; "Freight Charges Option")
            {
                applicationarea = all;
            }
        }
        addafter("Country/Region Code")
        {
            field("Default Ship-to Code"; "Default Ship-to Code")
            {
                applicationarea = all;
            }
            field("Region Code"; "Region Code")
            {
                applicationarea = all;
            }
        }
        addafter("Disable Search by Name")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                applicationarea = all;
            }
            field("Pop-Up Notes"; "Pop-Up Notes")
            {
                applicationarea = all;
            }
        }
        addbefore("Shipping Time")
        {
            field("Freight Charges Option"; "Freight Charges Option")
            {
                applicationarea = all;
            }
        }
        modify("E-Ship Agent Service")
        {
            trigger OnAfterValidate()
            begin
                CheckCanada();
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                CheckCanada();
            end;
        }
        modify(County)
        {
            Caption = 'State';
        }
    }

    actions
    {
        addafter("Bank Accounts")
        {
            action("Payment Accounts")
            {
                RunObject = page "Customer Payment Accounts";
                RunPageLink = "Customer No." = field("No.");
                Promoted = true;
                Ellipsis = true;
                applicationarea = all;
            }
        }
        addafter(ApprovalEntries)
        {
            action(Compliance)
            {
                RunObject = page "Compliances";
                RunPageLink = "Customer No." = field("No.");
                applicationarea = all;
            }
        }
        addafter("Send Electronic Invoices -CL-")
        {
            action("Link Payments")
            {
                applicationarea = all;
                trigger OnAction()
                var
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    CustPmtLinkMgt.ShowCustPmtLinking(Rec);
                end;
            }
        }
        addafter("Statistics by C&urrencies")
        {
            action(ItemTracking)
            {
                Caption = 'Item &Tracking Entries';
                applicationarea = all;
                trigger OnAction()
                var
                    ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                begin
                    ItemTrackingDocMgt.ShowItemTrackingForMasterData(1, "No.", '', '', '', '', '');
                end;
            }
            action(PostedInvLines)
            {
                RunObject = page "Posted Sales Invoice Lines";
                RunPageLink = "Sell-to Customer No." = field("No.");
                applicationarea = all;
            }
        }
        addbefore("Invoice &Discounts")
        {
            action(ShowBalance)
            {
                Caption = 'Show Balance/Credit Info';
                applicationarea = all;
                trigger OnAction()
                var
                    cuCustPmtMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    cuCustPmtMgt.ShowCustomerBalance("No.");
                end;
            }
        }
    }

    var
        UPSOptionPage: record "UPS Option Page";
        recUserSetup: record "User Setup";

    trigger OnAfterGetCurrRecord()
    begin
        if recUserSetup.get(UserId) then begin
            if (recUserSetup."Show Protected Customers" <> true) and
                ("Protected Customer" = true) then begin
                error('You are not authorized to view this customer');
            end;
        end
        else
            error('You are not authorized to view this customer');
    end;

    procedure CheckCanada()
    begin
        IF "Country/Region Code" = 'CA' THEN BEGIN
            IF UPSOPtionPage.GET(UPSOPtionPage.Type::"Master Data", "No.", 18, 0, '') THEN BEGIN
                IF "Shipping Agent Code" = '' THEN
                    UPSOPtionPage.VALIDATE("Shipping Agent Code", 'UPS')
                ELSE
                    UPSOPtionPage.VALIDATE("Shipping Agent Code", "Shipping Agent Code");
                IF "E-Ship Agent Service" = '' THEN
                    UPSOPtionPage.VALIDATE("Shipping Agent Service", 'STANDARD')
                ELSE
                    UPSOPtionPage.VALIDATE("Shipping Agent Service", "E-Ship Agent Service");
                UPSOPtionPage."World Ease" := TRUE;
                UPSOPtionPage.MODIFY;
            END
            ELSE BEGIN
                UPSOPtionPage.VALIDATE(Type, UPSOPtionPage.Type::"Master Data");
                UPSOPtionPage.VALIDATE("Source ID", "No.");
                UPSOPtionPage.VALIDATE("Source Type", 18);
                UPSOPtionPage.VALIDATE("Source Subtype", 0);
                UPSOPtionPage.VALIDATE("Second Source ID", '');
                IF "Shipping Agent Code" = '' THEN
                    UPSOPtionPage.VALIDATE("Shipping Agent Code", 'UPS')
                ELSE
                    UPSOPtionPage.VALIDATE("Shipping Agent Code", "Shipping Agent Code");
                IF "E-Ship Agent Service" = '' THEN
                    UPSOPtionPage.VALIDATE("Shipping Agent Service", 'STANDARD')
                ELSE
                    UPSOPtionPage.VALIDATE("Shipping Agent Service", "E-Ship Agent Service");
                UPSOPtionPage.VALIDATE("World Ease", TRUE);
                UPSOPtionPage.INSERT;
            END;
        END;
    end;
}