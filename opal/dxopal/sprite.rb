require 'dxopal/sprite/collision_check'

module DXOpal
  class Sprite
    include DXOpal::Sprite::CollisionCheck

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
      _init_collision_info(@image)
    end
    attr_accessor :x, :y, :z, :visible

    def image; @image; end
    def image=(img)
      @image = img
      if @collision.nil?
        self.collision = Rect.new(0, 0, img.width, img.height)
      end
    end

    def vanish; @vanished = true; end
    def vanished?; @vanished; end

    def draw
      raise "image not set to Sprite" if @image.nil?
      return if !@visible

      Window.draw(@x, @y, @image)
    end
  end
end
