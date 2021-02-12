pageextension 60032 ItemLookupExt extends "Item Lookup"
{
    layout
    {
        addafter("Unit Price")
        {
            field(Inventory; Inventory) { ApplicationArea = all; }
        }
    }

    actions
    {
    }
}