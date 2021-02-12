pageextension 60048 SalesOrdersExt extends "Sales Orders"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Name"; recCustomer.Name)
            {
                applicationarea = all;
            }
        }
        addafter("Line Discount %")
        {
            field("Order Date"; recSalesHeader."Order Date")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }

    var
        recCustomer: Record Customer;
        recSalesHeader: Record "Sales Header";

    trigger OnAfterGetRecord()
    begin
        IF NOT recCustomer.GET("Sell-to Customer No.") THEN
            CLEAR(recCustomer);

        IF NOT recSalesHeader.GET("Document Type", "Document No.") THEN
            CLEAR(recSalesHeader);
    end;
}