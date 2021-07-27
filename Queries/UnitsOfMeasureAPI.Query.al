query 50012 "UnitsOfMeasureAPI"
{
    QueryType = API;
    APIPublisher = 'rupp';
    APIGroup = 'uom';
    APIVersion = 'beta';
    EntityName = 'unitOfMeasure';
    EntitySetName = 'unitsOfMeasure';
    TopNumberOfRows = 300;
    OrderBy = ascending(uomCode);

    elements
    {
        dataitem(UOMTable; "Unit of Measure")
        {
            column(uomCode; "Code")
            {
                Caption = 'Code', Locked = true;
            }
            column(uomDescription; Description)
            {
                Caption = 'Description', Locked = true;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}