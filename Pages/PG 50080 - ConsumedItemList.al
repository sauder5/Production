page 50080 "Consumed Item List"
{
    CardPageID = "Vegetable Label";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Consumed Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Work Order No."; "Work Order No.")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Consumed Quantity"; "Consumed Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Show Document")
                {
                    Caption = 'Show Document';

                    trigger OnAction()
                    var
                        WorkOrder: Record "Work Order";
                    begin
                        WorkOrder.Get("Work Order No.");

                        PAGE.Run(PAGE::"Work Order", WorkOrder);
                    end;
                }
            }
        }
    }
}

