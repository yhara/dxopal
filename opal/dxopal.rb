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

  # Like `Kernel.p`, but prints only limited times for each `key`
  # This is useful for debugging your game without flooding the
  # developer console.
  #
  # Example:
  #   p_ :player_x, @player.x, 20
  P_CT = Hash.new{|h, k| h[k] = 0}
  def p_(key, obj, n=10)
    return if P_CT[key] >= n
    `console.log(#{key}+":", #{obj.inspect})`
    P_CT[key] += 1
  end
end

# `require 'dxopal'` will automatically import names like `Window` to the
# toplevel (as `require 'dxruby'` does)
include DXOpal
