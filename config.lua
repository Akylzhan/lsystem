config = {}

config.height = 800
config.width = 1200
config.scale = 0.5

config.system = {
  variables = 'F',
  skip_variables = '',
  axiom = 'F+XF+F+XF',
  angle = 90,
  rules = {
    {symbol = 'X', rule = 'XF-F+F-XF+F+XF-F+F-X'},
  },
  pos = {x = 2000, y = 800},
  dir = {x = 0,y = 1},
  line_length = 10
}

config.iterations = 5

return config