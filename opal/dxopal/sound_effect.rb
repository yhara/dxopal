module DXOpal
  # User-generated sound
  #
  # Example:
  #   v = 80
  #   SoundEffect.register(:sound1, 4000, WAVE_RECT, 5000) do
  #     v = v - 0.03
  #     [rand(300), v]
  #   end
  class SoundEffect < Sound
    RemoteResource.add_class(SoundEffect)

    module WaveTypes
      WAVE_SIN = :sine
      WAVE_SAW = :sawtooth
      WAVE_TRI = :triangle
      WAVE_RECT = :square
    end

    # time : Total number of ticks
    #   When resolution=1000(default), `time` is equivalent to the 
    #   total length of the sound in milliseconds.
    # wave_type : Type of wave form
    # resolution : Number of ticks per second
    # block : Should return [freq(0~44100), volume(0~255)]
    def self._load(time, wave_type=WAVE_RECT, resolution=1000, &block)
      snd = new("(soundeffect)")
      snd_promise = %x{
        new Promise(function(resolve, reject){
          var n_channels = 1;
          var context = #{Sound.audio_context};
          var n_ticks = #{time};
          var totalSeconds = #{time / resolution};
          var valuesPerSecond = context.sampleRate;
          var n_values = totalSeconds * valuesPerSecond;
          var myArrayBuffer = context.createBuffer(n_channels, n_values, valuesPerSecond);
          var values = myArrayBuffer.getChannelData(0);
          var n = 0;
          for (var i = 0; i < n_ticks; i++) {
            var ret = #{block.call};
            var freq = ret[0], volume = ret[1];
            if (freq < 0) freq = 0;
            if (freq > 44100) freq = 44100;
            if (volume < 0) volume = 0;
            if (volume > 255) volume = 255;
            var vol = volume / 255;   // 0.0~1.0

            var period = valuesPerSecond * 1 / freq;
            for (; n < ((i+1) / n_ticks * n_values); n++) {
              var phase = (n % period) / period; // 0.0~1.0
              var value; // -1.0~1.0
              switch(#{wave_type}) {
              case "sine":
                value = Math.sin(2 * Math.PI * phase) * 2 - 1;
                break;
              case "sawtooth":
                value = phase * 2 - 1;
                break;
              case "triangle":
                value = phase < 0.25 ?  0+phase*4 :
                        phase < 0.5  ?  1-(phase-0.25)*4 :
                        phase < 0.75 ?  0-(phase-0.5)*4 :
                                       -1+(phase-0.75)*4;
                break;
              case "square":
                value = (phase < 0.5 ? 1 : -1);
                break;
              default:
                #{raise "unknown wave_type: " + wave_type.inspect};
              }
              values[n] = value * vol;
            }
          }
          snd['$decoded='](myArrayBuffer);
          resolve();
        });
      }
      return snd, snd_promise
    end

    def add(wave_type=WAVE_RECT, resolution=1000)
      TODO
    end
  end
end
