tableextension 50001 "ABC Posted Gen. Journal Line" extends "Posted Gen. Journal Line"
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