tableextension 60036 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50000; "Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Ordered By"; Code[35])
        {
            TableRelation = Contact;
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                recCust: Record Customer;
                ContBusRel: Record "Contact Business Relation";
                recCont: Record Contact;
                UpdateContFromCust: Codeunit "CustCont-Update";
            begin
                recCust.GET("Sell-to Customer No.");
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "Sell-to Customer No.");
                IF NOT ContBusRel.FINDFIRST THEN BEGIN
                    UpdateContFromCust.InsertNewContact(recCust, FALSE);
                    ContBusRel.FINDFIRST;
                END;
                COMMIT;

                recCont.SETCURRENTKEY("Company Name", "Company No.", Type, Name);
                recCont.SETRANGE("Company No.", ContBusRel."Contact No.");
                IF PAGE.RUNMODAL(PAGE::"Contact List", recCont) = ACTION::LookupOK THEN BEGIN
                    "Ordered By" := recCont."No.";
                    "Ordered By Name" := recCont.Name;
                    "Ordered By Date" := WORKDATE;
                END;

            end;
        }
        field(50003; "Ordered By Name"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Ordered By Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Requested Ship Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Shipment Date", "Requested Ship Date");
            end;
        }
        field(51000; "Shipping Status"; Option)
        {
            OptionMembers = " ",Picking,Picked,Packing,"Partially Shipped","Completely Shipped";
            DataClassification = CustomerContent;
        }
        field(51001; "Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                TestField("Shipping Status", "Shipping Status"::" ");
            end;
        }
        field(51002; "Cancelled Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Order Cancelled"));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                Cancelled := "Cancelled Reason Code" <> '';
            end;
        }
        field(51003; "Order Method"; Option)
        {
            OptionMembers = " ",Phone,Mail,Fax,Email,"In-person",Website,"From Salesperson";
            InitValue = Phone;
            DataClassification = CustomerContent;
        }
        field(51004; "On-Hold Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Order On Hold"));
            DataClassification = CustomerContent;
        }
        field(51005; "Shipped By"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Shipment Header"."User ID" WHERE("Order No." = FIELD("No.")));
        }
        field(51010; "Missing Reqd License"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Missing Reqd License" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51012; "Missing Reqd Liability Waiver"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Missing Reqd Liability Waiver" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51014; "Missing Reqd Quality Release"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Missing Reqd Quality Release" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51015; "Rupp Missing Reqd License"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Rupp Missing License" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51016; "Rupp Missing Reqd Liability"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Rupp Missing Liability Waiver" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51017; "Rupp Missing Reqd Quality Rel"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Rupp Missing Quality Release" = CONST(true), "Outstanding Quantity" = FILTER(> 0)));
        }
        field(51020; "Seasonal Cash Disc Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51021; "Grace Period Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51022; "Cust. Payment Link Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Customer Payment Link" WHERE("Customer No." = FIELD("Sell-to Customer No."), "Order No." = FIELD("No."), "Invoice No." = FILTER('')));
        }
        field(51023; "Shipped Not Invoiced Amount"; decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(51030; "Freight Charges Option"; Option)
        {
            OptionMembers = "User Decides","One Time Charge","All Actual Charges";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                RuppFun: Codeunit "Rupp Functions";
            begin
                IF "Freight Charges Option" <> xRec."Freight Charges Option" THEN BEGIN
                    TESTFIELD("Shipping Status", SalesHeader."Shipping Status"::" ");
                END;
                RuppFun.ValidateFreightChargesOption(Rec);
            end;
        }
        field(52000; "Region Code"; Code[20])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
        // Added by TAE 2021-08-04 to support the online customer center and ordering
        field(52010; "Customer Comment"; Text[250])
        {
            Caption = 'Customer Comment';
            DataClassification = CustomerContent;
        }
        // End
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                recUserSetup: Record "User Setup";
                ComplianceMgt: Codeunit "Compliance Management";
            begin
                if not ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code") then
                    Clear(ShipToAddr)
                else
                    VALIDATE("Freight Charges Option", ShipToAddr."Freight Charges Option");
                IF ShipToAddr."Region Code" <> '' THEN
                    VALIDATE("Region Code", ShipToAddr."Region Code");

                IF recUserSetup.GET(USERID) THEN BEGIN
                    IF recUserSetup."Default Location Code" <> '' THEN BEGIN
                        "Location Code" := recUserSetup."Default Location Code";
                    END;
                END;
                commit;
                ComplianceMgt.UpdateSalesLineComplianceHeader(Rec);
            end;
        }
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateDueDate();
            end;
        }
        modify("Salesperson Code")
        {
            trigger OnAfterValidate()
            var
                recSL: Record "Sales Line";
            begin
                Commit;
                recSL.RESET();
                recSL.SETRANGE("Document Type", "Document Type");
                recSL.SETRANGE("Document No.", "No.");
                IF recSL.FINDSET() THEN
                    recSL.MODIFYALL("Salesperson Code", Rec."Salesperson Code");
            end;
        }
        modify("On Hold")
        {
            trigger OnAfterValidate()
            begin
                //SOC-SC 07-31-14
                IF ("On Hold" <> '') THEN
                    TESTFIELD("On-Hold Reason Code")
                ELSE
                    TESTFIELD("On-Hold Reason Code", '');
                //SOC-SC 07-31-14
            end;
        }
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                if not PaymentMethod.get("Payment Method Code") then
                    Clear(PaymentMethod);
                //SOC-MA 08-17-15 >>
                IF PaymentMethod."Payment Terms Code" <> '' THEN
                    VALIDATE("Payment Terms Code", PaymentMethod."Payment Terms Code");
                //SOC-MA 08-17-15 <<
            end;
        }
        modify("E-Ship Agent Service")
        {
            trigger OnAfterValidate()
            var
                ShippingAgent: Record "Shipping Agent";
                EShipAgentService: Record "E-Ship Agent Service";
            begin
                if "E-Ship Agent Service" = '' then exit;
                if not ShippingAgent.get("Shipping Agent Code") then
                    Clear(ShippingAgent);
                EShipAgentService.ValidateEShipAgentService(
                    ShippingAgent, "E-Ship Agent Service", "Ship-to Country/Region Code");
                //SOC-SC 08-01-14
                IF EShipAgentService."No Free Freight" THEN BEGIN
                    "Free Freight" := FALSE;
                    "No Free Freight Lines on Order" := FALSE;
                END;
                //SOC-SC 08-01-14
            end;
        }
    }

    var
        ShipToAddr: Record "Ship-to Address";
        Cust: Record Customer;

    trigger OnAfterInsert()
    begin
        if not Cust.Get("Sell-to Customer No.") then
            Clear(Cust);
        if not ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code") then
            VALIDATE("Freight Charges Option", Cust."Freight Charges Option")
        ELSE
            validate("Freight Charges Option", ShipToAddr."Freight Charges Option");
        "Region Code" := Cust."Region Code";
        validate("Ship-to Code", Cust."Default Ship-to Code");
        modify();
    end;

    procedure UpdateDueDate()
    var
        cduRuppFunctionsMA: Codeunit "Rupp Functions MA";
    begin
        //SOC-MA 10-20-14
        cduRuppFunctionsMA.UpdateDueDate(Rec);
    end;

}