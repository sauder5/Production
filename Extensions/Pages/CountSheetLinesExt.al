pageextension 84301 CountSheetLinesExt extends "IWX Count Sheet Lines"
{
    layout
    {
        addafter("Scanned DateTime")
        {
            field("Generic Name Code"; "Generic Name Code")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}