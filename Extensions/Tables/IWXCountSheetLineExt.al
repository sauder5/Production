tableextension 80301 IWXCountSheetLineExt extends "IWX Count Sheet Line"
{
    fields
    {
        field(51000; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                recItem: Record Item;
            begin
                if not recItem.get("Item No.") then
                    Clear(recItem);
                "Generic Name Code" := recItem."Generic Name Code";
            end;
        }
    }
}