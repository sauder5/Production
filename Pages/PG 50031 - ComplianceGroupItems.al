page 50031 "Compliance Group Items"
{
    PageType = List;
    SourceTable = "Compliance Group Product Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Waiver Code"; "Waiver Code")
                {
                    Editable = false;
                }
                field("Product Code"; "Product Code")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field(gsItemDesc; gsItemDesc)
                {
                    Editable = false;
                }
                field("License Required"; "License Required")
                {
                }
                field("Liability Waiver Required"; "Liability Waiver Required")
                {
                }
                field("Quality Release Required"; "Quality Release Required")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Compliances)
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Compliances;
                RunPageLink = "Waiver Code" = FIELD("Waiver Code");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        recItem: Record Item;
    begin
        gsItemDesc := '';
        if recItem.Get("Item No.") then begin
            gsItemDesc := recItem.Description;
        end;
    end;

    var
        gsItemDesc: Text[50];
}

