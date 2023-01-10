local K = require("my.keymaps")
local env = require("my.helpers.env")

local M = {
  "preservim/vimux", -- interact with tmux from within vim
  cmd = { "VimuxPromptCommand", "VimuxRunCommand", "VimuxRunLastCommand" },
  -- TODO: only enable when actually inside tmux
  cond = env.vscode.not_active()
    and env.neovide.not_active()
    and env.firenvim.not_active(),
}

function M.init()
  --{{{ Register keybinds
  K.nmap(
    "<leader>vp",
    ":VimuxPromptCommand<CR>",
    "[V]imux: [p]rompt for command"
  )
  K.nmap("<leader>vc", ':VimuxRunCommand "clear"<CR>', "[V]imux: [c]lear pane")
  K.nmap(
    "<leader>vl",
    ":VimuxRunLastCommand<CR>",
    "[V]imux: rerun [l]ast command"
  )
  --}}}
  --{{{ Register which-key docs
  local status, wk = pcall(require, "which-key")

  if status then
    wk.register({
      ["<leader>v"] = {
        name = "[V]imux",
      },
    })
  end
  --}}}
end

return M
