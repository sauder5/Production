pageextension 65768 WarehouseReceiptExt extends "Warehouse Receipt"
{
    layout
    {

    }

    actions
    {
        modify("Post Receipt")
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            begin
                sOrder := "No.";
            end;

            trigger OnAfterAction()
            begin
                if get(sOrder) then
                    bDelete := Delete(true);
            end;
        }
        modify("Post and &Print")
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            begin
                sOrder := "No.";
            end;

            trigger OnAfterAction()
            begin
                if get(sOrder) then
                    bDelete := Delete(true);
            end;
        }
        modify("Post and Print P&ut-away")
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            begin
                sOrder := "No.";
            end;

            trigger OnAfterAction()
            begin
                if get(sOrder) then
                    bDelete := Delete(true);
            end;
        }
    }

    var
        sOrder: Text;
        bDelete: Boolean;
}