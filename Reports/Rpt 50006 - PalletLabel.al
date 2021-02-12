report 50006 "Pallet Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/PalletLabel.rdlc';
    UseRequestPage = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            column(DocType; "Sales Header"."Document Type")
            {
            }
            column(SalesNo; "Sales Header"."No.")
            {
            }
            column(CustomerNo; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(CustomerName; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(ShiptoCode; "Sales Header"."Ship-to Code")
            {
            }
            column(Name; "Sales Header"."Ship-to Name")
            {
            }
            column(Name2; "Sales Header"."Ship-to Name 2")
            {
            }
            column(Address; "Sales Header"."Ship-to Address")
            {
            }
            column(Address2; "Sales Header"."Ship-to Address 2")
            {
            }
            column(City; "Sales Header"."Ship-to City")
            {
            }
            column(Contact; "Sales Header"."Ship-to Contact")
            {
            }
            column(Ship; "Sales Header".Ship)
            {
            }
            column(ShippingNo; "Sales Header"."Shipping No.")
            {
            }
            column(PostCode; "Sales Header"."Ship-to Post Code")
            {
            }
            column(County; "Sales Header"."Ship-to County")
            {
            }
            column(Country; "Sales Header"."Ship-to Country/Region Code")
            {
            }
            column(Phone; gsPhone)
            {
            }

            trigger OnAfterGetRecord()
            var
                cuFormatAddr: Codeunit "Format Address";
                recCust: Record Customer;
                recShipTo: Record "Ship-to Address";
            begin

                /*
                IF "Ship-to Code" = '' THEN BEGIN
                  recCust.GET("Sell-to Customer No.");
                  cuFormatAddr.FormatAddr(gsShipLocArray,"Ship-to Name",'','',"Ship-to Address",
                              '',"Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
                  gsShipLocArray[8] := recCust."Phone No.";
                  COMPRESSARRAY(gsShipLocArray);
                
                  recShipTo.GET("Sell-to Customer No.","Ship-to Code");
                  cuFormatAddr.FormatAddr(gsShipLocArray,"Ship-to Name",'','',"Ship-to Address",
                              '',"Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
                  gsShipLocArray[8] :=recShipTo."Phone No.";
                  COMPRESSARRAY(gsShipLocArray);
                END;
                */
                if "Ship-to Code" = '' then begin
                    recCust.Get("Sell-to Customer No.");
                    gsPhone := recCust."Phone No.";
                end else begin
                    recShipTo.Get("Sell-to Customer No.", "Ship-to Code");
                    gsPhone := recShipTo."Phone No.";
                end;

            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Sales Header"."No.", gsOrderNo);
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

    var
        gsShipLocArray: array[8] of Text[50];
        gsPhone: Text;
        gsOrderNo: Code[20];

    [Scope('Internal')]
    procedure SetSO(SalesOrderNo: Code[20])
    begin
        gsOrderNo := SalesOrderNo;
    end;
}

