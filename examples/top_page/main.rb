require 'dxopal'; include DXOpal
Window.width = 300
Window.height = 300
Window.bgcolor = C_WHITE
Window.load_resources do
  x = rand(Window.width)
  y = rand(Window.height)
  dx = dy = 2
  Window.loop do
    Window.draw_circle_fill(x, y, 10, C_RED)
    dx = -dx if x < 0 || x > Window.width
    dy = -dy if y < 0 || y > Window.height
    x += dx
    y += dy
  end
end
