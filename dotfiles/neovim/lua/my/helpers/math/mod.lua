local M = {}

function M.modinverse(b, m)
  local g, x, _ = M.gcd(b, m)
  if g ~= 1 then return nil end
  return x % m
end

function M.gcd(a, b)
  if a == 0 then return b, 0, 1 end
  local g, x1, y1 = M.gcd(b % a, a)
  return g, y1 - (math.floor(b / a)) * x1, x1
end

return M
