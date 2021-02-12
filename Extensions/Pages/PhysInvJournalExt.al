pageextension 60392 PhysInvJournalExt extends "Phys. Inventory Journal"
{
    layout
    {
        addbefore("Posting Date")
        {
            field("Generic Name Code"; "Generic Name Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Phys. In&ventory Ledger Entries")
        {
            action("Dup. Doc. Number")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    SetFilter("Journal Batch Name", "Journal Batch Name");
                    ModifyAll("Document No.", "Document No.");
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Phys. Inventory" := true;
    end;
}