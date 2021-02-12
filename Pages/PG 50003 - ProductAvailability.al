page 50003 "Product Availability"
{
    // //SOC-SC 10-23-14
    //   Added columns: "Qty. Available to Sell" and "Treatment"

    CardPageID = "BC O365 Item Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Product Code"; "Product Code")
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field(Treatment; gsTreatment)
                {
                    Editable = false;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                }
                field("Qty On PO"; "Qty On PO")
                {
                }
                field("Trans. Ord. Shipment (Qty.)"; "Trans. Ord. Shipment (Qty.)")
                {
                }
                field("Qty. on Asm. Component"; "Qty. on Asm. Component")
                {
                    Visible = false;
                }
                field("Qty. Available to Sell"; "Qty. Available to Sell")
                {
                }
                field("Qty. on Pick"; "Qty. on Pick")
                {
                }
                field("Qty. Available to Pick"; "Qty. Available to Pick")
                {
                }
                field("Qty. on Consumption"; "Qty. on Consumption")
                {
                }
                field("Product Qty. in Base UOM"; "Product Qty. in Base UOM")
                {
                }
                field("Product Qty. in Lowest UOM"; "Product Qty. in Lowest UOM")
                {
                    Visible = false;
                }
                field("Product Qty. in Common UOM"; "Product Qty. in Common UOM")
                {
                }
                field("Inventory Status Code"; "Inventory Status Code")
                {
                }
                field("Inventory Status Modified Date"; "Inventory Status Modified Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        PMMgt: Codeunit "Product Management";
    begin

        UpdateCalculatedQuantities();    //SOC-MA 09-09-14

        //PMMgt.GetAvailQty(Rec, "Product Qty. in Base UOM", "Product Qty. in Common UOM");
        GetTreatment(gsTreatment); //SOC-SC 10-23-14
    end;

    var
        gsTreatment: Code[20];

    [Scope('Internal')]
    procedure GetTreatment(var retTreatmentCode: Code[20])
    var
        recProduct: Record Product;
    begin
        retTreatmentCode := '';
        if recProduct.Get("Product Code") then begin
            retTreatmentCode := recProduct."Treatment Code";
        end;
    end;
}

