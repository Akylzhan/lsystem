lsys = require 'l-system'
config = require 'config'

function love.load()
  height = config.height
  width = config.width
  scale = config.scale

  love.window.setMode(width, height)

  height = height / scale
  width = width / scale

  system = lsys.newSystem(config.system, config.iterations)
end

function love.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.scale(scale, scale)

  for i, v in ipairs(system.positions) do
    love.graphics.line(v[1], height - v[2], v[3], height - v[4])
  end
end