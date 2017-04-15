require 'opal'
#require 'native'

module DXOpal
  module Window
    @@fps = 60
    @@width = 640
    @@height = 480

    def self.loop(&block)
      @@ctx ||= _init_ctx(@@width, @@height)
      t0 = Time.now

      @@draw_queue = []
      block.call

      _draw_box_fill(0, 0, @@width, @@height, [0, 0, 0])
      @@draw_queue.sort_by(&:first).each do |item|
        case item[1]
        when :circle then _draw_circle(*item.drop(2))
        when :circle_fill then _draw_circle_fill(*item.drop(2))
        end
      end

      dt = `new Date() - t0` / 1000
      wait = (1000 / @@fps) - dt
      `setTimeout(function(){ #{loop(&block)} }, #{wait})`
    end

    def self.fps; @@fps; end
    def self.fps=(w); @@fps = w; end
    def self.width; @@width; end
    def self.width=(w); @@width = w; end
    def self.height; @@height; end
    def self.height=(h); @@height = h; end

    def self.draw_circle(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle, x, y, r, color])
    end

    def self.draw_circle_fill(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle_fill, x, y, r, color])
    end

    # 
    # private functions
    #

    def self._init_ctx(w, h)
      canvas = `document.getElementById("canvas")`
      `canvas.width = w;
       canvas.height = h;`
      return `canvas.getContext('2d')`
    end

    def self._draw_box_fill(x1, y1, x2, y2, color)
      ctx = @@ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.fillRect(x1, y1, x2-x1, y2-y1); 
      }
    end

    def self._draw_circle(x, y, r, color)
      ctx = @@ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.stroke();
      }
    end

    def self._draw_circle_fill(x, y, r, color)
      ctx = @@ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.fill();
      }
    end

    def self._rgb(color)
      case color.length
      when 4
        rgb = color[1, 3]
      when 3
        rgb = color
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgb(" + rgb.join(', ') + ")";
    end

    def self._rgba(color)
      case color.length
      when 4
        rgba = color[3] + color[1, 3]
      when 3
        rgba = color + [255]
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgba(" + rgba.join(', ') + ")"
    end
  end
end

include DXOpal
x = 0
dx = 5
Window.loop do
  x += dx
  dx = -dx if x < 0 || x > Window.width

  Window.draw_circle(x, 100, 20, [128, 255, 255, 255])
  Window.draw_circle_fill(100, 100, 10, [10, 100, 30])
end
