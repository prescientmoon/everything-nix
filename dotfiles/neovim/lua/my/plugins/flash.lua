local function keybind(keys, action, desc, modes)
  if modes == nil then
    modes = { "n", "x", "o" }
  end

  return {
    keys,
    mode = modes,
    function()
      require("flash")[action]()
    end,
    desc = desc,
  }
end

local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
  keys = {
    keybind("s", "jump", "Flash"),
    keybind("S", "treesitter", "Flash Treesitter"),
    keybind("r", "remote", "Remote Flash", { "o" }),
    keybind("R", "treesitter_search", "Treesitter Search", { "o", "x" }),
    keybind("<C-S>", "toggle", "Toggle Flash Search", { "c" }),
  },
}

return M
