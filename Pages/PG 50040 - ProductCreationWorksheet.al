page 50040 "Product Creation Worksheet"
{
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(gcVarietyCode; gcVarietyCode)
            {
                Caption = 'Variety';
                Lookup = true;
                LookupPageID = "Product Attributes";

                trigger OnLookup(var Text: Text): Boolean
                var
                    recProductAttr: Record "Product Attribute";
                begin
                    recProductAttr.Reset();
                    recProductAttr.SetRange("Attribute Type", recProductAttr."Attribute Type"::Variety);
                    if recProductAttr.FindSet() then begin
                        if PAGE.RunModal(0, recProductAttr) = ACTION::LookupOK then begin
                            gcVarietyCode := recProductAttr.Code;
                            gsVarietyDesc := recProductAttr.Description;
                        end else
                            gsVarietyDesc := '';
                    end else begin
                        gsVarietyDesc := '';
                    end;

                    gcProductCode := '';
                    gsProductDesc := '';
                    gbProductExists := false;
                end;

                trigger OnValidate()
                var
                    recProductAttr: Record "Product Attribute";
                begin
                    if gcVarietyCode <> '' then begin
                        recProductAttr.Get(recProductAttr."Attribute Type"::Variety, gcVarietyCode);
                        gsVarietyDesc := recProductAttr.Description;
                    end else begin
                        gsVarietyDesc := '';
                    end;

                    gcProductCode := '';
                    gsProductDesc := '';
                    gbProductExists := false;
                end;
            }
            field(gsVarietyDesc; gsVarietyDesc)
            {
                Caption = 'Variety Description';
                Editable = false;
            }
            field(gcTreatment; gcTreatment)
            {
                Caption = 'Treatment';

                trigger OnLookup(var Text: Text): Boolean
                var
                    recProductAttr: Record "Product Attribute";
                begin
                    recProductAttr.Reset();
                    recProductAttr.SetRange("Attribute Type", recProductAttr."Attribute Type"::Treatment);
                    if recProductAttr.FindSet() then begin
                        if PAGE.RunModal(0, recProductAttr) = ACTION::LookupOK then begin
                            gcTreatment := recProductAttr.Code;
                            gsTreatmentDesc := recProductAttr.Description;
                        end else
                            gsTreatmentDesc := '';
                    end else begin
                        gsTreatmentDesc := '';
                    end;

                    gcProductCode := '';
                    gsProductDesc := '';
                    gbProductExists := false;
                end;

                trigger OnValidate()
                var
                    recProductAttr: Record "Product Attribute";
                begin
                    if gcTreatment <> '' then begin
                        recProductAttr.Get(recProductAttr."Attribute Type"::Treatment, gcTreatment);
                        gsTreatmentDesc := recProductAttr.Description;
                    end else begin
                        gsVarietyDesc := '';
                    end;

                    gcProductCode := '';
                    gsProductDesc := '';
                    gbProductExists := false;
                end;
            }
            field(gsTreatmentDesc; gsTreatmentDesc)
            {
                Caption = 'Treatment Description';
                Editable = false;
            }
            group("New Product")
            {
            }
            field(gcProductCode; gcProductCode)
            {
                Caption = 'New Product Code';
            }
            field(gsProductDesc; gsProductDesc)
            {
                Caption = 'Product Description';
            }
            field(gbProductExists; gbProductExists)
            {
                Caption = 'Product Exists';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Suggest Product")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recProduct: Record Product;
                begin
                    gcProductCode := '';
                    gsProductDesc := '';
                    gbProductExists := false;

                    if gcVarietyCode = '' then
                        Error('Please enter Variety');

                    //IF gcTreatment = '' THEN
                    //  ERROR('Please enter Treatment');

                    gcProductCode := gcVarietyCode;
                    if gcTreatment <> '' then
                        gcProductCode += '.' + gcTreatment;

                    gsProductDesc := gsVarietyDesc;
                    //IF  gsTreatmentDesc <> '' THEN
                    //  gsProductDesc += ', ' + gsTreatmentDesc;

                    if StrLen(gcProductCode) > 17 then
                        Error('Product Code exceeds 17 characters');

                    if StrLen(gsProductDesc) > 30 then
                        Error('Description exceeds 30 characters');
                end;
            }
            action("Create Product")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recProduct: Record Product;
                begin
                    if recProduct.Get(gcProductCode) then
                        gbProductExists := true
                    else
                        gbProductExists := false;

                    if gbProductExists then
                        Error('Product %1 already exists', gcProductCode);
                    if gcProductCode = '' then
                        Error('New Product Code is blank');
                    if gsProductDesc = '' then
                        Error('Product Description is blank');

                    recProduct.Init();
                    recProduct.Code := gcProductCode;
                    recProduct.Description := gsProductDesc;
                    recProduct."Treatment Code" := gcTreatment;
                    recProduct."Variety Code" := gcVarietyCode;
                    recProduct.Insert();

                    PAGE.Run(50041, recProduct);
                end;
            }
        }
        area(navigation)
        {
            action("Product Card")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recProduct: Record Product;
                begin
                    if recProduct.Get(gcProductCode) then begin
                        PAGE.RunModal(50041, recProduct);
                    end else
                        Error('Please enter a valid Product Code');
                end;
            }
        }
    }

    var
        gcVarietyCode: Code[20];
        gsVarietyDesc: Text[30];
        gcTreatment: Code[20];
        gsTreatmentDesc: Text[30];
        gcProductCode: Code[20];
        gsProductDesc: Text[60];
        gbProductExists: Boolean;
}

