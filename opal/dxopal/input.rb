module DXOpal
  module Input
    def self.key_down?(code)
      return `#{@@pressing_keys}[code] > 0`
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
  end
end
