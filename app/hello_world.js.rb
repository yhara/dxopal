require 'opal'
#require 'native'

module DXOpal
  module Input
    def self.key_down?(code)
      return `#{@@pressing_keys}[code]`
    end

    def self.key_push?(code)
      return `#{@@pressing_keys}[code] == #{@@tick}-1`
    end

    def self.key_release?(code)
      return `#{@@pressing_keys}[code] == -(#{@@tick}-1)`
    end

    def self._init
      @@tick = 0
      @@pressing_keys = pressing_keys = `new Object()`
      %x{
        document.addEventListener('keydown', function(ev){
          pressing_keys[ev.key] = #{@@tick};
          ev.preventDefault();
          ev.stopPropagation();
        });
        document.addEventListener('keyup', function(ev){
          pressing_keys[ev.key] = -#{@@tick};
          ev.preventDefault();
          ev.stopPropagation();
        });
      }
    end
    
    def self._on_tick
      @@tick += 1
    end

    module KeyCodes
      K_SPACE = " "
      K_X = "x"
    end
  end
  include Input::KeyCodes

  module Window
    @@fps = 60
    @@width = 640
    @@height = 480

    # List of Promise
    @@remote_resources = []

    def self.loop(&block)
      %x{
        Promise.all(#{@@remote_resources}).then(function() {
          #{_loop(&block)}
        });
      }
    end

    def self._loop(&block)
      @@ctx ||= _init_ctx(@@width, @@height)
      t0 = Time.now
      Input._on_tick

      @@draw_queue = []
      block.call

      _draw_box_fill(0, 0, @@width, @@height, [0, 0, 0])
      @@draw_queue.sort_by(&:first).each do |item|
        case item[1]
        when :image then _draw_image(*item.drop(2))
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

    def self.draw(x, y, image, z=0)
      @@draw_queue.push([z, :image, x, y, image])
    end

    def self.draw_circle(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle, x, y, r, color])
    end

    def self.draw_circle_fill(x, y, r, color, z=0)
      @@draw_queue.push([z, :circle_fill, x, y, r, color])
    end

    # 
    # private functions
    #
    
    def self._load_remote_image(path_or_url)
      raw_img = `new Image()`
      promise = %x{
        new Promise(function(resolve, reject) {
          raw_img.onload = function() {
            resolve();
          };
          raw_img.src = path_or_url;
        });
      }
      @@remote_resources << promise
      return raw_img
    end

    def self._load_remote_sound(path_or_url)
      promise = %x{
        new Promise(function(resolve, reject) {
          var request = new XMLHttpRequest();
          request.open('GET', #{path_or_url}, true);
          request.responseType = 'arraybuffer';
          request.onload = function() {
            var audioData = request.response;
            var context = #{Sound.audio_context};
            context.decodeAudioData(audioData, function(decoded) {
              resolve(decoded);
            });
          };
          request.send();
        });
      }
      @@remote_resources << promise
      return promise
    end

    def self._init_ctx(w, h)
      canvas = `document.getElementById("canvas")`
      `canvas.width = w;
       canvas.height = h;`
      return `canvas.getContext('2d')`
    end

    def self._draw_image(x, y, image)
      ctx = @@ctx
      %x{
        ctx.drawImage(#{image.raw_img}, x, y);
      }
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

  class Image
    def self.load(path_or_url)
      raw_img = Window._load_remote_image(path_or_url)
      new(raw_img)
    end

    def initialize(raw_img)
      @raw_img = raw_img
    end
    attr_reader :raw_img
  end

  class Sound
    def self.audio_context
      @@audio_context ||= %x{
        new (window.AudioContext||window.webkitAudioContext)
      }
    end

    def initialize(path_or_url)
      @snd_promise = Window._load_remote_sound(path_or_url)
    end

    def play
      `#{@snd_promise}.then(function(decoded){
        var context = #{Sound.audio_context};
        var source = context.createBufferSource();
        source.buffer = decoded;
        source.connect(context.destination);
        source.start(0); 
      });`
    end
  end

  Input._init
end

include DXOpal
x = 0
y = 150
dx = 10

image = Image.load('app/ringo.png')
sound = Sound.new('app/get.wav')

Window.loop do
  if x < 0 || x > Window.width
    dx = -dx
  end
  if Input.key_push?(K_SPACE)
    x += dx
    sound.play
  end
  #x += dx

  Window.draw_circle(x, 100, 20, [128, 255, 255, 255])
  Window.draw_circle_fill(100, 100, 10, [10, 100, 30])

  Window.draw(x, y, image)
end
