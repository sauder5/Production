pageextension 60031 ItemListExt extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("Generic Name Code"; "Generic Name Code")
            {
                applicationarea = all;
            }
        }
        addafter(Type)
        {
            field("Product Code"; "Product Code")
            {
                applicationarea = all;
            }
            field("Product Qty. in Lowest UOM"; GetProductQtyInLowestUOM())
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    cduProdMgt.ItemProductQtyOnDrillDown(Rec);
                end;
            }
            field("Product Qty. in Common UOM"; GetProductQtyInCommonUOM())
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    cduProdMgt.ItemProductQtyOnDrillDown(Rec);
                end;
            }
            field("Product Qty. in Base UOM"; "Product Qty. in Base UOM")
            {
                applicationarea = all;
            }
            field("Qty. Available to Pick"; "Qty. Available to Pick")
            {
                applicationarea = all;
            }
            field("Qty. Available to Sell"; "Qty. Available to Sell")
            {
                applicationarea = all;
            }
            field("Qty. on Sales Order"; "Qty. on Sales Order")
            {
                applicationarea = all;
            }
            field("Qty On PO"; "Qty On PO")
            {
                applicationarea = all;
            }
            field("Qty. on Consumption"; "Qty. on Consumption")
            {
                applicationarea = all;
            }
            field("Qty. can be Produced"; "Qty. can be Produced")
            {
                applicationarea = all;
            }
            field("Qty. on Pick"; "Qty. on Pick")
            {
                applicationarea = all;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                applicationarea = all;
            }
            field("Inventory Status Code"; "Inventory Status Code")
            {
                applicationarea = all;
            }
            field("Vendor Name"; recVendor.Name)
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
        addafter("C&alculate Counting Period")
        {
            action("Copy Item")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    CODEUNIT.RUN(CODEUNIT::"Copy Item", Rec);
                end;
            }
        }
        addafter(ApplyTemplate)
        {
            action("Cancel - Substitute")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    page.run(Page::"Inventory Status Change -Item", Rec);
                end;
            }
        }
        modify(Prices)
        {
            Caption = 'Sales Prices';
        }
    }

    var
        recVendor: Record Vendor;
        cduProdMgt: Codeunit "Product Management";

    trigger OnAfterGetRecord()
    begin
        UpdateCalculatedQuantities();
        if not recVendor.get("Vendor No.") then
            Clear(recVendor);
    end;
}