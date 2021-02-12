pageextension 60255 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("Fall Amount"; "Fall Amount")
            {
                applicationarea = all;
            }
            field("Spring Amount"; "Spring Amount")
            {
                applicationarea = all;
            }
            field("Seasonal Discount"; "Seasonal Discount")
            {
                applicationarea = all;
            }
            field("Potential Amount"; "Potential Amount")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}