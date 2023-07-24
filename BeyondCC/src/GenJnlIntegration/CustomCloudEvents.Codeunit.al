codeunit 50000 "ABC Custom Cloud Events"
{
    [EventSubscriber(ObjectType::Page, Page::"General Journal", 'OnBeforeValidateEvent', 'Amount', false, false)]
    local procedure GeneralJournalOnBeforeValidateEvent(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line")
    begin
        CustomCloudMgt.GeneralJournalOnBeforeValidateEvent(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure GLEntryOnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        CustomCloudMgt.GLEntryOnAfterCopyGLEntryFromGenJnlLine(GenJournalLine, GLEntry);
    end;

    var
        CustomCloudMgt: Codeunit "ABC Custom Cloud Mgt.";
}