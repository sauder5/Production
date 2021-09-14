query 50018 ProductsAPI
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'products';
    APIVersion = 'beta';
    EntityName = 'product';
    EntitySetName = 'products';
    TopNumberOfRows = 100;

    elements
    {
        dataitem(Product; Product)
        {
            column(productCode; Code)
            {
                Caption = 'Product Code', Locked = true;
            }
            column(productDescription; Description)
            {
                Caption = 'Product Description', Locked = true;
            }
            column(genericNameCode; "Generic Name Code")
            {
                Caption = 'Generic Name Code', Locked = true;
            }
            column(treatmentCode; "Treatment Code")
            {
                Caption = 'Treatment Code', Locked = true;
            }
            column(inventoryStatusCode; "Inventory Status Code")
            {
                Caption = 'Inventory Status Code', Locked = true;
            }
            column(inventoryStatusModifiedDate; "Inventory Status Modified Date")
            {
                Caption = 'Inventory Status Modified Date', Locked = true;
            }
            dataitem(ruppReasonCode; "Rupp Reason Code")
            {
                DataItemLink = "Code" = Product."Inventory Status Code";
                SqlJoinType = LeftOuterJoin;
                DataItemTableFilter = Type = Filter("Inventory Status");
                column(inventoryStatusCodeDescription; Description)
                {
                    Caption = 'Inventory Status Code Description', Locked = true;
                }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}