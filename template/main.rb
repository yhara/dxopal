require 'dxopal'
include DXOpal
Window.load_resources do
  Window.bgcolor = C_BLACK

  Window.loop do
    Window.draw_font(0, 0, "Hello!", Font.default, color: C_WHITE)
  end
end
