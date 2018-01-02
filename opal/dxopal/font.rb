module DXOpal
  # Represents a font
  # Used by Window.draw_font, etc.
  class Font
    def self.default; @@default ||= Font.new(24); end
    def self.default=(f); @@default = f; end

    def initialize(size, fontname=nil, option={})
      @size = size
      @orig_fontname = fontname
      @fontname = fontname || "sans-serif"
    end

    def size; @size; end
    def fontname; @orig_fontname; end

    # Return a string like "48px serif"
    def _spec_str
      "#{@size}px #{@fontname}"
    end
  end
end
