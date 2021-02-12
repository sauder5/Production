page 50074 "Order Line Seed Worksheet"
{
    PageType = List;
    SourceTable = "Order Line Seed Worksheet Line";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch No."; "Batch No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                }
                field("Pick No."; "Pick No.")
                {
                }
                field("Pick Line No."; "Pick Line No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                    Visible = false;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Visible = false;
                }
                field("Source Document"; "Source Document")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Source Line No."; "Source Line No.")
                {
                    Visible = false;
                }
                field("Source Subline No."; "Source Subline No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Product Code"; "Product Code")
                {
                    Editable = false;
                }
                field("Seed Size"; "Seed Size")
                {
                }
                field("Unit Seed Weight in g"; "Unit Seed Weight in g")
                {
                }
                field("Line Seed Weight in g"; "Line Seed Weight in g")
                {
                }
                field("Internal Lot No."; "Internal Lot No.")
                {
                }
                field("Country of Origin Code"; "Country of Origin Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Pick Lines")
            {
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Seed Summary")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RuppWhseMgt: Codeunit "Rupp Warehouse Mgt";
                begin
                    RuppWhseMgt.SeedSummaryFromSeedWksh(Rec);
                end;
            }
        }
    }
}

