page 50012 "Commodity Codes"
{
    // //SOC-SC 08-09-15
    //   Added field "Seed Unit Premium"

    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Commodity Settings";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Seed Unit Premium"; "Seed Unit Premium")
                {
                }
                field("Comm. Annual Prem per UOM"; "Comm. Annual Prem per UOM")
                {
                }
                field("Estimated Yield per Acre"; "Estimated Yield per Acre")
                {
                }
                field("Grain Program Payable Acct"; "Grain Program Payable Acct")
                {
                }
                field("Created By"; "Created By")
                {
                    Visible = false;
                }
                field("Created Date Time"; "Created Date Time")
                {
                    Visible = false;
                }
                field("Modified By"; "Modified By")
                {
                    Visible = false;
                }
                field("Modified Date Time"; "Modified Date Time")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                }
            }
            part("Moisture Test Subform"; "Quality Premium Subform")
            {
                Caption = 'Moisture Test';
                SubPageLink = "Quality Premium Code" = FIELD(Code);
                SubPageView = WHERE("Test Type" = CONST(Moisture));
            }
            part("Test Weight Subform"; "Quality Premium Subform")
            {
                Caption = 'Test Weight';
                SubPageLink = "Quality Premium Code" = FIELD(Code);
                SubPageView = WHERE("Test Type" = CONST("Test Weight"));
            }
            part("Splits Subform"; "Quality Premium Subform")
            {
                Caption = 'Splits';
                SubPageLink = "Quality Premium Code" = FIELD(Code);
                SubPageView = WHERE("Test Type" = CONST(Splits));
            }
            part("Vomitoxin Subform"; "Quality Premium Subform")
            {
                Caption = 'Vomitoxin';
                SubPageLink = "Quality Premium Code" = FIELD(Code);
                SubPageView = WHERE("Test Type" = CONST(Vomitoxin));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Moisture)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::Moisture;
                    OpenDiscountsForTest(TestType);
                end;
            }
            action(Splits)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::Splits;
                    OpenDiscountsForTest(TestType);
                end;
            }
            action("Test Weight")
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight";
                begin
                    TestType := TestType::"Test Weight";
                    OpenDiscountsForTest(TestType);
                end;
            }
            action(Vomitoxin)
            {

                trigger OnAction()
                var
                    TestType: Option ,Splits,Moisture,"Test Weight",Vomitoxin;
                begin
                    TestType := TestType::"Test Weight";
                    OpenDiscountsForTest(TestType);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        oTestType: Option ,Splits,Moisture,"Test Weight";
    begin
        //CurrPage.Lines.PAGE.FilterForTestType(goTestType);
        CurrPage."Moisture Test Subform".PAGE.FilterForTestType(oTestType::Moisture);
    end;
}

