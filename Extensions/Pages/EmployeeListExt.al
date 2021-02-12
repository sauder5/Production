pageextension 65201 EmployeeListExt extends "Employee List"
{
    layout
    {
        addafter("Employer No.")
        {
            field("Manager No."; "Manager No.")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}