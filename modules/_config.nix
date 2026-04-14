{
  username = "feltfomo";
  home = "/home/feltfomo";
  hostname = "fomonix";
  zenProfile = "ka47tihc.Default Profile";

  monitors = {
    primary = {
      name = "DP-1";
      res = "2560x1440";
      refreshRate = 180;
      x = 0;
      y = 0;
    };
    secondary = {
      name = "DP-2";
      res = "2560x1440";
      refreshRate = 180;
      x = 2560;
      y = 0;
    };
  };

  disk = {
    rootUuid = "759ce480-777a-455e-98c9-e0009ee31f8b";
    swapUuid = "02a6abfd-9d76-4ddc-ae20-dc028580c206";
    bootUuid = "F442-EF75";
  };

  rebuild = {
    autoSync = true;
    autoQsClean = true;
    defaultConfig = "fomonixHyprland"; # used by the orchestrator TUI
  };
}
