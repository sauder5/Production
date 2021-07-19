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
        addafter(Description)
        {
            field("Rupp Description"; "Rupp Description")
            {
                caption = 'Rupp Description';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}