{ pkgs }: {
  colors = {
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
  };
  cursor = { package = pkgs.rose-pine-cursor; name = "BreezeX-RosePine-Linux"; size = 24; };
  gtk = { package = pkgs.rose-pine-gtk-theme; name = "rose-pine-gtk"; };
  icons = { package = pkgs.rose-pine-icon-theme; name = "rose-pine-icons"; };
  qt = { package = pkgs.rose-pine-kvantum; };
  font = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
  sansFont = { package = pkgs.noto-fonts; name = "Noto Sans"; };
}
