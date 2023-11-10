local env = require("my.helpers.env")

local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  cond = env.firenvim.not_active() and env.vscode.not_active(),
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local wk = require("which-key")
        local gs = package.loaded.gitsigns

        -- {{{ Helpers
        local function map(mode, from, to, desc, expr)
          vim.keymap.set(
            mode,
            from,
            to,
            { expr = expr, silent = true, buffer = bufnr, desc = desc }
          )
        end

        local function exprmap(from, to, desc)
          map("n", from, to, desc, true)
        end
        -- }}}
        -- {{{ Navigation
        exprmap("]c", function()
          if vim.wo.diff then
            return "]c"
          end

          vim.schedule(function()
            gs.next_hunk()
          end)

          return "<Ignore>"
        end, "Navigate to next hunk")

        exprmap("[c", function()
          if vim.wo.diff then
            return "[c"
          end

          vim.schedule(function()
            gs.prev_hunk()
          end)

          return "<Ignore>"
        end, "Navigate to previous hunk")
        -- }}}
        -- {{{ Actions
        local prefix = "<leader>h"

        wk.register({
          [prefix] = { name = "gitsigns" },
        })

        -- {{{ Normal mode
        map("n", prefix .. "s", gs.stage_hunk, "[s]tage hunk")
        map("n", prefix .. "r", gs.reset_hunk, "[r]eset hunk")
        map("n", prefix .. "S", gs.stage_buffer, "[s]tage buffer")
        map("n", prefix .. "u", gs.undo_stage_hunk, "[u]ndo hunk staging")
        map("n", prefix .. "R", gs.reset_buffer, "[r]eset buffer")
        map("n", prefix .. "p", gs.preview_hunk, "[p]review hunk")
        map("n", prefix .. "b", function()
          gs.blame_line({ full = true })
        end, "[b]lame line")
        map("n", prefix .. "d", gs.diffthis, "[d]iff this")
        map("n", prefix .. "D", function()
          gs.diffthis("~")
        end, "[d]iff file (?)")
        -- }}}
        -- {{{ Toggles
        map(
          "n",
          prefix .. "tb",
          gs.toggle_current_line_blame,
          "[t]oggle line [b]laming"
        )
        map("n", prefix .. "td", gs.toggle_deleted, "[t]oggle [d]eleted")
        -- }}}
        -- {{{ Visual
        map("v", prefix .. "s", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "stage visual hunk")
        map("v", prefix .. "r", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "reset visual hunk")
        -- }}}
        -- }}}
        -- {{{ Text objects
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Inside hunk")
        -- }}}
      end,
    })
  end,
}

return M
