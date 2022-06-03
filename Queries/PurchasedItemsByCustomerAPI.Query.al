query 50022 PurchasedItemsByCustomerAPI
{
    APIGroup = 'items';
    APIPublisher = 'rupp';
    APIVersion = 'beta';
    EntityName = 'purchasedItem';
    EntitySetName = 'purchasedItems';
    QueryType = API;

    elements
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(InvoiceNo; "No.")
            {
                Caption = 'Invoice No.', Locked = true;
            }
            column(SellToCustomerNo; "Sell-to Customer No.")
            {
                Caption = 'Sell-to Customer No.', Locked = true;
            }
            column(OrderNo; "Order No.")
            {
                Caption = 'Order No.', Locked = true;
            }
            column(OrderDate; "Order Date")
            {
                Caption = 'Order Date', Locked = true;
            }
            column(PostingDate; "Posting Date")
            {
                Caption = 'Posting Date', Locked = true;
            }
            column(SellToCustomerName; "Sell-to Customer Name")
            {
                Caption = 'Sell-to Customer Name', Locked = true;
            }
            column(OrderCreatedDateTime; "Order Created Date Time")
            {
                Caption = 'Order Created DateTime', Locked = true;
            }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = SalesInvoiceHeader."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Type" = filter(Item), Quantity = filter(<> 0);
                column(LineNo; "Line No.")
                {
                    Caption = 'Line No.', Locked = true;
                }
                column(ItemNo; "No.")
                {
                    Caption = 'Item No.', Locked = true;
                }
                column(ItemDescription; Description)
                {
                    Caption = 'Item Description', Locked = true;
                }
                column(Quantity; Quantity)
                {
                    Caption = 'Quantity', Locked = true;
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                    Caption = 'Unit of Measure', Locked = true;
                }
                column(UnitOfMeasureCode; "Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code', Locked = true;
                }
                column(LineType; "Type")
                {
                    Caption = 'Line Type', Locked = true;
                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = SalesInvoiceLine."No.";
                    SqlJoinType = LeftOuterJoin;

                    column(RuppProductGroupCode; "Rupp Product Group Code")
                    {
                        Caption = 'Product Group Code', Locked = true;
                    }

                    dataitem(RuppProductGroup; "Rupp Product Group")
                    {
                        DataItemLink = "Rupp Product Group Code" = Item."Rupp Product Group Code";
                        SqlJoinType = LeftOuterJoin;

                        column(RuppProductGroupDescription; Description)
                        {
                            Caption = 'Product Group Description', Locked = true;
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