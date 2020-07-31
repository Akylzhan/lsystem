lsys = require 'l-system'

function love.load()
  height = 800
  width = 1200
  love.window.setMode(width, height)

  scale = 0.5
  height = height / scale
  width = width / scale

  t = {
    variables = 'FG',
    axiom = 'F-G-G',
    angle = 120,
    rules = {
      {symbol = 'F', rule = 'F-G+F+G-F'},
      {symbol = 'G', rule = 'GG'},
    },
    pos = {x=500 ,y=200},
    dir = {x=0,y=1},
    line_length = 30
  }

  system = lsys.newSystem(t, 6)
  -- for i, positions in ipairs(system) do
  --   print(unpackPositions(positions))
  -- end
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