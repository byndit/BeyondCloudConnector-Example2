tableextension 50002 "ABC G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; "ABC Doc. Process No."; Code[20])
        {
            Caption = 'Doc. Process Nos.';
            DataClassification = CustomerContent;
            TableRelation = "ABC Doc. Process No.";
        }
    }
}