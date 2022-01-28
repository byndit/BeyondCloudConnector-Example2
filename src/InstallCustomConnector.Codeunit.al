codeunit 50001 "ABC Install Custom Connector"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        UpgradeCloudFiles();
    end;

    local procedure UpgradeCloudFiles()
    var
        BYDCloudStorage: Record "BYD Cloud Storage";
        UpgradeTagTxt: Label '2022-01-BCC', Locked = true;
    begin
        if (UpgradeTag.HasUpgradeTag(UpgradeTagTxt)) then
            exit;

        BYDCloudStorage.Init();
        BYDCloudStorage.Type := BYDCloudStorage.Type::Dropzone;
        BYDCloudStorage."Table ID" := Database::"ABC Doc. Process No.";
        if BYDCloudStorage.Insert() then;

        UpgradeTag.SetUpgradeTag(UpgradeTagTxt);
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";
}