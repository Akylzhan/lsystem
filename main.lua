lsys = require 'l-system'

function love.load()
  height = 800
  width = 1200
  love.window.setMode(width, height)

  scale = 0.5
  height = height / scale
  width = width / scale

  t = {
    variables = 'F',
    axiom = 'F',
    angle = 45,
    rules = {
      {symbol = 'F', rule = '-F++F-'},
      -- {symbol = 'Y', rule = '-FX-Y'},
    },
    pos = {x=725,y=1000},
    dir = {x=1,y=0},
    line_length = 30
  }

  system = lsys.newSystem(t, 10)
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