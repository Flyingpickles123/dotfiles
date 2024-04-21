local wezterm = require("wezterm")

local config = {
  enable_tab_bar = false,
  audible_bell = "Disabled",
  notification_handling = "NeverShow",
  color_scheme = "Terminix Dark (Gogh)",
  font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Medium" }),
  font_size = 12.0,
  max_fps = 240,
  animation_fps = 60,
  background = {
    {
      source = { File = os.getenv("HOME") .. "/dotfiles/terminal/assets/bg-3.jpg" },
      hsb = { brightness = 0.02 },
      opacity = 0.93,
      vertical_align = "Top",
      horizontal_align = "Center",
    },
  },
  keys = {
    { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
  },
}

wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
