-- TODO: branch support
-- TODO: support skipping symbol

local l_system = {}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function unpackPositions(t)
  return t[1], t[2], t[3], t[4]
end

local function rotate(t, radians)
  cos = math.cos(radians)
  sin = math.sin(radians)
  x = t.x
  y = t.y
  t.x = x * cos - y * sin
  t.y = x * sin + y * cos

  if math.abs(t.x) <= 1e-9 then
    t.x = 0
  end
  if math.abs(t.y) <= 1e-9 then
    t.y = 0
  end
  return t
end


-- unpacking axiom
local function rewriteRules(str, rules, iteration_count)
  if iteration_count < 0 then
    error("iteration_count is less than 1")
  end

  str = str:gsub(' ', '')
  for i,j in pairs(rules) do rules[i].rule = rules[i].rule:gsub(' ', '') end

  -- TODO: optimize this chunk
  -- maybe rewrite it recursively?
  for i = 0, iteration_count - 1 do
    result = {}
    for c in str:gmatch"." do
      replace_rule_position = nil
      for k, elem in ipairs(rules) do
        if c == elem.symbol then
          replace_rule_position = k
          break
        end
      end
      if replace_rule_position then
        table.insert(result, rules[replace_rule_position].rule)
      else
        table.insert(result, c)
      end
    end
    str = table.concat(result)
  end
  return str
end


local function parseCharacter(t, c)
  to_draw = false
  if c == '+' then
    t.stack[#t.stack].angle = t.stack[#t.stack].angle + t.angle
  elseif c == '-' then
    t.stack[#t.stack].angle = t.stack[#t.stack].angle - t.angle
  elseif c == '|' then
    t.stack[#t.stack].angle = t.stack[#t.stack].angle + math.rad(180)
  elseif c == '#' then
    t.stack[#t.stack].line_length = t.stack[#t.stack].line_length + t.line_length
  elseif c == '!' then
    t.stack[#t.stack].line_length = t.stack[#t.stack].line_length - t.line_length
  elseif c == '[' then
    t.stack[#t.stack + 1] = {}
    t.stack[#t.stack].angle = t.stack[#t.stack - 1].angle + math.rad(45)
    t.stack[#t.stack].pos = deepcopy(t.stack[#t.stack - 1].pos)
    t.stack[#t.stack].line_length = t.stack[#t.stack - 1].line_length * 0.65
    t.stack[#t.stack - 1].line_length = t.stack[#t.stack - 1].line_length * 0.65
  elseif c == ']' then
    t.stack[#t.stack] = nil
    t.pos = deepcopy(t.stack[#t.stack].pos)
    t.stack[#t.stack].angle = t.stack[#t.stack].angle - math.rad(45)
  elseif t.variables:find(c) then
    dir = {}
    dir.x = t.dir.x * t.stack[#t.stack].line_length
    dir.y = t.dir.y * t.stack[#t.stack].line_length
    
    new_pos = rotate(dir, t.stack[#t.stack].angle)
    
    t.pos.x = t.pos.x + new_pos.x
    t.pos.y = t.pos.y + new_pos.y
    
    to_draw = true
  end

  return to_draw, t
end


function l_system.newSystem(t, iteration_count)
  t.angle = t.angle or 0
  t.line_length = t.line_length or 5
  t.pos = t.pos or {x=0,y=0}

  rule = rewriteRules(t.axiom, t.rules, iteration_count)

  system = {}
  system.variables = t.variables
  system.line_length = t.line_length
  system.angle = math.rad(t.angle)
  system.last_pos = deepcopy(t.pos)
  system.pos = deepcopy(t.pos)
  system.dir = t.dir
  system.stack = {{pos = system.last_pos, angle = 0, line_length = t.line_length}}

  positions = {}
  for c in rule:gmatch"." do
    to_draw, system = parseCharacter(system, c)
    if to_draw then
      last_pos = system.stack[#system.stack].pos
      table.insert(positions,
          { last_pos.x, last_pos.y,
            system.pos.x, system.pos.y })
      system.stack[#system.stack].pos = deepcopy(system.pos)
    end
  end
  -- print(rule)
  -- for i,j in pairs(positions) do
  --   for k,l in ipairs(j) do
  --     print(l)
  --   end
  --   print()
  -- end

  return positions
end

return l_system