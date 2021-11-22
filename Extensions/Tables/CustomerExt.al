tableextension 60018 CustomerExt extends Customer
{
    fields
    {
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                //SOC-MA 08-17-15 >>
                IF PaymentMethod."Payment Terms Code" <> '' THEN
                    VALIDATE("Payment Terms Code", PaymentMethod."Payment Terms Code");
                //SOC-MA 08-17-15 <<
            end;
        }
        field(50000; "Create Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Linking Pmt Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51050; "Sales Line Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Sell-to Customer No." = FIELD("No."), "Document Type" = CONST(Order), Type = CONST(Item), "Outstanding Quantity" = FILTER(> 0), "Drop Shipment" = CONST(False), "No." = FIELD("Item No. Filter")));
        }
        field(51051; "Item No. Filter"; Text[20])
        {
            FieldClass = FlowFilter;
        }
        field(51100; "Total Potential Rem Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Customer Payment Link"."Potential Remaining Amount" WHERE("Customer No." = FIELD("No."), Request = filter(true), Cancelled = FILTER(false)));
        }
        field(51101; "Remaining Seasonal Discount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Customer Payment Link"."Remaining Discount" WHERE("Customer No." = FIELD("No."), Request = FILTER(True), Cancelled = FILTER(False)));
        }
        field(51110; "Potential Deposit Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Gen. Journal Line"."Potential Amount" WHERE("Account Type" = filter(Customer), "Account No." = FIELD("No."), "Document Type" = CONST(Payment)));
        }
        field(51111; "Potential Deposit Fall Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Gen. Journal Line"."Potential Fall Amount" WHERE("Account Type" = FILTER(Customer), "Account No." = FIELD("No."), "Credit Amount" = FILTER(<> 0)));
        }
        field(51112; "Potential Deposit Spring Amt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Gen. Journal Line"."Potential Spring Amount" WHERE("Account Type" = FILTER(Customer), "Account No." = FIELD("No."), "Credit Amount" = FILTER(<> 0)));
        }
        field(52000; "Region Code"; Code[20])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
        field(52001; "Default Ship-to Code"; Code[10])
        {
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("No."));
        }
        field(52010; "Partially Shipped Sales Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order), "Sell-to Customer No." = FIELD("No."), Status = FILTER(Released), Ship = FILTER(true), "Completely Shipped" = FILTER(false), "Shipment Date" = FIELD("Date Filter")));
        }
        field(52011; "Warehouse Pick Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Warehouse Activity Line" WHERE("Activity Type" = FILTER(Pick), "Action Type" = FILTER(Take), "Destination Type" = FILTER(Customer), "Destination No." = FIELD("No."), "Due Date" = FIELD("Date Filter")));
        }
        field(52020; "Blocked Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("Customer Blocked"));
            DataClassification = CustomerContent;
        }
        field(52030; "Freight Charges Option"; Option)
        {
            OptionMembers = "User Decides","One Time Charge","All Actual Charges";
            DataClassification = CustomerContent;
        }
        field(52031; "Mobile Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterInsert()
    begin
        //RSI-KS
        VALIDATE("Create Date", TODAY);
        VALIDATE("Check Date Format", "Check Date Format"::"MM DD YYYY");
        VALIDATE("Check Date Separator", "Check Date Separator"::"/");
        //RSI-KS
    end;
}