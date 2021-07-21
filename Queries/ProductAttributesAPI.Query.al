// Added by TAE 2021-07-20 to support the online customer center and ordering
query 50014 "ProductAttributesAPI"
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'attributes';
    APIVersion = 'beta';
    EntityName = 'productAttribute';
    EntitySetName = 'productAttributes';
    TopNumberOfRows = 300;
    OrderBy = ascending(attributeCode);

    elements
    {
        dataitem(ProductAttributes; "Product Attribute")
        {
            DataItemTableFilter = "Attribute Type" = filter('Treatment');
            column(attributeType; "Attribute Type")
            {
                Caption = 'Attribute Type', Locked = true;
            }
            column(attributeCode; "Code")
            {
                Caption = 'Code', Locked = true;
            }
            column(attributeDescription; "Description")
            {
                Caption = 'Description', Locked = true;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}