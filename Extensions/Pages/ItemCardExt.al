pageextension 60030 ItemCardExt extends "Item Card"
{
    layout
    {
        addafter(InventoryGrp)
        {
            group("Rupp Seed - Specific")
            {
                field("Product Code"; "Product Code")
                {
                    applicationarea = all;
                    TableRelation = Product.Code;
                }
                field("Generic Name Code"; "Generic Name Code")
                {
                    applicationarea = all;
                }
                field("Inventory Status Code"; "Inventory Status Code")
                {
                    applicationarea = all;
                }
                field("Inventory Status Modified Date"; "Inventory Status Modified Date")
                {
                    applicationarea = all;
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                    applicationarea = all;
                }
                field("Checkoff %"; "Checkoff %")
                {
                    applicationarea = all;
                }
                field("Qty. in Lowest UOM"; "Qty. in Lowest UOM")
                {
                    applicationarea = all;
                }
                field("Qty. in Common UOM"; "Qty. in Common UOM")
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
                field("Qty. can be Produced"; "Qty. can be Produced")
                {
                    applicationarea = all;
                }
                field("Qty. on Pick"; "Qty. on Pick")
                {
                    applicationarea = all;
                }
                field("Qty. Available to Pick"; "Qty. Available to Pick")
                {
                    applicationarea = all;
                }
                field("Shipping On Hold"; "Shipping on Hold")
                {
                    applicationarea = all;
                }
            }
        }
        addafter("Country/Region of Origin Code")
        {
            field("Schedule B Code"; "Schedule B Code")
            {
                applicationarea = all;
            }
        }
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                applicationarea = all;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Name"; gsVendorName)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Item Category Code")
        {
            field("Rupp Product Group"; "Rupp Product Group Code")
            {
                ApplicationArea = all;
                Caption = 'Product Group Code';
            }
        }
    }

    actions
    {
        addafter(CalculateCountingPeriod)
        {
            action("Create New Items")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    cduProdMgt.OpenItemCreationWksh("Product Code");
                end;
            }
        }
        addafter(Availability)
        {
            action("Product Availability")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    recItem: Record Item;
                    pgProdAvail: Page "Product Availability";
                begin
                    //SOC-SC 05-10-15
                    recItem.RESET();
                    recItem.SETRANGE("Product Code", "Product Code");
                    recItem.FINDSET();
                    pgProdAvail.RunModal();
                end;
            }
        }
        addafter(SaveAsTemplate)
        {
            action("Copy from Existing Item")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    recILE: Record "Item Ledger Entry";
                    recItem: Record Item;
                    recFromItemUOM: Record "Item Unit of Measure";
                    recItemUOM: Record "Item Unit of Measure";
                begin
                    //SOC-SC 05-10-15
                    recILE.RESET();
                    recILE.SETRANGE("Item No.", "No.");
                    IF recILE.FINDFIRST() THEN
                        ERROR('Item %1 has Ledger Entries. Hence you cannot copy from another item', "No.");

                    CALCFIELDS("Qty. on Purch. Order", "Qty. on Sales Order", "Qty. on Component Lines");
                    TESTFIELD("Qty. on Purch. Order", 0);
                    TESTFIELD("Qty. on Sales Order", 0);
                    TESTFIELD("Qty. on Component Lines", 0);
                    TESTFIELD("Base Unit of Measure", '');


                    recItem.RESET();
                    recItem.SETFILTER("No.", '<>%1', "No.");
                    recItem.FINDSET();
                    IF PAGE.RUNMODAL(31, recItem) = ACTION::LookupOK THEN BEGIN
                        IF CONFIRM('This will replace all the fields on the item %1 with the selected Item %2. Are you sure?', FALSE, "No.", recItem."No.") THEN BEGIN
                            recFromItemUOM.GET(recItem."No.", recItem."Base Unit of Measure");
                            recItem.TESTFIELD("Base Unit of Measure");

                            recItemUOM.RESET();
                            recItemUOM.SETRANGE("Item No.", "No.");
                            IF recItemUOM.FINDSET() THEN BEGIN
                                recItemUOM.DELETEALL();
                            END;
                            recItemUOM.INIT();
                            recItemUOM.VALIDATE("Item No.", "No.");
                            recItemUOM.VALIDATE(Code, recFromItemUOM.Code);
                            recItemUOM.TRANSFERFIELDS(recFromItemUOM, FALSE);
                            recItemUOM.INSERT();

                            TRANSFERFIELDS(recItem, FALSE);
                            //RSI-KS 03-08-2018 Force check of Division code
                            VALIDATE("Global Dimension 2 Code", recItem."Global Dimension 2 Code");

                            MESSAGE('Fields are replaced in Item %1 from Item %2', "No.", recItem."No.");
                        END;
                    END;
                end;
            }
        }
        addafter("Return Orders")
        {
            action("Item Discount Calculator")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    pgItemDiscCalc: Page "Item Discount Calculator";
                begin
                    pgItemDiscCalc.SetValues('', '', '', '', "No.", '', '', '', WorkDate(), '');
                    pgItemDiscCalc.Run();
                end;
            }
            action("Compliance Groups")
            {
                ApplicationArea = all;
                RunObject = page "Compliance Group Items";
                RunPageLink = "Item No." = field ("No.");
            }
            action("Geographical Restrictions")
            {
                ApplicationArea = all;
                RunObject = page "Geographical Restrictions";
                RunPageLink = "Item No." = field ("No.");
            }
        }
        addafter("Prepa&yment Percentages")
        {
            action("Quality Premium List")
            {
                ApplicationArea = all;
                RunObject = page "Quality Premium List";
                RunPageLink = Code = field ("Quality Premium Code");
            }
        }
    }

    var
        recVendor: Record Vendor;
        gsVendorName: Text[50];
        cduProdMgt: Codeunit "Product Management";

    trigger OnAfterGetRecord()
    begin
        gsVendorName := getVendor();
    end;

    local procedure getVendor() retVendorName: Text[50]
    begin
        retVendorName := '';
        if recVendor.Get("Vendor No.") then
            retVendorName := recVendor.Name;
    end;
}