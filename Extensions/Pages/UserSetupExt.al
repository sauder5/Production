pageextension 60119 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Default Location Code"; "Default Location Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Allow Payroll Calc. Trace")
        {
            field("Show Protected Vendors"; "Show Protected Vendors")
            {
                ApplicationArea = all;
            }
            field("Default Ship-To for Purch. "; "Default Ship-To for Purch. ")
            {
                ApplicationArea = all;
            }
        }
    }
}