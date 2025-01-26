require 'dxopal/remote_resource'

module DXOpal
  class Sound < RemoteResource
    RemoteResource.add_class(Sound)

    # Return AudioContext
    def self.audio_context
      @@audio_context ||= %x{
        new (window.AudioContext||window.webkitAudioContext)
      }
    end

    # Load remote sound (called via Window.load_resources)
    def self._load(path_or_url)
      snd = new(path_or_url)
      snd_promise = %x{
        new Promise(function(resolve, reject) {
          var request = new XMLHttpRequest();
          request.open('GET', #{path_or_url}, true);
          request.responseType = 'arraybuffer';
          request.onload = function() {
            var audioData = request.response;
            var context = #{Sound.audio_context};
            context.decodeAudioData(audioData, function(decoded) {
              snd['$decoded='](decoded);
              resolve();
            });
          };
          request.send();
        });
      }
      return snd, snd_promise
    end

    def initialize(path_or_url)
      @path_or_url = path_or_url  # Used in error message
      @gain_node = Sound.audio_context.JS.createGain()
      set_volume(230)
    end
    attr_accessor :decoded

    # Play this sound
    def play(loop_ = false)
      raise "Sound #{path_or_url} is not loaded yet" unless @decoded
      source = nil
      %x{
        var context = #{Sound.audio_context};
        source = context.createBufferSource();
        source.buffer = #{@decoded};
        if (#{loop_}) {
          source.loop = true;
        }
        source
          .connect(#{@gain_node})
          .connect(context.destination);
        source.start(0); 
      }
      @source = source
    end

    # Stop playing this sound (if playing)
    def stop
      return unless @decoded 
      return unless @source
      @source.JS.stop()
    end

    # TODO: support for volume change using 'time' parameter
    def set_volume(volume, time=0)
      %x{
        var normalized = (volume > 255 ? 255 : volume) / 255;
        var db = (normalized - 1) * 96;
        #{@gain_node}.gain.value = Math.pow(10, db / 20);
      }
    end
  end
end
