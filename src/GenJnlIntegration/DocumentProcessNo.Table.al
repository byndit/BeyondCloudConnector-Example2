table 50001 "ABC Doc. Process No."
{
    DataClassification = CustomerContent;
    Caption = 'Document Process No.';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
}