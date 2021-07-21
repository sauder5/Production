// Added by TAE 2021-07-20 to support the online customer center and ordering
query 50010 "ItemsByProductAPI"
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'items';
    APIVersion = 'beta';
    EntityName = 'availableItem';
    EntitySetName = 'availableItems';

    TopNumberOfRows = 400;
    OrderBy = ascending(treatmentCode, priceUnitPrice);

    elements
    {
        dataitem(PriceTable; "Sales Price")
        {
            DataItemTableFilter = "Minimum Quantity" = filter(= 1), "Unit Price" = filter(<> 0), "Ending Date" = filter(= '');
            column(priceItemNumber; "Item No.")
            {
                Caption = 'Item No.', Locked = true;
            }
            column(priceSalesType; "Sales Type")
            {
                Caption = 'Sales Type', Locked = true;
            }
            column(priceSalesCode; "Sales Code")
            {
                Caption = 'Sales Code', Locked = true;
            }
            column(priceStartDate; "Starting Date")
            {
                Caption = 'Price Start Date', Locked = true;
            }
            column(priceEndDate; "Ending Date")
            {
                Caption = 'Price End Date', Locked = true;
            }
            column(priceUOMCode; "Unit of Measure Code")
            {
                Caption = 'UOM Code', Locked = true;
            }
            column(priceMinimumQuantity; "Minimum Quantity")
            {
                Caption = 'Minimum Quantity', Locked = true;
            }
            column(priceUnitPrice; "Unit Price")
            {
                Caption = 'Unit Price', Locked = true;
            }
            dataitem(ItemTable; Item)
            {
                DataItemLink = "No." = PriceTable."Item No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Blocked = filter(= 0), "Sales Blocked" = filter(= 0);
                column("itemNumber"; "No.")
                {
                    Caption = 'No', Locked = true;
                }
                column(itemDescription; Description)
                {
                    Caption = 'Description', Locked = true;
                }
                column(itemBaseUOM; "Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure', Locked = true;
                }
                column(itemBlocked; Blocked)
                {
                    Caption = 'Blocked', Locked = true;
                }
                column(itemSalesUnitOfMeasure; "Sales Unit of Measure")
                {
                    Caption = 'Sales UOM', Locked = true;
                }
                column(itemCategoryCode; "Item Category Code")
                {
                    Caption = 'Item Category Code', Locked = true;
                }
                column(itemSalesBlocked; "Sales Blocked")
                {
                    Caption = 'Sales Blocked', Locked = true;
                }
                column(productCode; "Product Code")
                {
                    Caption = 'Product Code', Locked = true;
                }
                column(inventoryStatusCode; "Inventory Status Code")
                {
                    Caption = 'Inventory Status Code', Locked = true;
                }
                column(inventoryStatusModifiedDate; "Inventory Status Modified Date")
                {
                    Caption = 'Inventory Status Modified Date', Locked = true;
                }
                dataitem(Product; "Product")
                {
                    DataItemLink = "Code" = ItemTable."Product Code";
                    SqlJoinType = LeftOuterJoin;
                    column(treatmentCode; "Treatment Code")
                    {
                        Caption = 'Treatment Code', Locked = true;
                    }
                    column(ruppProductGroupCode; "Rupp Product Group Code")
                    {
                        Caption = 'Rupp Product Group Code', Locked = true;
                    }
                    dataitem(ProductAttribute; "Product Attribute")
                    {
                        DataItemLink = "Code" = Product."Treatment Code";
                        SqlJoinType = LeftOuterJoin;
                        column(attributeType; "Attribute Type")
                        {
                            Caption = 'Attribute Type', Locked = true;
                        }
                        column(treatmentDescription; Description)
                        {
                            Caption = 'Treatment Description', Locked = true;
                        }
                        dataitem(RuppProductGroup; "Rupp Product Group")
                        {
                            DataItemLink = "Rupp Product Group Code" = Product."Rupp Product Group Code";
                            SqlJoinType = LeftOuterJoin;
                            column(productGroupCodeDescription; Description)
                            {
                                Caption = 'Product Group Code Description', Locked = true;
                            }
                            dataitem(ruppReasonCode; "Rupp Reason Code")
                            {
                                DataItemLink = "Code" = ItemTable."Inventory Status Code";
                                SqlJoinType = LeftOuterJoin;
                                column(statusType; "Type")
                                {
                                    Caption = 'Inventory Status Type', Locked = true;
                                }
                                column(statusCode; "Code")
                                {
                                    Caption = 'Inventory Status Code', Locked = true;
                                }
                                column(statusCodeDescription; Description)
                                {
                                    Caption = 'Inventory Status Code Description', Locked = true;
                                }
                                dataitem(unitOfMeasure; "Unit of Measure")
                                {
                                    DataItemLink = "Code" = ItemTable."Sales Unit of Measure";
                                    SqlJoinType = LeftOuterJoin;
                                    column(uomCode; "Code")
                                    {
                                        Caption = 'UOM Code', Locked = true;
                                    }
                                    column(uomDescription; Description)
                                    {
                                        Caption = 'UOM Description', Locked = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}