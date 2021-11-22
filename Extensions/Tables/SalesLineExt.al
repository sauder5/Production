tableextension 60037 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50100; "Qty. Requested"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Qty. Cancelled" > "Qty. Requested" THEN
                    ERROR('You cannot request less than what is cancelled');

                RuppFn.UpdateSLWithQtyRequested(Rec, xRec);
                UpdateForGeographicalRestriction(); //SOC-MA 10-21-14
            end;
        }
        field(50101; "Qty. Cancelled"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";

            begin
                IF "Qty. Cancelled" > "Qty. Requested" THEN
                    ERROR('You cannot cancel more than what is requested');

                VALIDATE(Quantity, "Qty. Requested" - "Qty. Cancelled");

                //SOC-SC 06-02-15
                CASE Type OF
                    Type::Item, Type::Resource:
                        BEGIN
                            SalesHeader.GET("Document Type", "Document No.");
                            PriceCalcMgt.FindSalesLineLineDisc(SalesHeader, Rec);
                            PriceCalcMgt.FindSalesLinePrice(SalesHeader, Rec, FIELDNO(Quantity));
                        END;
                END;
                VALIDATE("Unit Price");
                //SOC-SC 06-02-15
            end;
        }
        field(50102; "Inventory Status Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = Const("Inventory Status"));
            DataClassification = CustomerContent;
        }
        field(50103; "Cancelled Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Line Cancelled"));
            DataClassification = CustomerContent;
        }
        field(50104; "Unit Price Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Sales Line Unit Price"));
            DataClassification = CustomerContent;
        }
        field(50105; "Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                VALIDATE("Line Discount Amount", "Unit Discount" * Quantity);
            end;
        }
        field(50106; "High Value Charges"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50107; "Original Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50108; "Unit Price per CUOM"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Text1020001: TextConst ENU = 'must be %1 when the Prepayment Invoice has already been posted';
            begin
                //SOC-SC 09-26-15
                TestJobPlanningLine;
                TestStatusOpen;
                RuppFn.UpdateUnitPriceFromCUOM(Rec);

                IF ("Prepmt. Amt. Inv." <> 0) AND
                ("Unit Price" <> xRec."Unit Price")
                THEN
                    FIELDERROR("Unit Price", STRSUBSTNO(Text1020001, xRec."Unit Price"));
                VALIDATE("Line Discount %");

                IF CurrFieldNo <> FIELDNO("Unit Price") THEN BEGIN
                    "Original Unit Price" := "Unit Price";
                END ELSE
                    IF "Original Unit Price" = 0 THEN
                        "Original Unit Price" := "Unit Price";
            end;
        }
        field(50109; "Common Unit of Measure"; Code[10])
        {
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
            DataClassification = CustomerContent;
        }
        field(50110; "Pick Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Activity Line".Quantity WHERE("Activity Type" = CONST(Pick), "Action Type" = FILTER(Take | ' '), "Source Type" = CONST(37), "Source Subtype" = FIELD("Document Type"), "Source No." = FIELD("Document No."), "Source Line No." = FIELD("Line No.")));
        }
        field(50111; "Pick Creation DateTime"; datetime)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Activity Line"."Created Date Time" WHERE("Activity Type" = CONST(Pick), "Action Type" = FILTER(Take | ' '), "Source Type" = CONST(37), "Source Subtype" = FIELD("Document Type"), "Source No." = FIELD("Document No."), "Source Line No." = FIELD("Line No.")));
        }
        field(50120; "Compliance Group Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Compliance Group Product Item"."Waiver Code" WHERE("Item No." = FIELD("No.")));
        }
        field(50121; "Missing Reqd License"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50123; "Missing Reqd Liability Waiver"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50125; "Missing Reqd Quality Release"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50127; "Ship-to Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Ship-to Code" WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
        }
        field(50128; "Pick Printed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50131; "Rupp Missing License"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Missing Compliances"."Missing License" where("Document Type" = field("Document Type"), "Document No." = field("Document No."), "Line No." = field("Line No.")));
        }
        field(50133; "Rupp Missing Liability Waiver"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Missing Compliances"."Missing Liability Waiver" where("Document Type" = field("Document Type"), "Document No." = field("Document No."), "Line No." = field("Line No.")));
        }
        field(50135; "Rupp Missing Quality Release"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Missing Compliances"."Missing Quality Release" where("Document Type" = field("Document Type"), "Document No." = field("Document No."), "Line No." = field("Line No.")));
        }
        field(51000; "Product Code"; Code[17])
        {
            TableRelation = Product;
            DataClassification = CustomerContent;
        }
        field(51001; "Qty. can be Produced"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Outstanding Qty. in Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Outstanding Qty. in Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51010; "Seasonal Cash Disc Code"; Code[20])
        {
            TableRelation = "Season Code";
            DataClassification = CustomerContent;
        }
        field(51020; "Inventory Status Action"; Option)
        {
            OptionMembers = " ",Cancel,Substitute;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CancelSubstituteMgt: Codeunit "Cancellation Substitution Mgt.";
            begin
                //SOC- SC 10-19-14
                //TestStatusOpen; //SOC-SC 12-17-15 commenting
                CancelSubstituteMgt.CheckSLInventoryStatusAction(Rec);
                IF "Inventory Status Action" = "Inventory Status Action"::Substitute THEN BEGIN
                    TESTFIELD("Substituted Item No.");
                END;
            end;
        }
        field(51021; "Original Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Substituted Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51023; Substitute; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(510024; "In-process User ID"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(51025; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(52000; "Geographical Restriction"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(52100; "Whse Shpt No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(52101; "Whse Shpt Line Exists"; Boolean)
        {
            FieldClass = flowfield;
            CalcFormula = Exist("Warehouse Shipment Line" WHERE("No." = FIELD("Whse Shpt No. Filter"), "Source Type" = CONST(37), "Source Subtype" = FIELD("Document Type"), "Source No." = FIELD("Document No."), "Source Line No." = FIELD("Line No.")));
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                RuppBusLogic: Codeunit "Rupp Business Logic";
            begin
                RuppBusLogic.CheckSalesLine_No(Rec);
            end;

            trigger OnAfterValidate()
            var
                RuppBusLogic: Codeunit "Rupp Business Logic";
            begin
                RuppBusLogic.UpdateSalesLnRuppFields(Rec);
                UpdateForGeographicalRestriction();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                RuppFn: Codeunit "Rupp Functions";
            begin
                RuppFn.UpdateHdrShpgStatusFromSalesLn(Rec, false);
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                RuppFun: Codeunit "Rupp Functions";
            begin
                IF CurrFieldNo <> FIELDNO("Unit Price") THEN BEGIN //SOC-SC 11-11-14
                    "Original Unit Price" := "Unit Price";           //SOC-SC 11-11-14
                END ELSE                                           //SOC-SC 11-11-14
                                                                   //SOC-SC 10-22-14
                    IF "Original Unit Price" = 0 THEN
                        "Original Unit Price" := "Unit Price";
                //SOC-SC 10-22-14

                RuppFun.UpdateUnitPricePerCUOM(Rec); //SOC-SC 09-17-15

            end;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            var
                RuppFun: Codeunit "Rupp Functions";
            begin
                RuppFun.UpdateSLUnitDiscount(Rec);
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            begin
                RuppFn.UpdateSLUnitDiscount(Rec);
            end;
        }
        modify("Outstanding Amount")
        {
            trigger OnAfterValidate()
            begin
                UpdateUOMQuantities();
            end;
        }
    }
    var
        gbDeletingHdr: Boolean;
        RuppFn: Codeunit "Rupp Functions";

    trigger OnBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.get("Document Type", "Document No.") then
            Clear(SalesHeader);

        IF SalesHeader."Shipping Status" IN [SalesHeader."Shipping Status"::Picking, SalesHeader."Shipping Status"::Picked, SalesHeader."Shipping Status"::Packing] THEN
            ERROR('You cannot add new lines if the order %1 is already in the shipping process', "No.");
    end;

    trigger OnAfterInsert()
    var
        SalesHeader: Record "Sales Header";
        recCustomer: Record Customer;
    begin
        if SalesHeader.get("Document Type", "Document No.") then
            "Salesperson Code" := SalesHeader."Salesperson Code"
        else
            if recCustomer.get("Sell-to Customer No.") then
                "Salesperson Code" := recCustomer."Salesperson Code";
        Modify();
    end;

    trigger OnAfterDelete()
    var
        RuppFun: Codeunit "Rupp Functions";
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.get("Document Type", "Document No.") Then
            Clear(SalesHeader);
        RuppFn.UpdateHdrShpgStatusFromSalesLn(Rec, TRUE);
        CustPmtLinkMgt.UpdateSHSeasDiscCode(SalesHeader, "Line No.");
    end;

    procedure UpdateUOMQuantities()
    var
        RuppFunc: Codeunit "Rupp Functions";
        dQtyPerLUOM: Decimal;
    begin
        //SOC-SC 08-23-14
        IF Type = Type::Item THEN BEGIN
            RuppFunc.GetQtyLUOMandQtyCUOM("No.", "Unit of Measure Code", "Outstanding Quantity", "Outstanding Qty. in Lowest UOM", "Outstanding Qty. in Common UOM", dQtyPerLUOM);
        END;

    end;

    procedure UpdateForGeographicalRestriction()
    var
        RuppFnMA: Codeunit "Rupp Functions MA";
    begin
        //SOC-MA 10-21-14

        RuppFnMA.UpdateForGeographicalRestrictions(Rec);
    end;

    procedure SetDeletingHdr()
    begin
        gbDeletingHdr := true;
    end;
}