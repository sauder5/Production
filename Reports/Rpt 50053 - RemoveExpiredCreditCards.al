report 50053 "Remove Expired Credit Cards"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/RemoveExpiredCreditCards.rdlc';

    dataset
    {
        dataitem("Customer Credit Card -CL-"; "Customer Credit Card -CL-")
        {
            DataItemTableView = WHERE("Expiration Year" = FILTER(> '0'), "Expiration Month" = FILTER(> '0'));

            trigger OnAfterGetRecord()
            var
                lYear: Integer;
                lMonth: Integer;
            begin
                gCount += 1;

                if Evaluate(lYear, "Customer Credit Card -CL-"."Expiration Year") then
                    if Evaluate(lMonth, "Customer Credit Card -CL-"."Expiration Month") then
                        if (gYear < lYear) or
                           ((gYear = lYear) and (gMonth <= lMonth)) then begin
                            CurrReport.Skip;
                            exit;
                        end
                        else begin
                            gDeleted += 1;
                            Delete;
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

    trigger OnInitReport()
    begin
        /*IF DATE2DMY(TODAY(),1) > 5 THEN
          CurrReport.QUIT;*/

    end;

    trigger OnPostReport()
    begin

        Message('Total records: %1  Deleted: %2', gCount, gDeleted);
    end;

    trigger OnPreReport()
    begin
        gMonth := Date2DMY(Today(), 2);
        gYear := (Date2DMY(Today(), 3) mod 100);
        gCount := 0;
        gDeleted := 0;
    end;

    var
        gYear: Integer;
        gMonth: Integer;
        gCount: Integer;
        gDeleted: Integer;
}

