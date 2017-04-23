module DXOpal
  class Sprite
    def self.draw(sprites)
      sprites.flatten.sort_by(&:z).each do |sprite|
        next if sprite.respond_to?(:vanished?) && sprite.vanished?
        sprite.draw
      end
    end

    def initialize(x=0, y=0, image=nil)
      @x, @y, @image = x, y, image
      @z = 0
      @visible = true
      @vanished = false
    end
    attr_accessor :x, :y, :z, :image, :visible

    def vanish; @vanished = true; end
    def vanished?; @vanished; end

    def draw
      raise "image not set to Sprite" if @image.nil?
      return if !@visible

      Window.draw(@x, @y, @image)
    end
  end
end
