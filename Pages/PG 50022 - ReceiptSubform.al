page 50022 "Receipt Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Ratio %"; "Ratio %")
                {
                    AutoFormatType = 2;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Ticket No."; "Ticket No.")
                {
                    Visible = false;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    Visible = false;
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("Contract No."; "Contract No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                action("Purchase Order")
                {
                    RunObject = Page "Purchase Order";
                    RunPageLink = "Document Type" = FIELD ("Purchase Doc Type"),
                                  "No." = FIELD ("Purchase Doc No.");
                }
                action("Posted Purchase Receipt Lines")
                {

                    trigger OnAction()
                    var
                        recPurchrcptLn: Record "Purch. Rcpt. Line";
                    begin
                        TestField(Received);

                        recPurchrcptLn.Reset();
                        recPurchrcptLn.SetRange("Order No.", "Purchase Doc No.");
                        recPurchrcptLn.SetRange("Order Line No.", "Purchase Doc Line No.");
                        if recPurchrcptLn.FindSet() then begin
                            PAGE.RunModal(528, recPurchrcptLn);
                        end;
                    end;
                }
            }
        }
    }
}

