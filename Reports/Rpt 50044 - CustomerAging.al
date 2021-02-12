report 50044 "Customer Aging"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CustomerAging.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            column(CustNum; Customer."No.")
            {
            }
            column(CustName; Customer.Name)
            {
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                column(Amount; "Detailed Cust. Ledg. Entry".Amount)
                {
                }
                column(Days30; Amt30)
                {
                }
                column(Days60; Amt60)
                {
                }
                column(Days90; Amt90)
                {
                }
                column(DaysOver90; Over90)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(Amt30);
                    Clear(Amt60);
                    Clear(Amt90);
                    Clear(Over90);

                    PostDate := "Detailed Cust. Ledg. Entry"."Posting Date";
                    NumDays := Today - PostDate;
                    case NumDays of
                        0 .. 30:
                            Amt30 := Amount;
                        31 .. 60:
                            Amt60 := Amount;
                        61 .. 90:
                            Amt90 := Amount;
                        else
                            Over90 := Amount;
                    end;
                end;
            }
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
        PostDate: Date;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Over90: Decimal;
        NumDays: Decimal;
}

