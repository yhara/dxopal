module DXOpal
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
end
