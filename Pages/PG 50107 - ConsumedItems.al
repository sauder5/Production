page 50107 "Consumed Items"
{
    Caption = 'Consumed Items';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Consumed Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = "Tracking Enabled";
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
    begin
        //ToCheck
        /*
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT AssemblyLineReserve.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          AssemblyLineReserve.DeleteLine(Rec);
        END;
        */

    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

