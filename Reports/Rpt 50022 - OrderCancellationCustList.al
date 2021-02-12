report 50022 "Order Cancellation Cust List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/OrderCancellationCustList.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(ItemNo; Item."No.")
            {
            }
            column(Description; Item.Description)
            {
            }
            column(UOM; Item."Base Unit of Measure")
            {
            }
            dataitem(Initial; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Inventory Status Action" = CONST(Cancel));

                trigger OnAfterGetRecord()
                var
                    recCust: Record Customer;
                begin
                    recCustTemp.Init();
                    recCustTemp."No." := "Sell-to Customer No.";
                    recCust.Get("Sell-to Customer No.");
                    recCustTemp.Name := recCust.Name;
                    if recCustTemp.Insert then;
                end;
            }
            dataitem(CustLoop; "Integer")
            {
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Inventory Status Action" = CONST(Cancel));
                    column(CustNo; "Sales Line"."Sell-to Customer No.")
                    {
                    }
                    column(CustName; recCustTemp.Name)
                    {
                    }
                    column(OrderNo; "Sales Line"."Document No.")
                    {
                    }
                    column(OrderDate; gtOrderDate)
                    {
                    }
                    column(QtyOrdered; "Sales Line"."Qty. Requested")
                    {
                    }
                    column(QtyCancelled; "Sales Line"."Qty. Cancelled")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        recSH: Record "Sales Header";
                    begin
                        recSH.Get("Document Type", "Document No.");
                        gtOrderDate := recSH."Order Date";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Sell-to Customer No.", recCustTemp."No.");
                        SetRange("No.", Item."No.");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        recCustTemp.FindSet()
                    else
                        recCustTemp.Next();
                end;

                trigger OnPreDataItem()
                var
                    iCustCnt: Integer;
                begin
                    recCustTemp.Reset();
                    recCustTemp.SetCurrentKey(Name);
                    iCustCnt := recCustTemp.Count;

                    if iCustCnt = 0 then
                        CurrReport.Break();
                    SetRange(Number, 1, iCustCnt);
                end;
            }

            trigger OnAfterGetRecord()
            var
                recRef: RecordRef;
            begin
                recRef.GetTable(recCustTemp);
                if recRef.IsTemporary() then begin
                    recCustTemp.Reset();
                    recCustTemp.DeleteAll();
                end;
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

    labels
    {
    }

    trigger OnPreReport()
    begin
        if Item.GetFilter("No.") = '' then
            Error('Please enter Item No. filter and try again');
    end;

    var
        recCustTemp: Record Customer temporary;
        gtOrderDate: Date;
}

