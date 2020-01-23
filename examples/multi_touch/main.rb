require 'dxopal'
include DXOpal

# h: 0-359
# s: 0-100
# l: 0-100
def hsl2rgb(h, s, l)
  if l < 50
    max = 2.55 * (l + l*(s/100.0))
    min = 2.55 * (l - l*(s/100.0))
  else
    max = 2.55 * (l + (100-l)*(s/100.0))
    min = 2.55 * (l - (100-l)*(s/100.0))
  end
  case h
  when 0...60
    [max, (h/60.0)*(max-min) + min, min]
  when 60...120
    [((120-h)/60.0)*(max-min) + min, max, min]
  when 120...180
    [min, max, ((h-120)/60.0)*(max-min) + min]
  when 180...240
    [min, ((240-h)/60.0)*(max-min) + min, max]
  when 240...300
    [((h-240)/60.0)*(max-min) + min, min, max]
  else
    [max, min, ((360-h)/60.0)*(max-min) + min]
  end
end

def random_color
  [200, *hsl2rgb(rand(360), 100, 50)]
end

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
        color = random_color()
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
      t.data[:color] = random_color()
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
