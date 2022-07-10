local wezterm = require 'wezterm'

function is_dark_mode()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2> /dev/null")
  local result = handle:read("*a")
  handle:close()

  return result:find("Dark", 1, true) == 1
end

function color_scheme()
  if is_dark_mode() then
    return "Afterglow"
  else 
    return "Tomorrow"
  end
end

local function clamp(component)
  return math.min(math.max(component, 0), 255)
end
function color_mod(col, amt)
  local num = tonumber(col:gsub("#", ""), 16, 16)
  local r = math.floor(num / 0x10000) + amt
  local g = (math.floor(num / 0x100) % 0x100) + amt
  local b = (num % 0x100) + amt
  return string.format("%#x", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b)):gsub("0x", "#")
end

local theme = wezterm.get_builtin_color_schemes()[color_scheme()]

return {
  -- Platform
  send_composed_key_when_left_alt_is_pressed = true,

  -- Window
  scrollback_lines = 100000,
  initial_cols = 100,
  initial_rows = 30,

  -- Apperance
  font = wezterm.font('Iosevka Term', {stretch="Expanded", weight="Regular"}),
  use_fancy_tab_bar = true,
  inactive_pane_hsb = {
    saturation = 0.75,
    brightness = 0.65,
  },
  window_frame = {
    inactive_titlebar_bg = color_mod(theme.background, -15),
    inactive_titlebar_fg = theme.foreground,
    active_titlebar_bg = color_mod(theme.background, -15),
    active_titlebar_fg = theme.foreground,
  },
  color_scheme = color_scheme(),
  colors = {
    tab_bar = {
      inactive_tab_edge = color_mod(theme.background, -15),
      active_tab = {
        bg_color = theme.background,
        fg_color = theme.selection_fg,
      },
      inactive_tab = {
        bg_color = color_mod(theme.background, -15),
        fg_color = theme.selection_fg,
      },
      inactive_tab_hover = {
        bg_color = color_mod(theme.background, -5),
        fg_color = theme.selection_fg,
      },
      new_tab = {
        bg_color = color_mod(theme.background, -15),
        fg_color = theme.selection_fg,
      },
      new_tab_hover = {
        bg_color = color_mod(theme.background, -5),
        fg_color = theme.selection_fg,
      }
    },
  },

  -- Keys
  keys = {
    -- Use Shift+Cmd+K to first clear screen and viewport
    {key="k", mods="CMD", action=wezterm.action.ClearScrollback("ScrollbackAndViewport")},
    {key="k", mods="CMD|SHIFT", action=wezterm.action.ClearScrollback("ScrollbackAndViewport")},
    -- Split vertically
    {key="d", mods="CMD", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
    -- Split horizontally
    {key="d", mods="CMD|SHIFT", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    -- Close split pane
    {key="w", mods="CMD", action=wezterm.action.CloseCurrentPane{confirm=false}},
    -- Pane switch by direction
    {key="LeftArrow", mods="CMD|SHIFT", action=wezterm.action.ActivatePaneDirection("Left")},
    {key="RightArrow", mods="CMD|SHIFT", action=wezterm.action.ActivatePaneDirection("Right")},
    {key="UpArrow", mods="CMD|SHIFT", action=wezterm.action.ActivatePaneDirection("Up")},
    {key="DownArrow", mods="CMD|SHIFT", action=wezterm.action.ActivatePaneDirection("Down")},
  },
}

