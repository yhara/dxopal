require 'opal'
require 'console'; def console; $console; end

require 'dxopal/constants/colors'
require 'dxopal/font'
require 'dxopal/input'
require 'dxopal/input/key_codes'
require 'dxopal/image'
require 'dxopal/sound'
require 'dxopal/sprite'
require 'dxopal/window'
# Enable runtime compilation of Opal code (so that you can make games
# without even install Ruby)
require 'opal-parser'
# These libraries will be included in dxopal.js:
require 'pp'

module DXOpal
  include DXOpal::Constants::Colors
  include DXOpal::Input::KeyCodes
end

# `require 'dxopal'` will automatically import names like `Window` to the
# toplevel (as `require 'dxruby'` does)
include DXOpal
