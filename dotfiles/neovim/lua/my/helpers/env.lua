local function makeEnv(cond)
  return {
    active = cond,
    unless = function(f)
      if not cond() then f() end
    end,
    when = function(f)
      if cond() then f() end
    end
  }
end

return {
  vscode = makeEnv(function()
    return vim.g.vscode ~= nil
  end),
  neovide = makeEnv(function()
    return vim.g.neovide ~= nil
  end),
  firevim = makeEnv(function()
    return vim.g.started_by_firenvim ~= nil
  end)
}
