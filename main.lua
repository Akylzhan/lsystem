lsys = require 'l-system'

function love.load()
  scale = 0.5
  height = love.graphics.getHeight() / scale
  width = love.graphics.getWidth() / scale

  t = {
    axiom = 'F-F-F-F-F',
    angle = 72,
    rules = {
      { symbol = 'F', rule = 'F-F-F++F+F-F'},
    },
    pos = {x=300,y=700},
    line_length = 10
  }

  system = lsys.newSystem(t, 4)
end

function love.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.scale(0.5, 0.5)

  for i, positions in ipairs(system) do
    x1 = positions[1]
    y1 = height - positions[2]
    x2 = positions[3]
    y2 = height - positions[4]
    love.graphics.line(x1, y1, x2, y2)
    -- love.graphics.line(positions)
  end
end