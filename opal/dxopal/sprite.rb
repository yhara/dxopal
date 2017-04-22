module DXOpal
  class Sprite
    def initialize(x=0, y=0, image=nil)
      @x, @y, @image = x, y, image
      @z = 0
      @visible = true
    end
    attr_accessor :x, :y, :z, :image, :visible

    def draw
      raise "image not set to Sprite" if @image.nil?
      return if !@visible

      Window.draw(@x, @y, @image)
    end
  end
end
