require 'opal'
require 'console'; def console; $console; end

require 'dxopal/constants/colors'
require 'dxopal/font'
require 'dxopal/input'
require 'dxopal/input/key_codes'
require 'dxopal/image'
require 'dxopal/sound'
require 'dxopal/sound_effect'
require 'dxopal/sprite'
require 'dxopal/window'
require 'dxopal/version'
# Enable runtime compilation of Opal code (so that you can make games
# without even install Ruby)
require 'opal-parser'
def require_remote(url)
  %x{
    var r = new XMLHttpRequest();
    r.overrideMimeType("text/plain"); // Patch for Firefox + file://
    r.open("GET", url, false);
    r.send('');
  }
  eval `r.responseText`
end

# These libraries will be included in dxopal.js:
require 'pp'

module DXOpal
  include DXOpal::Constants::Colors
  include DXOpal::Input::KeyCodes
  include DXOpal::Input::MouseCodes
  include DXOpal::SoundEffect::WaveTypes

  # Call block and dump backtrace if an exception is raised.
  # Nothing is shown if a tag with `id='dxopal-errors'` does not exist
  def self.dump_error(&block)
    block.call
  rescue Exception => ex
    div = `document.getElementById('dxopal-errors')`
    if `div && !ex.DXOpalPrinted`
      %x{
        div.textContent = "ERROR: " + #{ex.class.name};
        var ul = document.createElement('ul');
        // Note: ex.backtrace may be an Array or a String
        #{Array(ex.backtrace)}.forEach(function(line){
          var li = document.createElement('li');
          li.textContent = line;
          ul.appendChild(li);
        });
        div.appendChild(ul);
        ex.DXOpalPrinted = true;
      }
    end
    raise ex
  end

  # Like `Kernel.p`, but prints only limited times for each `key`
  # This is useful for debugging your game without flooding the
  # developer console.
  #
  # Example:
  #   p_ player_x: @player.x
  #   p_({player_x: @player.x}, 20)
  P_CT = Hash.new{|h, k| h[k] = 0}
  def p_(hash, n=10)
    key = hash.keys.sort.join
    return if P_CT[key] >= n
    `console.log(#{hash.inspect})`
    P_CT[key] += 1
  end
end

%x{
  // Like `console.log`, but prints only limited times.
  // Example:
  //   Opal.DXOpal.p_("player", player)
  (function(){
    var P_CT = {};
    Opal.DXOpal.p_ = function(key, obj, n) {
      n = (n || 10);
      P_CT[key] = (P_CT[key] || 0);
      if (P_CT[key] < n) {
        console.log(key, obj);
        P_CT[key] += 1;
      }
    };
  })();
}

# `require 'dxopal'` will automatically import names like `Window` to the
# toplevel (as `require 'dxruby'` does)
include DXOpal
