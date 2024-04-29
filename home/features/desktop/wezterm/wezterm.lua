-- {{{ Import stuff & create config object
local wezterm = require("wezterm")
local colorscheme = require("nix.colorscheme") -- injected by nix!

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end
-- }}}

local font_size = 20.0

-- {{{ Theming
local themeMap = {
  ["Gruvbox light, soft"] = "Gruvbox light, soft (base16)",
  ["Gruvbox dark, soft"] = "Gruvbox dark, soft (base16)",
}

config.color_scheme = themeMap[colorscheme.name]
config.colors = {}
-- config.colors = wezterm.color.load_base16_scheme(colorscheme.source)

-- {{{ Window frame
config.window_frame = {
  font = wezterm.font({ family = colorscheme.fonts.sansSerif }),
  font_size = font_size - 3,
  active_titlebar_bg = "none",
  inactive_titlebar_bg = "none",
}

config.window_padding = {
  left = "1cell",
  right = "1cell",
  top = "0.4cell",
  bottom = "0.4cell",
}
-- }}}
-- {{{ Tab bar colors
config.colors.tab_bar = {
  background = "none",
  active_tab = {
    bg_color = colorscheme.transparency.terminal.base00,
    fg_color = colorscheme.base05,
  },
  inactive_tab = {
    bg_color = "none",
    fg_color = colorscheme.base05,
  },
  inactive_tab_hover = {
    bg_color = colorscheme.base00,
    fg_color = colorscheme.base05,
  },
  new_tab = {
    bg_color = colorscheme.base02,
    fg_color = colorscheme.base05,
  },
  new_tab_hover = {
    bg_color = colorscheme.base02,
    fg_color = colorscheme.base05,
    italic = true,
  },

  -- The color of the inactive tab bar edge/divider
  inactive_tab_edge = "none",
}
-- }}}
-- {{{ Other visual things
config.window_background_opacity = colorscheme.transparency.terminal.value
-- }}}
-- }}}
-- {{{ Main config options
config.automatically_reload_config = true
config.warn_about_missing_glyphs = false
config.check_for_updates = false

-- {{{ Fonts
config.adjust_window_size_when_changing_font_size = false -- Makes it work with fixed window sizes.
config.font_size = font_size
config.font = wezterm.font(colorscheme.fonts.monospace)
-- }}}
-- {{{ Tab bar
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
-- }}}
-- {{{ Keycodes
config.disable_default_key_bindings = false
-- config.enable_kitty_keyboard = true -- Let's apps recognise more distinct keys
config.enable_csi_u_key_encoding = true -- For some reason I need this for all keybinds to work inside neovim.
-- }}}
-- }}}
-- {{{ Keybinds
local function unmap(key, mods)
  return {
    key = key,
    mods = mods,
    action = wezterm.action.DisableDefaultAssignment,
  }
end

local function bind_if(cond, key, mods, action)
  local function callback(win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(
        wezterm.action.SendKey({ key = key, mods = mods }),
        pane
      )
    end
  end

  return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

-- {{{ Detect nvim processes
local function is_inside_vim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then
    return false
  end

  local success, _, _ = wezterm.run_child_process({
    "sh",
    "-c",
    "ps -o state= -o comm= -t"
      .. wezterm.shell_quote_arg(tty)
      .. " | "
      .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
  })

  return success
end

local function is_outside_vim(pane)
  return not is_inside_vim(pane)
end
-- }}}

config.keys = {
  -- {{{ Disable certain default keybinds
  unmap("f", "CTRL|SHIFT"),
  unmap("w", "CTRL|SHIFT"),
  unmap("Enter", "ALT"),
  -- }}}
  -- {{{ Nvim nevigation keybinds
  bind_if(
    is_outside_vim,
    "h",
    "CTRL",
    wezterm.action.ActivatePaneDirection("Left")
  ),
  bind_if(
    is_outside_vim,
    "j",
    "CTRL",
    wezterm.action.ActivatePaneDirection("Down")
  ),
  bind_if(
    is_outside_vim,
    "k",
    "CTRL",
    wezterm.action.ActivatePaneDirection("Up")
  ),
  bind_if(
    is_outside_vim,
    "l",
    "CTRL",
    wezterm.action.ActivatePaneDirection("Right")
  ),
  -- }}}
}
-- }}}

-- and finally, return the configuration to wezterm
return config
