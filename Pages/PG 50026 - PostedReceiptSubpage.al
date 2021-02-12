page 50026 "Posted Receipt Subpage"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Ticket No."; "Ticket No.")
                {
                }
                field("Ratio %"; "Ratio %")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field(Received; Received)
                {
                }
                field("Purchase Doc Type"; "Purchase Doc Type")
                {
                    Visible = false;
                }
                field("Purchase Doc No."; "Purchase Doc No.")
                {
                    Visible = false;
                }
                field("Purchase Doc Line No."; "Purchase Doc Line No.")
                {
                    Visible = false;
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Check-off %"; "Check-off %")
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
                action("Purchase Lines")
                {

                    trigger OnAction()
                    var
                        recPL: Record "Purchase Line";
                    begin
                        recPL.Reset();
                        recPL.SetRange("Document Type", recPL."Document Type"::Order);
                        recPL.SetRange("Rcpt No.", "Receipt No.");
                        recPL.SetRange("Rcpt Line No.", "Line No.");
                        if recPL.FindSet() then begin
                            PAGE.RunModal(0, recPL);
                        end;
                    end;
                }
                action("Posted Purchase Receipt Lines")
                {

                    trigger OnAction()
                    var
                        recPurchrcptLn: Record "Purch. Rcpt. Line";
                    begin
                        TestField(Received);

                        recPurchrcptLn.Reset();
                        recPurchrcptLn.SetRange("Rcpt No.", "Receipt No.");
                        recPurchrcptLn.SetRange("Rcpt Line No.", "Line No.");
                        if recPurchrcptLn.FindSet() then begin
                            PAGE.RunModal(528, recPurchrcptLn);
                        end;
                    end;
                }
            }
        }
    }
}

