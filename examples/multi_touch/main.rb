require 'dxopal'
include DXOpal
Window.width = nil
Window.height = nil
Window.load_resources do
  Window.bgcolor = C_BLACK
  closing_circles = []

  Window.loop do
    Window.draw_font(0, 0, "Multi touch demo\n(Open with mobile device)", Font.default)

    Input.new_touches.each do |t|
      t.data[:radius] = 30
      t.data[:color] = [100+rand(155), 100+rand(155), 100+rand(155)]
    end
    Input.touches.each do |t|
      t.data[:radius] += 1
      Window.draw_circle(t.x, t.y, t.data[:radius], t.data[:color])
      if t.released?
        closing_circles << [t.x, t.y, t.data[:radius], t.data[:color]]
      end
    end

    closing_circles.map!{|(x, y, radius, color)|
      Window.draw_circle(x, y, radius, color)
      [x, y, radius-1, color]
    }
    closing_circles.delete_if{|(x, y, radius, color)|
      radius <= 0
    }
  end
end
