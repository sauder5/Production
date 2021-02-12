page 50082 "Vegetable Label"
{
    PageType = Card;
    SourceTable = "Vegetable Label";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Item Number"; "Item Number")
                {
                }
                field("Lot Number"; "Lot Number")
                {
                }
                field("Batch Number"; "Batch Number")
                {
                }
                group(Control1000000021)
                {
                    ShowCaption = false;
                    field("Product Category"; "Product Category")
                    {
                    }
                    field("Product Name"; "Product Name")
                    {
                    }
                    field("Product Info"; "Product Info")
                    {
                    }
                    field("Net Weight Seed"; "Net Weight Seed")
                    {
                    }
                    field("Test Date"; "Test Date")
                    {
                    }
                }
                field(Germ; Germ)
                {
                }
                field(Purity; Purity)
                {
                }
                field("Inert Material"; "Inert Material")
                {
                }
                field(Origin; Origin)
                {
                }
                field(Picture; Picture)
                {
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Seeds Per Lb"; "Seeds Per Lb")
                {
                }
                field("JD Plate"; "JD Plate")
                {
                }
                field("IH Plate"; "IH Plate")
                {
                }
                group(Memo)
                {
                    field(Caution; Caution)
                    {
                        Importance = Additional;
                        MultiLine = true;
                    }
                }
            }
        }
    }

    actions
    {
    }
}

