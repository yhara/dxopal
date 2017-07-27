module DXOpal
  module Window
    @@fps = 60
    @@real_fps = 0
    @@real_fps_ct = 1
    @@real_fps_t = Time.now
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
      `window`.JS.requestAnimationFrame{ _loop(&block) }
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

      # Calculate fps
      if t0 - @@real_fps_t >= 1.0
        @@real_fps = @@real_fps_ct
        @@real_fps_ct = 1
        @@real_fps_t = t0
      else
        @@real_fps_ct += 1
      end

      # Detect inputs
      Input._on_tick

      # Call user code
      @@draw_queue = []
      if @@paused
        Window.draw_pause_screen
      else
        block.call
      end

      # Draw
      @@img.box_fill(0, 0, @@width, @@height, [0, 0, 0])
      @@draw_queue.sort.each do |item|
        case item[2]
        when :image then @@img.draw(*item.drop(3))
        when :font then @@img.draw_font(*item.drop(3)) 
        when :pixel then @@img.[]=(*item.drop(3))
        when :line then @@img.line(*item.drop(3))
        when :box then @@img.box(*item.drop(3))
        when :box_fill then @@img.box_fill(*item.drop(3))
        when :circle then @@img.circle(*item.drop(3))
        when :circle_fill then @@img.circle_fill(*item.drop(3))
        end
      end

      `window`.JS.requestAnimationFrame{ _loop(&block) }
    end

    def self._init(w, h)
      canvas = `document.getElementById("canvas")`
      img = Image.new(w, h, canvas: canvas)
      Input._init(canvas)
      return img
    end

    def self.fps; @@fps; end
    def self.fps=(w); @@fps = w; end
    def self.real_fps; @@real_fps; end
    def self.width; @@width; end
    def self.width=(w); @@width = w; end
    def self.height; @@height; end
    def self.height=(h); @@height = h; end

    def self.draw(x, y, image, z=0)
      enqueue_draw(z, :image, x, y, image)
    end

    def self.draw_font(x, y, string, font, option={})
      z = option[:z] || 0
      color = option[:color] || [255, 255, 255]
      enqueue_draw(z, :font, x, y, string, font, color)
    end

    def self.draw_pixel(x, y, color, z=0)
      enqueue_draw(z, :pixel, x, y, color)
    end

    def self.draw_line(x1, y1, x2, y2, color, z=0)
      enqueue_draw(z, :line, x1, y1, x2, y2, color)
    end

    def self.draw_box(x1, y1, x2, y2, color, z=0)
      enqueue_draw(z, :box, x1, y1, x2, y2, color)
    end

    def self.draw_box_fill(x1, y1, x2, y2, color, z=0)
      enqueue_draw(z, :box_fill, x1, y1, x2, y2, color)
    end

    def self.draw_circle(x, y, r, color, z=0)
      enqueue_draw(z, :circle, x, y, r, color)
    end

    def self.draw_circle_fill(x, y, r, color, z=0)
      enqueue_draw(z, :circle_fill, x, y, r, color)
    end

    def self.enqueue_draw(z, *args)
      @@draw_queue.push([z, @@draw_queue.length, *args])
    end
  end
end
