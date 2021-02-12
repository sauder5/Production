pageextension 64304 IWXIventoryCountCardExt extends "IWX Inventory Count Card"
{
    layout
    {

    }

    actions
    {
        addafter(acInventoryCountSheets)
        {
            action("Rupp Inventory Count Sheets")
            {
                Promoted = true;
                PromotedCategory = Report;
                Image = Report;
                trigger OnAction()
                var
                    lrecCountCfg: Record "IWX Count Sheet Configuration";
                begin
                    lrecCountCfg.SetRange("Count No.", "No.");
                    Report.RunModal(Report::"Rupp Inventory Count Sheets", True, True, lrecCountCfg);
                end;
            }
        }
    }
}