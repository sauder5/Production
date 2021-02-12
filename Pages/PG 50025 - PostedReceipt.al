page 50025 "Posted Receipt"
{
    // //SOC-SC 08-06-15
    //   Added field "Vomitoxin Test Result"

    Caption = 'Posted Contract Receipt';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Receipt Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Primary Vendor No."; "Primary Vendor No.")
                {
                }
                field("Primary Vendor Name"; "Primary Vendor Name")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field("Gross Wt (LB)"; "Gross Wt (LB)")
                {
                }
                field("Tare Wt (LB)"; "Tare Wt (LB)")
                {
                }
                field("Net Wt (LB)"; "Net Wt (LB)")
                {
                }
                field("Gross Quantity in Purchase UOM"; "Gross Quantity in Purchase UOM")
                {
                }
                field("Moisture Test Result"; "Moisture Test Result")
                {
                }
                field("Splits Test Result"; "Splits Test Result")
                {
                }
                field("Test Weight Result"; "Test Weight Result")
                {
                }
                field("Vomitoxin Test Result"; "Vomitoxin Test Result")
                {
                }
                field("Net Quantity in Purchase UOM"; "Net Quantity in Purchase UOM")
                {
                }
            }
            part(Control1000000027; "Posted Receipt Subpage")
            {
                SubPageLink = "Receipt No." = FIELD("No.");
            }
            group(Detail)
            {
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
                {
                }
                field("Lbs per Purch. Unit of Measure"; "Lbs per Purch. Unit of Measure")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field("Shrink Qty."; "Shrink Qty.")
                {
                }
                field("Check-off %"; "Check-off %")
                {
                }
                field(Farm; Farm)
                {
                }
                field("Farm Field"; "Farm Field")
                {
                }
                field("Splits Unit Premium"; "Splits Unit Premium")
                {
                }
                field("Test Weight Unit Discount"; "Test Weight Unit Discount")
                {
                }
                field("Vomitoxin Unit Discount"; "Vomitoxin Unit Discount")
                {
                }
                field("Seed Unit Premium"; "Seed Unit Premium")
                {
                }
                field("Unit Premium/Discount"; "Unit Premium/Discount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Posted Purchase Receipt Lines")
            {

                trigger OnAction()
                var
                    recPurchrcptLn: Record "Purch. Rcpt. Line";
                begin
                    recPurchrcptLn.Reset();
                    recPurchrcptLn.SetRange("Rcpt No.", "No.");
                    if recPurchrcptLn.FindSet() then begin
                        PAGE.RunModal(528, recPurchrcptLn);
                    end;
                end;
            }
        }
    }
}

