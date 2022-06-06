query 50024 ReturnedItemsByCustomerAPI
{
    APIGroup = 'items';
    APIPublisher = 'rupp';
    APIVersion = 'beta';
    EntityName = 'returnedItem';
    EntitySetName = 'returnedItems';
    QueryType = API;

    elements
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            column(SalesCrMemoNo; "No.")
            { }
            column(SellToCustomerNo; "Sell-to Customer No.")
            { }
            column(SellToCustomerName; "Sell-to Customer Name")
            { }
            column(PostingDate; "Posting Date")
            { }
            dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = SalesCrMemoHeader."No.";
                SqlJoinType = LeftOuterJoin;
                DataItemTableFilter = "Type" = filter(Item), Quantity = filter(<> 0);

                column(ItemNo; "No.")
                { }
                column(ItemDescription; Description)
                { }
                column(Quantity; Quantity)
                {
                    ReverseSign = true;
                }
                column(UnitOfMeasureCode; "Unit of Measure Code")
                { }
                column(UnitOfMeasure; "Unit of Measure")
                { }
                column(LineType; "Type")
                { }
                column(LineNo; "Line No.")
                { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}