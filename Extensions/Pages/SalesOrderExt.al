pageextension 60042 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addafter("Posting Date")
        {
            field("PmtMethodCode"; "Payment Method Code")
            {
                applicationarea = all;
                ToolTip = 'Payment Method Code';
                trigger OnAssistEdit()
                var
                    recPaymentAccount: Record "Payment Account";
                    pgCustPayAcct: Page "Customer Payment Accounts";
                begin
                    //SOC-MA 07-13-15
                    recPaymentAccount.RESET();
                    // recPaymentAccount.SETRANGE("Payment Method Code", "Payment Method Code");
                    recPaymentAccount.SETRANGE("Customer No.", "Sell-to Customer No.");
                    page.run(Page::"Customer Payment Accounts", recPaymentAccount);
                end;
            }
        }
        addafter(Status)
        {
            field("Shipping Status"; "Shipping Status")
            {
                applicationarea = all;
                Editable = false;
            }
            field(Cancelled; Cancelled)
            {
                applicationarea = all;
            }
            field("Cancelled Reason Code"; "Cancelled Reason Code")
            {
                applicationarea = all;
            }
            field("Order Method"; "Order Method")
            {
                applicationarea = all;
            }
            field("On Hold"; "On Hold")
            {
                applicationarea = all;
            }
            field("On-Hold Reason Code"; "On-Hold Reason Code")
            {
                applicationarea = all;
            }
            field("Customer Posting Group"; "Customer Posting Group")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field(PmtTermsCode; "Payment Terms Code")
            {
                applicationarea = all;
            }
            // Added by TAE 2021-08-04 to support the online customer center and ordering
            field("CustomerComment"; "Customer Comment")
            {
                ApplicationArea = All;
                ToolTip = 'Customer Comment';
                Editable = false;
            }
            // End
        }
        addbefore("Bill-to Name")
        {
            field("Bill-to Customer No."; "Bill-to Customer No.")
            {
                applicationarea = all;
            }
        }
        addbefore("Ship-to Code")
        {
            field(CopySellToAddress; CopySellToAddress)
            {
                Caption = 'Same as Sell-to Address';
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    IF CopySellToAddress THEN BEGIN
                        CLEAR("Ship-to Code");
                        CopySellToAddressToShipToAddress();
                    END;
                    ComplianceMgt.UpdateSalesLineComplianceHeader(Rec);
                end;
            }
        }
        addafter("Ship-to Post Code")
        {
            field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                applicationarea = all;
            }
        }
        addafter("Promised Delivery Date")
        {
            field("Requested Ship Date"; "Requested Ship Date")
            {
                applicationarea = all;
            }
        }
        addafter("Tax Area Code")
        {
            field("Seasonal Cash Disc Code"; "Seasonal Cash Disc Code")
            {
                applicationarea = all;
            }
            field("Grace Period Days"; "Grace Period Days")
            {
                applicationarea = all;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("EShip Agent Service"; "E-Ship Agent Service")
            {
                applicationarea = all;
            }
        }
        addafter("E-Ship Agent Service")
        {
            field("Freight Charges Option"; "Freight Charges Option")
            {
                ApplicationArea = all;
            }
        }
        addafter("Payment Group -CL-")
        {
            Group(Other)
            {
                field("Created By"; "Created By")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Created Date Time"; "Created Date Time")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Ordered By"; "Ordered By")
                {
                    applicationarea = all;
                }
                field("Ordered By Name"; "Ordered By Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Ordered By Date"; "Ordered By Date")
                {
                    applicationarea = all;
                }
                field("Region Code"; "Region Code")
                {
                    applicationarea = all;
                }
            }
        }
        modify(ShippingOptions)
        {
            Visible = false;
        }
        modify(Control4) { Visible = true; }
        modify("Ship-to Code")
        {
            Visible = true;
            Editable = true;
            ApplicationArea = all;
            trigger OnAfterValidate()
            begin
                ComplianceMgt.UpdateSalesLineComplianceHeader(Rec);
            end;
        }
        modify("Ship-to Name") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to Address") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to Address 2") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to City") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to County") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to Post Code") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to Phone No. -CL-") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Ship-to UPS Zone") { Visible = true; Editable = true; ApplicationArea = all; }
        modify("Currency Code")
        {
            ApplicationArea = all;
            trigger OnBeforeValidate()
            var
                ChangeExchangeRate: page "Change Exchange Rate";
            begin
                IF "Posting Date" <> 0D THEN
                    ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date")
                ELSE
                    ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE());
                IF ChangeExchangeRate.RUNMODAL() = ACTION::OK THEN BEGIN
                    VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter());
                    CurrPage.SAVERECORD();
                END;
            end;
        }
        modify("Third Party Ship. Account No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                ShippingAccount: Record "Shipping Account";
            begin
                IF ShippingAccount.LookupThirdPartyAccountNo(
                    "Shipping Agent Code", ShippingAccount."Ship-to Type"::Customer,
                    "Sell-to Customer No.", "Ship-to Code")
                THEN
                    VALIDATE("Third Party Ship. Account No.", ShippingAccount.GetLookupAccountNo());
            end;
        }
    }

    actions
    {
        modify("Credit Card Voice Authorize -CL-")
        {
            Visible = false;
        }
        modify("Print Confirmation")
        {
            trigger OnBeforeAction()
            begin
                Commit();
            end;
        }
        modify(SendEmailConfirmation)
        {
            trigger OnBeforeAction()
            begin
                Commit();
            end;
        }
        addafter(AssemblyOrders)
        {
            Action("Compliances Required")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                trigger onAction()
                begin
                    commit();
                    ComplianceMgt.ShowCompliancesReqd(Rec);
                end;
            }
            Action("Link Payments")
            {
                ApplicationArea = all;
                trigger onAction()
                var
                    recCust: Record "Customer";
                begin
                    If recCust.get("Sell-to Customer No.") then
                        CustPmtLinkMgt.ShowCustPmtLinking(recCust);
                end;
            }
        }
        addafter("Cancel Electronic Payment Request -CL-")
        {
            action("Show Balance/Credit Info")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    commit();
                    CustPmtLinkMgt.ShowCustomerBalance("Sell-to Customer No.");
                end;
            }
        }
        addafter(Warehouse)
        {
            action("Refresh Shipping Status")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppFun.UpdateShpgStatusSH_(Rec);
                end;
            }
            action("Add Static Shipping & Handling")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    IF RuppFun.AddStaticShpgHandlingToSO(Rec) THEN BEGIN
                        COMMIT();
                        MESSAGE('Added Shipping & Handling');
                    END ELSE
                        MESSAGE('Shipping & Handling Not added');
                end;
            }
            action("Create Rupp Pick")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppWhseMgt.CreateRuppWhsePick(Rec);
                end;
            }
            action("Rupp Warehouse Shipment")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppWhseMgt.OpenRuppWhseShpt(Rec);
                end;
            }
            action("Print Rupp Pick")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppWhseMgt.PrintRuppWhsePick(Rec);
                end;
            }
            action("Delete Rupp Pick")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppWhseMgt.DeleteRuppWhsePick(Rec);
                end;
            }
        }
        addafter("Pick Instruction")
        {
            action("Pick Ticket")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RuppFun.PrintPickTTicketForSO("No.");
                end;
            }
        }
    }

    var
        ComplianceMgt: Codeunit "Compliance Management";
        RuppFun: Codeunit "Rupp Functions";
        RuppWhseMgt: Codeunit "Rupp Warehouse Mgt";
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        ShowCustomerComments: Boolean;
        CopySellToAddress: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        Validate("Payment Method Code");
        IF ("Ship-to Name" = "Sell-to Customer Name") AND
        ("Ship-to Address" = "Sell-to Address") AND
        ("Ship-to Address 2" = "Sell-to Address 2") THEN
            CopySellToAddress := TRUE;
        currpage.update(false);
    end;

    local procedure SetCustomerCommentsVisible(CustomerID: Text[20])
    var
        CommentRec: Record "Comment Line";
    begin
        CommentRec.SETFILTER(CommentRec."Table Name", 'Customer');
        CommentRec.SETFILTER(CommentRec."No.", CustomerID);
        ShowCustomerComments := FALSE;

        IF CommentRec.COUNT() > 0 THEN
            ShowCustomerComments := TRUE;
    end;

    local procedure BilltoCustomerNoOnAfterValidate()
    begin
        CurrPage.Update();
    end;
}