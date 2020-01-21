require 'dxopal'
include DXOpal
Window.width = nil
Window.height = nil
Window.load_resources do
  Window.bgcolor = C_BLACK
  closing_circles = []
  mouse_circle = nil

  Window.loop do
    Window.draw_font(0, 0, "Multi touch demo\n(Open with mobile device)", Font.default)

    # Mouse support (for PCs)
    if Input.mouse_down?(M_LBUTTON)
      if mouse_circle
        mouse_circle[2] += 1
      else
        color = [100+rand(155), 100+rand(155), 100+rand(155), 50]
        mouse_circle = [Input.mouse_x, Input.mouse_y, 30, color]
      end
      x, y, radius, color = *mouse_circle
      Window.draw_circle_fill(x, y, radius, color)
    end
    if Input.mouse_release?(M_LBUTTON)
      closing_circles << mouse_circle
      mouse_circle = nil
    end

    Input.new_touches.each do |t|
      t.data[:radius] = 30
      t.data[:color] = [100+rand(155), 100+rand(155), 100+rand(155), 50]
    end
    Input.touches.each do |t|
      t.data[:radius] += 1
      Window.draw_circle_fill(t.x, t.y, t.data[:radius], t.data[:color])
      if t.released?
        closing_circles << [t.x, t.y, t.data[:radius], t.data[:color]]
      end
    end

    closing_circles.map!{|(x, y, radius, color)|
      Window.draw_circle_fill(x, y, radius, color)
      [x, y, radius-1, color]
    }
    closing_circles.delete_if{|(x, y, radius, color)|
      radius <= 0
    }
  end
end
