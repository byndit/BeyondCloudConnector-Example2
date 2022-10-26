codeunit 50002 "ABC Custom Cloud Mgt."
{
    procedure GeneralJournalOnBeforeValidateEvent(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line")
    begin
        if Rec.IsTemporary() then
            exit;
        if Rec."Line No." = 0 then
            exit;
        if Rec."ABC Doc. Process No." <> '' then
            exit;
        Rec."ABC Doc. Process No." := NewProcessNo();
    end;

    procedure GLEntryOnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."ABC Doc. Process No." := GenJournalLine."ABC Doc. Process No.";
    end;

    local procedure NewProcessNo(): Code[20]
    var
        CloudConnectorSetup: Record "ABC General Setup";
        DocProcessNo: Record "ABC Doc. Process No.";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if not CloudConnectorSetup.Get() then
            CloudConnectorSetup.Init();
        if CloudConnectorSetup."Doc. Process Nos." = '' then
            exit('');

        DocProcessNo.Init();
        DocProcessNo."No." := NoSeriesManagement.GetNextNo(CloudConnectorSetup."Doc. Process Nos.", Today(), true);
        DocProcessNo.Insert();
        exit(DocProcessNo."No.");
    end;
}