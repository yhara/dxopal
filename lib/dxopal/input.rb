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

    def self._pressing_keys; @@pressing_keys; end

    # Internal setup for Input class
    def self._init(canvas)
      @@tick = 0
      @@pressing_keys = `new Object()`
      @@mouse_info = `{x: 0, y: 0}`
      @@pressing_mouse_buttons = `new Object()`
      @@touch_info = `{x: 0, y: 0}`
      @@pressing_touch = `new Object()`

      @@canvas = canvas
      rect = `canvas.getBoundingClientRect()`
      @@canvas_x = `rect.left + window.pageXOffset`
      @@canvas_y = `rect.top  + window.pageYOffset`

      self._init_mouse_events
      self._init_touch_events
      self.keyevent_target = `window` unless Input.keyevent_target
    end
    
    # Called on every frame from Window
    def self._on_tick
      @@tick += 1
      self._update_touch_info
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

    #
    # Keyboard
    #

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

    # (private) JS keydown event handler
    ON_KEYDOWN_ = %x{
      function(ev){
        #{Input._pressing_keys}[ev.code] = #{@@tick};
        ev.preventDefault();
        ev.stopPropagation();
      }
    }
    # (private) JS keyup event handler
    ON_KEYUP_ = %x{
      function(ev){
        #{Input._pressing_keys}[ev.code] = -#{@@tick};
        ev.preventDefault();
        ev.stopPropagation();
      }
    }
    # Set DOM element to receive keydown/keyup event
    #
    # By default, `window` is set to this (i.e. all key events are
    # stolen by DXOpal.) If canvas element is set to this, only key events
    # happend on canvas are processed by DXOpal.
    def self.keyevent_target=(target)
      if keyevent_target
        %x{
          #{@@keyevent_target}.removeEventListener('keydown', #{ON_KEYDOWN_});
          #{@@keyevent_target}.removeEventListener('keyup', #{ON_KEYUP_});
        }
      end
      @@keyevent_target = target
      %x{
        if (#{@@keyevent_target}.tagName == "CANVAS") {
          #{@@keyevent_target}.setAttribute('tabindex', 0);
        }
        #{@@keyevent_target}.addEventListener('keydown', #{ON_KEYDOWN_});
        #{@@keyevent_target}.addEventListener('keyup', #{ON_KEYUP_});
      }
    end

    # Return DOM element set by `keyevent_target=`
    def self.keyevent_target
      return nil unless class_variable_defined?(:@@keyevent_target)
      @@keyevent_target
    end

    #
    # Mouse
    #

    # (internal) initialize mouse events
    def self._init_mouse_events
      %x{
        document.addEventListener('mousemove', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
        });
        document.addEventListener('mousedown', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
          for (var k=1; k<=16; k<<=1) {
            if (ev.buttons & k) {
              #{@@pressing_mouse_buttons}[k] = #{@@tick};
            }
          }
        });
        document.addEventListener('mouseup', function(ev){
          #{@@mouse_info}.x = ev.pageX - #{@@canvas_x};
          #{@@mouse_info}.y = ev.pageY - #{@@canvas_y};
          // ev.button => ev.buttons
          table = { 0: 1, 1: 4, 2: 2, 3: 8, 4: 16 };
          for (var k=1; k<=16; k<<=1) {
            if (#{@@pressing_mouse_buttons}[k]) {
              #{@@pressing_mouse_buttons}[table[ev.button]] = -#{@@tick};
            }
          }
        });
      }
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
      raise "missing argument of `mouse_down?'" unless mouse_code
      return `#{@@pressing_mouse_buttons}[mouse_code] > 0`
    end

    # Return true if the mouse button is pressed in the last tick
    def self.mouse_push?(mouse_code)
      raise "missing argument of `mouse_push?'" unless mouse_code
      return `#{@@pressing_mouse_buttons}[mouse_code] == -(#{@@tick}-1)`
    end

    # Return true if the mouse button is released in the last tick
    def self.mouse_release?(mouse_code)
      raise "missing argument of `mouse_release?'" unless mouse_code
      return `#{@@pressing_mouse_buttons}[mouse_code] == -(#{@@tick}-1)`
    end

    #
    # Touch
    #

    # (internal) initialize touch events
    def self._init_touch_events
      @@touches = {}
      @@new_touches = []
      %x{
        #{@@canvas}.addEventListener('touchmove', function(ev){
          ev.preventDefault();
          ev.stopPropagation();
          #{@@touch_info}.x = ev.changedTouches[0].pageX - #{@@canvas_x};
          #{@@touch_info}.y = ev.changedTouches[0].pageY - #{@@canvas_y};
          for (var touch of ev.changedTouches) {
            const id = touch.identifier;
            const x = touch.pageX - #{@@canvas_x};
            const y = touch.pageY - #{@@canvas_y};
            #{@@touches[`id`]&._move(`x`, `y`)}
          }
        });
        #{@@canvas}.addEventListener('touchstart', function(ev){
          ev.preventDefault();
          ev.stopPropagation();
          #{@@touch_info}.x = ev.changedTouches[0].pageX - #{@@canvas_x};
          #{@@touch_info}.y = ev.changedTouches[0].pageY - #{@@canvas_y};
          #{@@pressing_touch}[0] = #{@@tick};
          for (var touch of ev.changedTouches) {
            const id = touch.identifier;
            const x = touch.pageX - #{@@canvas_x};
            const y = touch.pageY - #{@@canvas_y};
            #{
              new_touch = Touch.new(`id`, `x`, `y`)
              @@touches[`id`] = new_touch
              @@new_touches.push(new_touch)
            }
          }
        });
        #{@@canvas}.addEventListener('touchend', function(ev){
          ev.preventDefault();
          ev.stopPropagation();
          #{@@touch_info}.x = ev.changedTouches[0].pageX - #{@@canvas_x};
          #{@@touch_info}.y = ev.changedTouches[0].pageY - #{@@canvas_y};
          #{@@pressing_touch}[0] = -#{@@tick};
          for (var touch of ev.changedTouches) {
            const id = touch.identifier;
            #{@@touches[`id`]&._released(@@tick)}
          }
        });
      }
    end

    def self._update_touch_info
      # Clear old data
      @@touches.delete_if{|id, t| t.released? && t._released_at < @@tick-1}
    end

    #
    # Single touch
    #

    # Return position of touch
    # (0, 0) is the top-left corner of the canvas
    def self.touch_x
      return `#{@@touch_info}.x`
    end
    def self.touch_y
      return `#{@@touch_info}.y`
    end
    class << self
      alias touch_pos_x touch_x
      alias touch_pos_y touch_y
    end

    # Return true if the touch is being pressed
    def self.touch_down?
      return `#{@@pressing_touch}[0] > 0`
    end

    # Return true if the touch is pressed in the last tick
    def self.touch_push?
      return `#{@@pressing_touch}[0] == -(#{@@tick}-1)`
    end

    # Return true if the touch is released in the last tick
    def self.touch_release?
      return `#{@@pressing_touch}[0] == -(#{@@tick}-1)`
    end

    #
    # Multi touches
    #
    
    # Represents a touch
    class Touch
      def initialize(id, x, y)
        @id = id
        _move(x, y)
        @_released_at = nil
        @data = {}
      end
      attr_reader :id, :x, :y, :data, :_released_at

      # Return true if this touch is released in the last tick
      def released?
        !!@_released_at
      end

      def inspect
        rel = (released_at ? " released_at=#{released_at}" : "")
        "#<DXOpal::Touch id=#{id} x=#{x} y=#{y} data=#{data.inspect}#{rel}>"
      end

      def _move(x, y)
        @x = x
        @y = y
      end

      def _released(tick)
        @_released_at = tick
      end
    end

    # Returns current touches as an array of Input::Touch
    def self.touches
      @@touches.values
    end

    # Returns newly created touches
    def self.new_touches
      ret = @@new_touches
      @@new_touches = []
      ret
    end
  end
end
