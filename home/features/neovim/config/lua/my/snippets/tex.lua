local M = {}

local ls = require("luasnip")
local extras = require("luasnip.extras")
local conds = require("luasnip.extras.expand_conditions")
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local n = extras.nonempty

local autosnippets = {}

-- {{{ Helpers
local function unlines(...)
  return table.concat({ ... }, "\n")
end

local function flatten(arr)
  local result = {}
  for _, subarray in ipairs(arr) do
    if type(subarray) == "table" then
      for _, value in ipairs(subarray) do
        table.insert(result, value)
      end
    else
      table.insert(result, subarray)
    end
  end
  return result
end

local function trig(name)
  return { name = name, trig = name }
end
-- }}}
-- {{{ Math mode detection
-- Taken from: https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/main/lua/luasnip-latex-snippets/util/ts_utils.lua
local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local TEXT_NODES = {
  text_mode = true,
  label_definition = true,
  label_reference = true,
}

local function get_node_at_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  -- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
  local row, col = pos[1] - 1, pos[2]

  local parser = vim.treesitter.get_parser(0, "latex")
  if not parser then
    return
  end

  local root_tree = parser:parse({ row, col, row, col })[1]
  local root = root_tree and root_tree:root()
  if not root then
    return
  end

  return root:named_descendant_for_range(row, col, row, col)
end

local function in_text(check_parent)
  local node = get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      if check_parent then
        -- For \text{}
        local parent = node:parent()
        if parent and MATH_NODES[parent:type()] then
          return false
        end
      end

      return true
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true
end

local function in_mathzone()
  local node = get_node_at_cursor()
  while node do
    if TEXT_NODES[node:type()] then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

local function not_math()
  return in_text(true)
end
-- }}}
-- {{{ Start of line & non-math
local beginTextCondition = function(...)
  return conds.line_begin(...) and not_math()
end

local parseBeginText = ls.extend_decorator.apply(ls.parser.parse_snippet, {
  condition = beginTextCondition,
}) --[[@as function]]

local snipBeginText = ls.extend_decorator.apply(ls.snippet, {
  condition = beginTextCondition,
}) --[[@as function]]

local function env(name)
  return "\\begin{" .. name .. "}\n\t$0\n\\end{" .. name .. "}"
end

local function optional_square_bracket_arg(index, default)
  return sn(index, {
    n(1, "[", ""),
    i(1, default),
    n(1, "]", ""),
  })
end

local function theorem_env(name, prefix)
  return snipBeginText(trig(name), {
    t("\\begin{" .. name .. "}"),
    optional_square_bracket_arg(1),
    n(2, "\\label{" .. prefix .. ":", ""),
    i(2),
    n(2, "}", ""),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{" .. name .. "}" }),
  })
end

vim.list_extend(autosnippets, {
  parseBeginText(
    { trig = "begin", name = "Begin / end environment" },
    env("$1")
  ),
  -- {{{ Chapters / sections
  parseBeginText(trig("chapter"), "\\chapter{$1}\n$0"),
  parseBeginText(trig("section"), "\\section{$1}\n$0"),
  parseBeginText(trig("subsection"), "\\subsection{$1}\n$0"),
  parseBeginText(trig("subsubsection"), "\\subsubsection{$1}\n$0"),
  -- }}}
  -- {{{ Lists
  parseBeginText({ trig = "item", name = "List item" }, "\\item"),
  parseBeginText({ trig = "olist", name = "Ordered list" }, env("enumerate")),
  parseBeginText({ trig = "ulist", name = "Unordered list" }, env("itemize")),
  -- }}}
  -- {{{ Theorem envs
  theorem_env("theorem", "thm"),
  theorem_env("lemma", "lem"),
  theorem_env("exercise", "exe"),
  theorem_env("definition", "def"),
  theorem_env("corollary", "cor"),
  theorem_env("example", "exa"),
  snipBeginText(trig("proof"), {
    t("\\begin{proof}"),
    optional_square_bracket_arg(1),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{proof}" }),
  }),
  -- }}}
  -- {{{ Special structures
  parseBeginText(
    { trig = "ciff", name = "If and only if cases" },
    unlines(
      "\\begin{enumerate}",
      "\t\\item[$\\implies$]$1",
      "\t\\item[$\\impliedby$]$2",
      "\\end{enumerate}",
      "$0"
    )
  ),
  -- }}}
})
-- }}}
-- {{{ Non-math
local parseText = ls.extend_decorator.apply(ls.parser.parse_snippet, {
  condition = not_math,
}) --[[@as function]]

local snipText = ls.extend_decorator.apply(ls.snippet, {
  condition = not_math,
}) --[[@as function]]

local function ref(name, prefix)
  return {
    parseText(
      { trig = "r" .. name, name = name .. " reference" },
      "\\ref{" .. prefix .. ":$1}$0"
    ),
    parseText(
      { trig = "pr" .. name, name = name .. " reference" },
      "(\\ref{" .. prefix .. ":$1})$0"
    ),
  }
end

vim.list_extend(
  autosnippets,
  flatten({
    -- {{{ References
    ref("theorem", "thm"),
    ref("lemma", "lem"),
    ref("exercise", "exe"),
    ref("definition", "def"),
    ref("corollary", "cor"),
    ref("example", "exa"),
    {
      parseText({ trig = "ref", name = "reference" }, "\\ref{$1}$0"),
      parseText({ trig = "pref", name = "reference" }, "(\\ref{$1})$0"),
    },
    -- }}}
    {
      -- {{{ Misc
      parseText(trig("quote"), "``$1''$0"),
      parseText(trig("forcecr"), "{\\ \\\\\\\\}"),
      -- }}}
      -- {{{ Let ...
      snipText(
        { trig = "([Ll]et)", trigEngine = "pattern", name = "definition" },
        {
          f(function(_, snip)
            return snip.captures[1]
          end),
          t(" "),
          sn(1, fmt("${} ≔ {}$", { i(1), i(2) })),
        }
      ),
      -- }}}
      -- {{{ Display / inline math
      parseText({ trig = "dm", name = "display math" }, env("align*")),
      parseText({ trig = "im", name = "inline math" }, "\\$$1\\$$0"),
      -- }}}
    },
  })
)
-- }}}

function M.setup()
  ls.add_snippets("tex", autosnippets, {
    type = "autosnippets",
    default_priority = 0,
  })
end

return M
