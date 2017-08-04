module DXOpal
  module Input
    # Internal setup for Input class
    def self._init(canvas)
      @@tick = 0
      @@pressing_keys = pressing_keys = `new Object()`
      @@mouse_info = `{x: 0, y: 0}`

      rect = `canvas.getBoundingClientRect()`
      @@canvas_x = `rect.left + window.pageXOffset`
      @@canvas_y = `rect.top  + window.pageYOffset`

      %x{
        document.addEventListener('keydown', function(ev){
          pressing_keys[ev.keyCode] = #{@@tick};
          ev.preventDefault();
          ev.stopPropagation();
        });
        document.addEventListener('keyup', function(ev){
          pressing_keys[ev.keyCode] = -#{@@tick};
          ev.preventDefault();
          ev.stopPropagation();
        });
        document.addEventListener('mousemove', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
        });
      }
    end
    
    # Called on every frame from Window
    def self._on_tick
      @@tick += 1
    end

    # Return 1 if 'right', -1 if 'left'
    def self.x(pad_number=0)
      ret = 0
      ret += 1 if key_down?(K_RIGHT)
      ret -= 1 if key_down?(K_LEFT)
      ret
    end

    # Return 1 if 'down', -1 if 'up'
    def self.y(pad_number=0)
      ret = 0
      ret += 1 if key_down?(K_DOWN)
      ret -= 1 if key_down?(K_UP)
      ret
    end

    # Return true if the key is being pressed
    def self.key_down?(code)
      return `#{@@pressing_keys}[code] > 0`
    end

    # Return true if the key is just pressed
    def self.key_push?(code)
      return `#{@@pressing_keys}[code] == #{@@tick}-1`
    end

    # Return true if the key is just released
    def self.key_release?(code)
      return `#{@@pressing_keys}[code] == -(#{@@tick}-1)`
    end

    # Return position of mouse cursor
    # (0, 0) is the top-left corner of the canvas
    def self.mouse_x
      return `#{@@mouse_info}.x`
    end
    def self.mouse_y
      return `#{@@mouse_info}.y`
    end
    class << self
      alias mouse_pos_x mouse_x
      alias mouse_pos_y mouse_y
    end
  end
end
