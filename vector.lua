vector = {}
vector.__index = vector

function vector:new(x, y)
  x = x or 0
  y = y or 0
  if isVector2(x) then
    return vector:new(x.x, x.y)
  end
  return setmetatable({x=x,y=y}, vector)
end

function vector:rotated(radians)
  cos, sin = math.cos(radians), math.sin(radians)
  return self:new(self.x * cos - self.y * sin, self.x * sin + self.y * cos)
end

function isVector2(v)
  return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function vector:clone()
  return self:new(self.x, self.y)
end

function vector:unpack()
  return self.x, self.y
end

function vector:mult(v)
  assert(isVector2(v), "argument 2 is not vector")
  return self:new(self.x * v.x, self.y * v.y)
end

function vector:div(v)
  assert(isVector2(v), "argument 2 is not vector")
  return self:new(self.x / v.x, self.y / v.y)
end

function vector:add(v)
  assert(isVector2(v), "argument 2 is not vector")
  return self:new(self.x + v.x, self.y + v.y)
end

function vector:sub(v)
  assert(isVector2(v), "argument 2 is not vector")
  return self:new(self.x - v.x, self.y - v.y)
end

return vector