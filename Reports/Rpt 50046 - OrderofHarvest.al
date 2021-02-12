report 50046 "Order of Harvest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/OrderofHarvest.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ColumnLoop; "Integer")
        {
            dataitem(RowLoop; "Integer")
            {
                column(KeyValue; recResearch.Key)
                {
                }
                column(Plot; recResearch."Plot ID")
                {
                }
                column(Variety; recResearch."Variety Hybrid")
                {
                }
                column(WetLBS; recResearch."Wet Lbs")
                {
                }
                column(Moisture; recResearch.Moisture)
                {
                }
                column(Population; recResearch.Population)
                {
                }
                column(RowNum; RowLoop.Number)
                {
                }
                column(ColNum; ColumnLoop.Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not recResearch.Get(gType, gKeys[RowLoop.Number, ColumnLoop.Number]) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, gRow);
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, gColumn);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(gType; gType)
                {
                    Caption = 'Type';
                    TableRelation = "Research Plots";
                }
                field(gYear; gYear)
                {
                    Caption = 'Year';
                }
                field(gStart; gStart)
                {
                    Caption = 'Starting Number';
                }
                field(gRow; gRow)
                {
                    Caption = 'Rows';
                }
                field(gColumn; gColumn)
                {
                    Caption = 'Columns';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        gX: Integer;
        gY: Integer;
    begin
        gYear := Date2DMY(Today(), 3);
        if recPlots.FindFirst then
            gType := recPlots.Type;
    end;

    trigger OnPreReport()
    begin
        recResearch.SetFilter(Type, '%1', gType);
        if gYear > 0 then
            recResearch.SetFilter(Year, '%1', gYear);
        recResearch.SetFilter(Key, '>=%1', gStart);
        if recResearch.FindSet then begin
            for gX := 1 to gRow do
                if (gX mod 2) = 1 then
                    for gY := 1 to gColumn do begin
                        gKeys[gX, gY] := recResearch.Key;
                        if recResearch.Next = 0 then
                            exit;
                    end
                else
                    for gY := gColumn downto 1 do begin
                        gKeys[gX, gY] := recResearch.Key;
                        if recResearch.Next = 0 then
                            exit;
                    end
        end;
    end;

    var
        gX: Integer;
        gY: Integer;
        gType: Code[10];
        gYear: Integer;
        gKeys: array[50, 50] of Integer;
        gRow: Integer;
        gColumn: Integer;
        gStart: Integer;
        recResearch: Record "Research Plot Data";
        CLoop: Integer;
        RLoop: Integer;
        recPlots: Record "Research Plots";
}

