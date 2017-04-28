module DXOpal
  class Sound
    # Return AudioContext
    def self.audio_context
      @@audio_context ||= %x{
        new (window.AudioContext||window.webkitAudioContext)
      }
    end

    # Load remote sound
    # Instance of Sound is returned immediately, but Window.loop will
    # wait until sound is load
    def initialize(path_or_url)
      @snd_promise = %x{
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
      Window._add_remote_resource(@snd_promise)
    end

    # Play this sound once
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
end
