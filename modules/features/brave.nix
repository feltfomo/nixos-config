{ ... }:
{
  flake.nixosModules.brave = { ... }: {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.etc."brave/policies/managed/policies.json".text = builtins.toJSON {
      BrowserSignin = 0;
      SyncDisabled = true;
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;
      BraveRewardsDisabled = true;
      BraveVPNDisabled = true;
      BraveAIChatEnabled = false;
      SafeBrowsingEnabled = false;
      MetricsReportingEnabled = false;
      ExtensionInstallForcelist = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"
      ];
    };
  };
}
