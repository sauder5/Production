page 50011 "Quality Premium Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "Commodity Settings Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Test Type"; "Test Type")
                {
                }
                field("From Result"; "From Result")
                {
                }
                field("To Result"; "To Result")
                {
                }
                field("Unit Amount"; "Unit Amount")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowDocument)
            {
                Caption = 'Show &Document';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                var
                    Discount: Record "Commodity Settings";
                begin
                    Discount.Get("Quality Premium Code");
                    PAGE.Run(PAGE::"Commodity Codes", Discount);
                end;
            }
        }
    }
}

