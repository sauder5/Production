report 50060 "Update Product Availability"
{
    DefaultLayout = RDLC;
    Caption = 'Update Product Availability';
    UsageCategory = ReportsAndAnalysis;
    //ProcessingOnly = true;
    RDLCLayout = './Reports/RDLC/ProductAvailability.rdlc';

    dataset
    {
        dataitem(Product; Product)
        {
            column(Code; Code)
            {
                Caption = 'Product Code';
            }
            column(Qty__Available; gdBeforeAvail)
            {
            }
            column(gdAvailqty; gdAvailqty)
            {
                Caption = 'Calculated Avl Qty';
            }
            trigger OnAfterGetRecord()
            var
                ProductMgt: Codeunit "Product Management";
            begin
                gdBeforeAvail := "Qty. Available";
                gdAvailqty := ProductMgt.GetProductQuantityAvailableInCommonUOM(Product);
                validate("Qty. Available", gdAvailqty);
                Modify();
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }
    var
        gdAvailqty: Decimal;
        gdBeforeAvail: Decimal;
}