table 50000 "ABC General Setup"
{
    Caption = 'General Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Doc. Process Nos."; Code[20])
        {
            Caption = 'Doc. Process Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

}