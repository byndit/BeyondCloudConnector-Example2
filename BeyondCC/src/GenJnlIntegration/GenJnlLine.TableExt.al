tableextension 50000 "ABC Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "ABC Doc. Process No."; Code[20])
        {
            Caption = 'Doc. Process No.';
            DataClassification = CustomerContent;
            TableRelation = "ABC Doc. Process No.";
        }
    }
}