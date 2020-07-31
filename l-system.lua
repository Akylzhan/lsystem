Vector2 = require 'vector'

local l_system = {}

-- unpacking axiom
local function rewriteRules(str, rules, iteration_count)
  if iteration_count < 1 then
    return str
  end

  result = ""
  for c in str:gmatch"." do
    new_symbol = c
    for k, elem in ipairs(rules) do
      if c == elem.symbol then
        new_symbol = elem.rule
        break
      end
    end
    result = result .. new_symbol
  end
  return rewriteRules(result, rules, iteration_count - 1)
end

local function redraw(self)
  local pos = self.pos
  local last_pos = self.pos
  local dir = self.dir
  local current_line_length = self.line_length
  local current_angle = 0
  local stack = {}
  local variables = self.variables
  local skip_variables = self.skip_variables
  local rule = self.rule

  local function unpack(st)
    return st[1], st[2], st[3], st[4]
  end

  for c in rule:gmatch"." do
    if     c == '+' then
      current_angle = current_angle + self.angle
    elseif c == '-' then
      current_angle = current_angle - self.angle
    elseif c == '|' then
      current_angle = current_angle + math.rad(180)
    elseif c == '#' then
      current_line_length = current_line_length + self.line_length
    elseif c == '!' then
      current_line_length = current_line_length + self.line_length
    elseif c == '[' then
      stack[#stack + 1] = {pos, last_pos, current_line_length, current_angle}
      current_line_length = current_line_length * 0.8 -- line length factor
    elseif c == ']' then
      pos, last_pos, current_line_length, current_angle = unpack(stack[#stack])
      stack[#stack] = nil -- TODO: Lua@5.4 change nil to undef
    elseif variables:find(c) then
      d = dir:mult(Vector2:new(current_line_length, current_line_length))
      d = d:rotated(current_angle)
      pos = pos:add(d)
      table.insert(self.positions, {last_pos.x, last_pos.y, pos.x, pos.y})
      last_pos = pos:clone()
    elseif skip_variables:find(c) then
      d = dir:mult(Vector2:new(current_line_length, current_line_length))
      d = d:rotated(current_angle)
      pos = pos:add(d)
      last_pos = pos:clone()
    end
  end
end

function l_system.newSystem(t, iteration_count)
  t.angle = t.angle or 0
  t.line_length = t.line_length or 5
  t.pos = t.pos or Vector2:new(0,0)

  t.axiom = t.axiom:gsub(' ', '')
  for i, elem in ipairs(t.rules) do
    elem.rule = elem.rule:gsub(' ', '')
  end

  local rule = rewriteRules(t.axiom, t.rules, iteration_count)

  local system = {
    rule = rule,
    variables = t.variables,
    skip_variables = t.skip_variables,
    line_length = t.line_length,
    angle = math.rad(t.angle),
    pos = Vector2:new(t.pos),
    dir = Vector2:new(t.dir),
    redraw = redraw,
    positions = {}
  }
  system:redraw()
  return system
end

return l_system