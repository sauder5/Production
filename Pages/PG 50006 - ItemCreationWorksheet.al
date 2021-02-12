page 50006 "Item Creation Worksheet"
{
    // //RSI-KS 10-13-15
    //   Remove package size from item description

    DelayedInsert = true;
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Creation Pkg Size";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(ProductCode; gsProductCode)
            {
                Caption = 'Product Code';
                DrillDown = true;
                DrillDownPageID = Products;
                Lookup = true;
                LookupPageID = Products;
                TableRelation = Product;

                trigger OnLookup(var Text: Text): Boolean
                var
                    recProduct: Record Product;
                begin
                    if PAGE.RunModal(50000, recProduct) = ACTION::LookupOK then begin
                        gsProductCode := recProduct.Code;
                        gsProductDescription := recProduct.Description;
                    end else begin
                        gsProductCode := '';
                        gsProductDescription := '';
                    end;
                    ValidateProductCode(gsProductCode);
                    /*
                    MODIFYALL("New Item No.", '');
                    MODIFYALL("Create Item", FALSE);
                    MODIFYALL("Exceeds Item No. length", FALSE);
                    
                    CurrPage.SAVERECORD;
                    CurrPage.UPDATE(FALSE);
                    */

                end;

                trigger OnValidate()
                var
                    recProduct: Record Product;
                begin
                    /*IF gsProductCode <> '' THEN BEGIN
                      recProduct.GET(gsProductCode);
                      gsProductDescription := recProduct.Description;
                    END ELSE BEGIN
                      gsProductDescription := '';
                    END;
                    
                    MODIFYALL("New Item No.", '');
                    MODIFYALL("Create Item", FALSE);
                    MODIFYALL("Exceeds Item No. length", FALSE);
                    
                    CurrPage.SAVERECORD;
                    CurrPage.UPDATE(FALSE);
                    */
                    ValidateProductCode(gsProductCode);

                end;
            }
            field(gsProductDescription; gsProductDescription)
            {
                Caption = 'Product Descripion';
                Editable = false;
                QuickEntry = false;
            }
            repeater(Group)
            {
                field("Package Size"; "Package Size")
                {
                }
                field("Pkg Size Abbr"; "Pkg Size Abbr")
                {
                }
                field("Lowest UOM"; "Lowest UOM")
                {
                }
                field("Common UOM"; "Common UOM")
                {
                }
                field("Qty. per LUOM"; "Qty. per LUOM")
                {
                }
                field("Qty. per CUOM"; "Qty. per CUOM")
                {
                }
                field("New Item No."; "New Item No.")
                {
                    Editable = false;
                    HideValue = "Create Item" = FALSE;
                }
                field("Exceeds Item No. length"; "Exceeds Item No. length")
                {
                }
                field("Item Exists"; "Item Exists")
                {
                }
                field("Create Item"; "Create Item")
                {

                    trigger OnValidate()
                    begin
                        if gsProductCode = '' then
                            Error('Please specify Product Code');

                        /*IF gsTreatment = '' THEN
                          ERROR('Please specify Treatment Code');
                        *///SOC-SC

                        UpdateLines();

                        //"Product Code" := gsProductCode;
                        //"Product Description" := gsProductDescription;

                        CurrPage.SaveRecord;
                        CurrPage.Update(false);

                    end;
                }
                field("Product Code"; "Product Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Include Seed Size"; "Include Seed Size")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Items")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PMgt: Codeunit "Product Management";
                    iCnt: Integer;
                begin
                    iCnt := PMgt.CreateNewItems(Rec);
                    if iCnt > 0 then begin
                        Commit;
                        Message('Created %1 items', iCnt);
                    end;
                    //FINDSET();
                end;
            }
        }
        area(navigation)
        {
            action(Items)
            {

                trigger OnAction()
                var
                    recItem: Record Item;
                begin
                    if gsProductCode <> '' then begin
                        recItem.Reset();
                        recItem.SetRange("Product Code", gsProductCode);
                        if recItem.FindSet() then begin
                            PAGE.Run(0, recItem);
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //MESSAGE('gsProductCode is %1', gsProductCode);
    end;

    trigger OnInit()
    var
        recItemCreationPkgSz: Record "Item Creation Pkg Size";
    begin
        giMaxItemNoLength := 20;

        recItemCreationPkgSz.Reset();
        if recItemCreationPkgSz.FindSet() then begin
            repeat
                Init();
                TransferFields(recItemCreationPkgSz);
                Insert();
            until recItemCreationPkgSz.Next = 0;
            FindSet();
        end;
    end;

    trigger OnOpenPage()
    begin
        if gsProductCode <> '' then
            ValidateProductCode(gsProductCode);

        FilterGroup(2);
        SetFilter("Qty. per LUOM", '>%1', 0);
        SetFilter("Qty. per CUOM", '>%1', 0);
        SetFilter("Lowest UOM", '>%1', '');
        SetFilter("Common UOM", '>%1', '');
        FilterGroup(0);
    end;

    var
        gsProductCode: Code[17];
        gsProductDescription: Text[30];
        giMaxItemNoLength: Integer;
        ItemAttr: Record "Product Attribute";
        recItem: Record Item;
        gsItem: Text;
        "Variety Code": Code[20];
        "Treatment Code": Code[20];
        IsCorn: Boolean;
        ProductTypeCode: Text[20];

    [Scope('Internal')]
    procedure UpdateLines()
    var
        ProdMgt: Codeunit "Product Management";
        recProduct: Record Product;
    begin
        "Product Code" := gsProductCode;
        "Product Description" := gsProductDescription;

        // TAE - Begin Change
        recProduct.Get(gsProductCode);
        "Variety Code" := recProduct."Variety Code";
        "Treatment Code" := recProduct."Treatment Code";

        IsCorn := false;
        ProductTypeCode := DelStr("Product Code", 3);
        if ProductTypeCode = 'GC' then begin
            IsCorn := true;
        end else begin
            IsCorn := false;
        end;

        if "Include Seed Size" then begin
            if IsCorn then begin
                "New Item No." := "Variety Code" + '.' + 'XXX' + '.' + "Treatment Code" + '.' + "Pkg Size Abbr";
            end else begin
                "New Item No." := "Product Code" + '.' + "Pkg Size Abbr";
            end;
        end else begin
            "New Item No." := "Product Code" + '.' + "Pkg Size Abbr";
        end;
        // TAE - End Change

        Description := "Product Description";
        "Exceeds Item No. length" := (StrLen("New Item No.") > giMaxItemNoLength);

        recProduct.Get(gsProductCode);
        "Item Template Code" := recProduct."Item Template Code";
        CalcFields("Item Exists");
    end;

    [Scope('Internal')]
    procedure SetProductCode(ProductCode: Code[20])
    begin
        gsProductCode := ProductCode;
    end;

    [Scope('Internal')]
    procedure ValidateProductCode(ProductCode: Code[20])
    var
        recProduct: Record Product;
    begin
        if ProductCode <> '' then begin
            recProduct.Get(ProductCode);
            gsProductDescription := recProduct.Description;

            Reset();
            if FindSet() then begin
                repeat
                    // TAE - Begin Change
                    recProduct.Get(gsProductCode);
                    "Variety Code" := recProduct."Variety Code";
                    "Treatment Code" := recProduct."Treatment Code";

                    IsCorn := false;
                    ProductTypeCode := DelStr("Product Code", 3);
                    if ProductTypeCode = 'GC' then begin
                        IsCorn := true;
                    end else begin
                        IsCorn := false;
                    end;

                    if "Include Seed Size" then begin
                        if IsCorn then begin
                            "New Item No." := "Variety Code" + '.' + 'XXX' + '.' + "Treatment Code" + '.' + "Pkg Size Abbr";
                        end else begin
                            "New Item No." := "Product Code" + '.' + "Pkg Size Abbr";
                        end;
                    end else begin
                        "New Item No." := "Product Code" + '.' + "Pkg Size Abbr";
                    end;
                    // TAE - End Change

                    Modify();
                until Next = 0;
                FindSet();
            end;

        end else begin
            gsProductDescription := '';
        end;

        if ItemAttr.Get(ItemAttr."Attribute Type"::Treatment, recProduct."Treatment Code") then
            gsProductDescription := CopyStr(gsProductDescription + ', ' + ItemAttr.Description, 1, 30);

        //MODIFYALL("New Item No.", '');
        ModifyAll("Create Item", false);
        ModifyAll("Exceeds Item No. length", false);

        CurrPage.SaveRecord;
        CurrPage.Update(false);
    end;
}

