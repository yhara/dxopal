module DXOpal
  module Window
    @@fps = 60
    @@width = 640
    @@height = 480
    @@block = nil
    @@paused = false

    # Load resources specified with Image.register or Sound.register
    # Call block when loaded
    def self.load_resources(&block)
      RemoteResource._load_resources(&block)
    end

    def self.loop(&block)
      @@block = block
      _loop(&block)
    end

    # (DXOpal original) Pause & resume
    def self.pause
      @@paused = true
      @@draw_queue.clear
      draw_pause_screen
    end
    def self.paused?; @@paused; end
    def self.resume
      raise "Window.resume is called before Window.loop" if @@block.nil?
      @@paused = false; Window.loop(&@@block)
    end
    def self.draw_pause_screen
      Window.draw_box_fill(0, 0, Window.width, Window.height, C_BLACK)
      Window.draw_font(0, 0, "...PAUSE...", Font.default, color: C_WHITE)
    end

    def self._loop(&block)
      @@img ||= _init(@@width, @@height)
      t0 = Time.now
      Input._on_tick

      @@draw_queue = []
      if @@paused
        Window.draw_pause_screen
      else
        block.call
      end

      @@img.box_fill(0, 0, @@width, @@height, [0, 0, 0])
      @@draw_queue.sort_by(&:first).each do |item|
        case item[1]
        when :image then @@img.draw(*item.drop(2))
        when :font then @@img.draw_font(*item.drop(2)) 
        when :box_fill then @@img.box_fill(*item.drop(2))
        when :circle then @@img.circle(*item.drop(2))
        when :circle_fill then @@img.circle_fill(*item.drop(2))
        end
      end

      unless @@paused
        dt = `new Date() - t0` / 1000
        wait = (1000 / @@fps) - dt
        `setTimeout(function(){ #{loop(&block)} }, #{wait})`
      end
    end

    def self._init(w, h)
      canvas = `document.getElementById("canvas")`
      img = Image.new(w, h, canvas: canvas)
      Input._init(canvas)
      return img
    end

    def self.fps; @@fps; end
    def self.fps=(w); @@fps = w; end
    def self.width; @@width; end
    def self.width=(w); @@width = w; end
    def self.height; @@height; end
    def self.height=(h); @@height = h; end

    def self.draw(x, y, image, z=0)
      @@draw_queue.push([z, :image, x, y, image])
    end

    def self.draw_font(x, y, string, font, option={})
      z = option[:z] || 0
      color = option[:color] || [255, 255, 255]
      @@draw_queue.push([z, :font, x, y, string, font, color])
    end

    def self.draw_box_fill(x1, y1, x2, y2, color, z=0)
      @@draw_queue.push([z, :box_fill, x1, y1, x2, y2, color])
    end

    def self.draw_circle(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle, x, y, r, color])
    end

    def self.draw_circle_fill(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle_fill, x, y, r, color])
    end
  end
end
