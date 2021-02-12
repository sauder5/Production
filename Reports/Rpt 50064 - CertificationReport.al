report 50064 "Certification Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/CertificationReport.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Lot"; "Production Lot")
        {
            column(Name; "Vendor Name")
            {
            }
            column(Variety; "Generic Name Code")
            {
            }
            column(Lot; "Seed Lot # Planted")
            {
            }
            column(Acres; "Acres Planted")
            {
            }
            column(FieldNo; "Farm Field No.")
            {
            }
            column(PreviousCrop; "Previous Crop")
            {
            }
            column(SameCrop; "If same crop, what Variety")
            {
            }
            column(RowSpace; "Row Spacing")
            {
            }
            column(DatePlanted; "Date of Planting")
            {
            }
            column(ProductType; sType)
            {
            }
            column(CompanyName; recCompany.Name)
            {
            }
            column(CompanyAddress; recCompany.Address)
            {
            }
            column(CompanyCity; recCompany.City)
            {
            }
            column(CompanyState; recCompany.County)
            {
            }
            column(CompanyZip; recCompany."Post Code")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = FIELD("Vendor Number");
                column(Address; Address)
                {
                }
                column(City; City)
                {
                }
                column(State; County)
                {
                }
                column(Zip; "Post Code")
                {
                }
                column(Phone; "Phone No.")
                {
                }
                dataitem(FarmField; "Farm Field")
                {
                    DataItemLink = "Farm Field No." = FIELD("Farm Field No."), "Farm No." = FIELD("Farm No.");
                    DataItemLinkReference = "Production Lot";
                    column(County; County)
                    {
                    }
                    column(Township; Township)
                    {
                    }
                    column(Image; Image)
                    {
                    }
                    column(MediaType; MediaType)
                    {
                    }
                    dataitem(Farm; Farm)
                    {
                        DataItemLink = "Farm No." = FIELD("Farm No.");
                        DataItemLinkReference = "Production Lot";
                        column(LandOwner; "Land Owner")
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    MediaType := 'image/jpeg';
                    MediaId := FarmField.Image.MediaId;
                    if recTenantMedia.Get(MediaId) then
                        MediaType := recTenantMedia."Mime Type";
                    x := StrPos("Production Lot"."Generic Name Code", ',');
                    if x > 0 then
                        sType := CopyStr("Production Lot"."Generic Name Code", 1, x - 1)
                    else
                        sType := "Production Lot"."Generic Name Code";
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

    trigger OnInitReport()
    begin
        MediaType := 'image/jpeg';

        if not recCompany.Get then
            Clear(recCompany);
    end;

    var
        MediaId: Guid;
        MediaType: Text[100];
        recTenantMedia: Record "Tenant Media";
        sType: Text;
        x: Integer;
        recCompany: Record "Company Information";
}

