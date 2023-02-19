local function makeEnv(cond)
  return {
    -- I am doing this to get type hints!
    active = function()
      return cond
    end,
    not_active = function()
      return not cond()
    end,
    unless = function(f)
      if not cond() then
        f()
      end
    end,
    when = function(f)
      if cond() then
        f()
      end
    end,
  }
end

return {
  vscode = makeEnv(function()
    return vim.g.vscode ~= nil
  end),
  neovide = makeEnv(function()
    return vim.g.neovide ~= nil or require("nix.env") == "neovide"
  end),
  firenvim = makeEnv(function()
    return vim.g.started_by_firenvim ~= nil
  end),
  _and = function(a, b)
    return makeEnv(function()
      return a.active() and b.active()
    end)
  end,
  _or = function(a, b)
    return makeEnv(function()
      return a.active() or b.active()
    end)
  end,
}
