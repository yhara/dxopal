require 'dxopal/constants/colors'

module DXOpal
  module Window
    @@fps = 60
    @@fps_ts = nil
    @@fps_ct = 0
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
      RemoteResource._load_resources do
        DXOpal.dump_error(&block)
      end
    end

    # Start main loop
    #
    # When called twice, previous loop is stopped (this is useful
    # when implementing interactive game editor, etc.)
    def self.loop(&block)
      already_running = !!@@block
      @@block = block
      return if already_running
      self_ = self
      `window`.JS.requestAnimationFrame{|time| self_._loop(time) }
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

    # (internal) call @@block periodically
    def self._loop(timestamp)
      @@img ||= _init

      # Calculate fps
      frame_msec = 1000.0 / @@fps
      @@fps_ts ||= timestamp
      passed_msec = timestamp - @@fps_ts
      @@fps_ts = timestamp
      @@fps_ct += passed_msec
      if @@fps_ct >= frame_msec
        @@fps_ct -= frame_msec
      else
        self_ = self
        `window`.JS.requestAnimationFrame{|time| self_._loop(time) }
        return
      end

      # Calculate real_fps
      t = Time.now
      if t - @@real_fps_t >= 1.0
        @@real_fps = @@real_fps_ct
        @@real_fps_ct = 1
        @@real_fps_t = t
      else
        @@real_fps_ct += 1
      end

      # Update physics
      Sprite.matter_tick(timestamp) if Sprite.matter_enabled?

      # Detect inputs
      Input._on_tick

      # Call user code
      @@draw_queue = []
      if @@paused
        Window.draw_pause_screen
      else
        DXOpal.dump_error(&@@block)
      end

      # Draw
      @@img.box_fill(0, 0, @@width, @@height, @@bgcolor)
      sorted = @@draw_queue.sort{|a, b| a[0] == b[0] ? a[1] <=> b[1] : a[0] <=> b[0] }
      sorted.each do |item|
        case item[2]
        when :image then @@img.draw(*item.drop(3))
        when :image_rot then @@img.draw_rot(*item.drop(3))
        when :image_scale then @@img.draw_scale(*item.drop(3))
        when :draw_ex then @@img.draw_ex(*item.drop(3))
        when :font then @@img.draw_font(*item.drop(3)) 
        when :pixel then @@img.[]=(*item.drop(3))
        when :line then @@img.line(*item.drop(3))
        when :box then @@img.box(*item.drop(3))
        when :box_fill then @@img.box_fill(*item.drop(3))
        when :circle then @@img.circle(*item.drop(3))
        when :circle_fill then @@img.circle_fill(*item.drop(3))
        when :triangle then @@img.triangle(*item.drop(3))
        when :triangle_fill then @@img.triangle_fill(*item.drop(3))
        end
      end

      self_ = self
      `window`.JS.requestAnimationFrame{|time| self_._loop(time) }
    end

    def self._init
      canvas = `document.getElementById("dxopal-canvas")`
      # If user did not change Window.width/Window.height, set the canvas size here
      self.width = @@width
      self.height = @@height
      img = Image.new(self.width, self.height, canvas: canvas)
      Input._init(canvas)
      return img
    end

    # Return internal DXOpal::Image object (for experimental/hacking use)
    def self._img; @@img; end

    def self.fps; @@fps; end
    def self.fps=(w); @@fps = w; end
    def self.real_fps; @@real_fps; end
    def self.width; @@width; end
    # Set window width and resize the canvas
    # Set `nil` to maximize canvas
    def self.width=(w)
      canvas = `document.getElementById("dxopal-canvas")`
      @@width = w || `window.innerWidth`
      `canvas.width = #{@@width}`
      `canvas.style.width = #{@@width}`
    end
    def self.height; @@height; end
    # Set window height and resize the canvas
    # Set `nil` to maximize canvas
    def self.height=(h)
      canvas = `document.getElementById("dxopal-canvas")`
      @@height = h || `window.innerHeight`
      `canvas.height = #{@@height}`
      `canvas.style.height = #{@@height}`
    end
    @@bgcolor = Constants::Colors::C_BLACK
    def self.bgcolor; @@bgcolor; end
    def self.bgcolor=(col); @@bgcolor = col; end

    def self.draw(x, y, image, z=0)
      enqueue_draw(z, :image, x, y, image)
    end

    def self.draw_scale(x, y, image, scale_x, scale_y, center_x=nil, center_y=nil, z=0)
      enqueue_draw(z, :image_scale, x, y, image, scale_x, scale_y, center_x, center_y)
    end

    def self.draw_rot(x, y, image, angle, center_x=nil, center_y=nil, z=0)
      enqueue_draw(z, :image_rot, x, y, image, angle, center_x, center_y)
    end

    def self.draw_ex(x, y, image, options={})
      enqueue_draw(options[:z] || 0, :draw_ex, x, y, image, options)
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

    def self.draw_triangle(x1, y1, x2, y2, x3, y3, color, z=0)
      enqueue_draw(z, :triangle, x1, y1, x2, y2, x3, y3, color)
    end

    def self.draw_triangle_fill(x1, y1, x2, y2, x3, y3, color, z=0)
      enqueue_draw(z, :triangle_fill, x1, y1, x2, y2, x3, y3, color)
    end

    # (internal)
    def self.enqueue_draw(z, *args)
      @@draw_queue.push([z, @@draw_queue.length, *args])
    end
  end
end
