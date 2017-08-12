module DXOpal
  module Input
    module MouseCodes
      M_LBUTTON = 1
      M_RBUTTON = 2
      M_MBUTTON = 4
      # DXOpal extention
      M_4TH_BUTTON = 8
      M_5TH_BUTTON = 16
    end

    # Internal setup for Input class
    def self._init(canvas)
      @@tick = 0
      @@pressing_keys = pressing_keys = `new Object()`
      @@mouse_info = `{x: 0, y: 0}`
      @@pressing_mouse_buttons = pressing_mouse_buttons = `new Object()`

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
        document.addEventListener('mousedown', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
          for (var k=1; k<=16; k<<=1) {
            if (ev.buttons & k) {
              pressing_mouse_buttons[k] = #{@@tick};
            }
          }
        });
        document.addEventListener('mouseup', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
          for (var k=1; k<=16; k<<=1) {
            if ((ev.buttons & k) == 0 && pressing_mouse_buttons[k]) {
              pressing_mouse_buttons[k] = -#{@@tick};
            }
          }
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

    # Return true if the mouse button is being pressed
    def self.mouse_down?(mouse_code)
      return `#{@@pressing_mouse_buttons}[mouse_code] > 0`
    end

    # Return true if the mouse button is pressed in the last tick
    def self.mouse_push?(mouse_code)
      return `#{@@pressing_mouse_buttons}[mouse_code] == -(#{@@tick}-1)`
    end

    # Return true if the mouse button is released in the last tick
    def self.mouse_release?(mouse_code)
      return `#{@@pressing_mouse_buttons}[mouse_code] == -(#{@@tick}-1)`
    end
  end
end
