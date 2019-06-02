#
# Patch to ignore `require "dxopal"`
#

# TODO: why this does not work?
#module DXOpal
#  module PatchRequire
#    def require(*args)
#      if args == ['dxopal']
#        # Do nothing
#      else
#        super
#      end
#    end
#  end
#
#  Kernel.prepend(PatchRequire)
#end

module Kernel
  alias dxopal_orig_require require
end

def require(*args)
  if args == ['dxopal']
    # Do nothing, because DXOpal is already loaded and you don't need to find it
  else
    dxopal_orig_require(*args)
  end
end
