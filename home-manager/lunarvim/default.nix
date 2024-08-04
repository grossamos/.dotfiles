{pkgs, ...}: {
  home.packages = [pkgs.hyprlock];
  xdg.configFile."lvim/config.lua".text = ''
    lvim.transparent_window = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
  '';
}
