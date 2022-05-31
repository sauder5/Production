query 50022 purchasedItemsByCustomerAPI
{
    APIGroup = 'items';
    APIPublisher = 'rupp';
    APIVersion = 'beta';
    EntityName = 'purchasedItem';
    EntitySetName = 'purchasedItems';
    QueryType = API;

    elements
    {
        dataitem(salesInvoiceHeader; "Sales Invoice Header")
        {
            column(invoiceNo; "No.")
            {
                Caption = 'Invoice No.', Locked = true;
            }
            column(sellToCustomerNo; "Sell-to Customer No.")
            {
                Caption = 'Sell-to Customer No.', Locked = true;
            }
            column(orderNo; "Order No.")
            {
                Caption = 'Order No.', Locked = true;
            }
            column(orderDate; "Order Date")
            {
                Caption = 'Order Date', Locked = true;
            }
            column(postingDate; "Posting Date")
            {
                Caption = 'Posting Date', Locked = true;
            }
            column(sellToCustomerName; "Sell-to Customer Name")
            {
                Caption = 'Sell-to Customer Name', Locked = true;
            }
            column(orderCreatedDateTime; "Order Created Date Time")
            {
                Caption = 'Order Created DateTime', Locked = true;
            }
            dataitem(salesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = salesInvoiceHeader."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Type" = filter(Item), Quantity = filter(> 0);
                column(lineNo; "Line No.")
                {
                    Caption = 'Line No.', Locked = true;
                }
                column(itemNo; "No.")
                {
                    Caption = 'Item No.', Locked = true;
                }
                column(itemDescription; Description)
                {
                    Caption = 'Item Description', Locked = true;
                }
                column(Quantity; Quantity)
                {
                    Caption = 'Quantity', Locked = true;
                }
                column(unitOfMeasure; "Unit of Measure")
                {
                    Caption = 'Unit of Measure', Locked = true;
                }
                column(unitOfMeasureCode; "Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code', Locked = true;
                }
                column(documentType; "Type")
                {
                    Caption = 'Document Type', Locked = true;
                }
                dataitem(item; Item)
                {
                    DataItemLink = "No." = salesInvoiceLine."No.";
                    SqlJoinType = LeftOuterJoin;

                    column(ruppProductGroupCode; "Rupp Product Group Code")
                    {
                        Caption = 'Product Group Code', Locked = true;
                    }

                    dataitem(ruppProductGroup; "Rupp Product Group")
                    {
                        DataItemLink = "Rupp Product Group Code" = item."Rupp Product Group Code";
                        SqlJoinType = LeftOuterJoin;

                        column(ruppProductGroupDescription; Description)
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