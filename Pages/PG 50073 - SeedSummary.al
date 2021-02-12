page 50073 "Seed Summary"
{
    Editable = false;
    PageType = List;
    SourceTable = "Seed Summary";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Code"; "Product Code")
                {
                }
                field(Description; recProduct.Description)
                {
                    Editable = false;
                }
                field("Internal Lot No."; "Internal Lot No.")
                {
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Actual Weight in g"; "Actual Weight in g")
                {
                }
                field("GNP Required"; "GNP Required")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recProduct.SetFilter(Code, '>=%1', "Product Code");
        if not recProduct.FindFirst then
            Clear(recProduct);
    end;

    var
        gsDescription: Text[50];
        recProduct: Record Product;
}

