config = {}

config.height = 800
config.width = 1200
config.scale = 0.5

config.system = {
  variables = 'F',
  skip_variables = '',
  axiom = 'F',
  angle = 22.5,
  rules = {
    {symbol = 'F', rule = 'FF+[+F-F-F]-[-F+F+F]'},
  },
  pos = {x = 1200, y = 100},
  dir = {x = 0,y = 1},
  line_length = 30
}

config.iterations = 4

return config