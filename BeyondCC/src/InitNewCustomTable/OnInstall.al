codeunit 50005 "ABC On Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InstallCCApp();
    end;

    procedure InstallCCApp()
    var
        ReasonLbl: Label 'ABC-CC-INSTALL-2023-06.1', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(ReasonLbl) then
            exit;

        Codeunit.Run(Codeunit::"ABC Install Custom Table");

        UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";
}