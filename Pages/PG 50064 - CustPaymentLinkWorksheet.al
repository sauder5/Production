page 50064 "Cust. Payment Link Worksheet"
{
    // //SOC-SC 04-01-16
    //   Code to speed up opening of screen

    PageType = Document;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                grid(Control1000000012)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(Control1000000013)
                    {
                        ShowCaption = false;
                        field("No."; "No.")
                        {
                            Editable = false;
                        }
                        field(giPmtEntryNo; giPmtEntryNo)
                        {
                            Caption = 'Entry No.';
                            Editable = false;
                            Style = StrongAccent;
                            StyleExpr = giPmtEntryNo <> 0;
                            Visible = false;
                        }
                        field(Name; Name)
                        {
                            Editable = false;
                        }
                        field(gcPmtDocNo; gcPmtDocNo)
                        {
                            Caption = 'Document No.';
                            Editable = false;
                            Style = StrongAccent;
                            StyleExpr = gcPmtDocNo <> '';
                            Visible = false;
                        }
                        field(Balance; Balance)
                        {
                        }
                        field("Total Potential Rem Amount"; "Total Potential Rem Amount")
                        {
                        }
                    }
                }
            }
            part(Payments; "Customer Payment Entry Subpage")
            {
                SubPageLink = "Customer No." = FIELD("No."),
                              Open = CONST(true);
                SubPageView = WHERE("Document Type" = FILTER(Payment | "Credit Memo"));
            }
            part(Links; "Customer Payment Link Subpage")
            {
                SubPageLink = "Customer No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Payment Entry")
            {
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F3';

                trigger OnAction()
                begin
                    giPmtEntryNo := CurrPage.Payments.PAGE.GetEntryNo(gcPmtDocNo);
                    CurrPage.Links.PAGE.SetPmtEntry(giPmtEntryNo);

                    CurrPage.Payments.PAGE.SetEntryNo(giPmtEntryNo, gcPmtDocNo);  //SOC-MA 10-22-14
                end;
            }
            action("Refresh Links")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
                begin
                    CustPmtLinkMgt.RefreshCustPmtLinks("No.");
                    CurrPage.Links.PAGE.ResetPmtEntry();
                end;
            }
            action("Process Links")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustPmtLinks: Codeunit "Cust. Payment Link Mgt.";
                begin
                    CustPmtLinks.ProcessLinks("No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.Links.PAGE.SetCust("No."); //SOC-SC 04-01-16
    end;

    var
        gcPmtDocNo: Code[20];
        giPmtEntryNo: Integer;
}

