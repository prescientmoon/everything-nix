local M = {
  "ThePrimeagen/harpoon",
}

local function bindHarpoon(key, index)
  vim.keymap.set("n", "<C-s>" .. key, function()
    require("harpoon.ui").nav_file(index)
  end, { desc = "Harpoon file " .. index })
end

function M.init()
  vim.keymap.set("n", "<leader>H", function()
    require("harpoon.mark").add_file()
  end, { desc = "Add file to [h]arpoon" })
  vim.keymap.set("n", "<C-a>", function()
    require("harpoon.ui").toggle_quick_menu()
  end, { desc = "Toggle harpoon quickmenu" })

  bindHarpoon("q", 1)
  bindHarpoon("w", 2)
  bindHarpoon("e", 3)
  bindHarpoon("r", 4)
  bindHarpoon("a", 5)
  bindHarpoon("s", 6)
  bindHarpoon("d", 7)
  bindHarpoon("f", 8)
  bindHarpoon("z", 9)
end

return M
