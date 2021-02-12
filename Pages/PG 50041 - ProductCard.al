page 50041 "Product Card"
{
    // //SOC-SC 08-10-15
    //   Made "Code" field editable

    PageType = Card;
    SourceTable = Product;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Variety Code"; "Variety Code")
                {
                }
                field("Treatment Code"; "Treatment Code")
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field(Maturity; Maturity)
                {
                }
                field("Item Group Code"; "Item Group Code")
                {
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Seasonal Cash Disc Code"; "Seasonal Cash Disc Code")
                {
                }
                field("Checkoff %"; "Checkoff %")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Sale Item"; "Sale Item")
                {
                }
                field("Purchase Item"; "Purchase Item")
                {
                }
                field("Shipping On Hold"; "Shipping On Hold")
                {
                }
            }
            group("Quantity & Units of Measure")
            {
                Caption = 'Quantity & Units of Measure';
                field("Lowest UOM Code"; "Lowest UOM Code")
                {
                }
                field("Common UOM Code"; "Common UOM Code")
                {
                }
                field("LowestUOM Qty. per CommonUOM"; "LowestUOM Qty. per CommonUOM")
                {
                }
                field("Qty. on Hand in Lowest UOM"; "Qty. on Hand in Lowest UOM")
                {
                }
                field("Qty. on Hand"; "Qty. on Hand")
                {
                }
                field("Qty. on Purchase Orders"; "Qty. on Purchase Orders")
                {
                }
                field("Qty. on Sales Orders"; "Qty. on Sales Orders")
                {
                }
                field("Qty. Available"; "Qty. Available")
                {
                }
            }
            group("Item-related")
            {
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Rupp Product Group Code")
                {
                    Caption = 'Product Group Code';
                    TableRelation = "Rupp Product Group"."Rupp Product Group Code";
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Editable = false;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    Editable = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Editable = false;
                }
                field("Costing Method"; "Costing Method")
                {
                    Editable = false;
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                    Editable = false;
                }
                field("Inventory Status Code"; "Inventory Status Code")
                {
                }
                field("Inventory Status Modified Date"; "Inventory Status Modified Date")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Editable = false;
                }
                field("Item Tracking Code"; "Item Tracking Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Items)
            {
                RunObject = Page "Item List";
                RunPageLink = "Product Code" = FIELD (Code);
            }
            action("Seasonal Discounts")
            {
                RunObject = Page "Seasonal Cash Discounts";
                RunPageLink = Code = FIELD (Code);
            }
        }
        area(processing)
        {
            action("Create New Items")
            {
                Image = NewItem;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PMMgt: Codeunit "Product Management";
                begin
                    PMMgt.OpenItemCreationWksh(Code); //SOC-SC 08-23-14
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        UpdateCalculatedQuantities();   //SOC-MA 09-09-14
        Commit;
    end;
}

