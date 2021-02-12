page 50109 "Work Order Item List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Work Order Items";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Number"; "Item Number")
                {
                    Editable = false;
                }
                field("Work Order No."; "Work Order No.")
                {
                    Caption = 'Work Order Num';
                    DrillDown = true;
                    DrillDownPageID = "Work Order";
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        //IF WORec.GET("Work Order No.") THEN BEGIN
                        //  WOPage.SETRECORD(WORec);
                        //  WOPage.RUN;
                        //END;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        WORec.Get("Work Order No.");
                        WOPage.SetRecord(WORec);
                        WOPage.Run;
                    end;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Consumed Quantity"; "Consumed Quantity")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Produced Quantity"; "Produced Quantity")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        WOPage: Page "Work Order";
        WORec: Record "Work Order";
}

