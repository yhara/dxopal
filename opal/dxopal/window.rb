module DXOpal
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
      @@img ||= _init_img(@@width, @@height)
      t0 = Time.now
      Input._on_tick

      @@draw_queue = []
      block.call

      @@img.box_fill(0, 0, @@width, @@height, [0, 0, 0])
      @@draw_queue.sort_by(&:first).each do |item|
        case item[1]
        when :image then @@img.draw(*item.drop(2))
        when :circle then @@img.circle(*item.drop(2))
        when :circle_fill then @@img.circle_fill(*item.drop(2))
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
            resolve(raw_img);
          };
          raw_img.src = path_or_url;
        });
      }
      @@remote_resources << promise
      return promise
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

    def self._init_img(w, h)
      canvas = `document.getElementById("canvas")`
      img = Image.new(w, h, canvas: canvas)
      return img
    end
  end
end
