pageextension 69109 ItemWarehouseFBExt extends "Item Warehouse Factbox"
{
    layout
    {
        addafter("Warehouse Class Code")
        {
            group("UOM Quantities")
            {
                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                }
                field("Qty. on Pick"; "Qty. on Pick")
                {
                    ApplicationArea = all;
                }
                field("Qty. Available to Pick"; "Qty. Available to Pick")
                {
                    ApplicationArea = all;
                }
                field("Qty. Available to Sell"; "Qty. Available to Sell")
                {
                    ApplicationArea = all;
                }
                field("Qty. in Common UOM"; "Qty. in Common UOM")
                {
                    ApplicationArea = all;
                }
                field("Qty. in Lowest UOM"; "Qty. in Lowest UOM")
                {
                    ApplicationArea = all;
                }
                field("Qty. per Lowest UOM"; "Qty. per Lowest UOM")
                {
                    ApplicationArea = all;
                }
                field("Product Qty. in Base UOM"; "Product Qty. in Base UOM")
                {
                    ApplicationArea = all;
                }
                field("Qty. can be Produced"; "Qty. can be Produced")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateCalculatedQuantities();
    end;
}