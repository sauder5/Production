page 50018 "Purchase Contract Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Purchase Contract Line";
    SourceTableView = WHERE ("Transaction Type" = CONST (Settlement));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                    Visible = false;
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Settlement Unit Cost"; "Settlement Unit Cost")
                {
                }
                field("Settlement Line Amount"; "Settlement Line Amount")
                {
                }
                field("Post Invoice to Pay"; "Post Invoice to Pay")
                {
                    Enabled = gbAllowSettlement;
                }
                field("Invoice %"; "Invoice %")
                {
                }
                field("Settlement Invoiced"; "Settlement Invoiced")
                {
                    Editable = false;
                }
                field("Check-off %"; "Check-off %")
                {
                    Visible = false;
                }
                field("Recd/Settled Qty. Invoiced"; "Recd/Settled Qty. Invoiced")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Recd/Settled Qty. Not Invoiced"; "Recd/Settled Qty. Not Invoiced")
                {
                    Visible = false;
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Lines)
            {
                action("Invoice Lines")
                {
                    RunObject = Page "Purchase Contract Lines";
                    RunPageLink = "Contract No." = FIELD ("Contract No."),
                                  "Transaction Type" = FILTER (Invoice),
                                  "Settled Line No." = FIELD ("Line No.");
                }
            }
        }
    }

    var
        gbAllowSettlement: Boolean;

    [Scope('Internal')]
    procedure AllowSettlement(bAllow: Boolean)
    begin
        if gbAllowSettlement <> bAllow then begin
            gbAllowSettlement := bAllow;
            CurrPage.Update();
        end;
    end;
}

