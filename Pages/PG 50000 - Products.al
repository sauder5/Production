page 50000 Products
{
    CardPageID = "Product Card";
    Editable = false;
    PageType = List;
    SourceTable = Product;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                }
                field(Maturity; Maturity)
                {
                }
                field("Treatment Code"; "Treatment Code")
                {
                }
                field("Item Group Code"; "Item Group Code")
                {
                }
                field("Variety Code"; "Variety Code")
                {
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Item Template Code"; "Item Template Code")
                {
                }
                field("Seasonal Cash Disc Code"; "Seasonal Cash Disc Code")
                {
                }
                field("Planting Season"; "Planting Season")
                {
                }
                field("Date Filter"; "Date Filter")
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
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Lowest UOM Code"; "Lowest UOM Code")
                {
                    Visible = false;
                }
                field("Common UOM Code"; "Common UOM Code")
                {
                    Visible = false;
                }
                field("LowestUOM Qty. per CommonUOM"; "LowestUOM Qty. per CommonUOM")
                {
                    Visible = false;
                }
                field("Qty. on Hand in Lowest UOM"; "Qty. on Hand in Lowest UOM")
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Inventory Status Code"; "Inventory Status Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(General)
            {
                action(Items)
                {
                    RunObject = Page "Item List";
                    RunPageLink = "Product Code" = FIELD(Code);
                }
                action("Seasonal Discounts")
                {
                    RunObject = Page "Seasonal Cash Discounts";
                    RunPageLink = Code = FIELD("Seasonal Cash Disc Code");
                    RunPageMode = View;
                }
                action(Compliances)
                {
                    RunObject = Page "Compliance Group Items";
                    RunPageLink = "Product Code" = FIELD(Code);
                }
                group(Attributes)
                {
                    action(Varieties)
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE("Attribute Type" = CONST(Variety));
                    }
                    action(Treatments)
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE("Attribute Type" = CONST(Treatment));
                    }
                    action("Item Group")
                    {
                        RunObject = Page "Product Attributes";
                        RunPageView = WHERE("Attribute Type" = CONST("Item Group"));
                    }
                }
            }
        }
        area(processing)
        {
            action("Create New Product")
            {
                Image = NewItem;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Creation Worksheet";
            }
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
            action("Cancel-Substitute")
            {

                trigger OnAction()
                var
                    CancelSubMgt: Codeunit "Cancellation Substitution Mgt.";
                begin
                    CancelSubMgt.InventoryStatusValidateFromProduct(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ProdMgt: Codeunit "Product Management";
    begin
        "Qty. Available" := ProdMgt.GetProductQuantityAvailableInCommonUOM(Rec);
    end;

    trigger OnOpenPage()
    var
        recProduct: Record Product;
        dQtyAvail: Decimal;
        ProdMgt: Codeunit "Product Management";
        bModified: Boolean;
    begin

        //ToCheck
        //SETRANGE("Date Filter", 0D, WORKDATE);

        //recProduct.RESET();
        //IF recProduct.FINDSET() THEN BEGIN
        //  REPEAT
        //    dQtyAvail := ProdMgt.GetProductQuantityAvailableInCommonUOM(recProduct);
        //    IF recProduct."Qty. Available" <> dQtyAvail THEN BEGIN
        //      recProduct."Qty. Available" := dQtyAvail;
        //      recProduct.MODIFY();
        //      bModified := TRUE;
        //    END;
        //  UNTIL recProduct.NEXT = 0;
        //  IF bModified THEN
        //    COMMIT;
        //END;
    end;
}

