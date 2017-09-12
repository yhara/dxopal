require 'dxopal/sprite/collision_check'
require 'dxopal/sprite/physics'

module DXOpal
  class Sprite
    include DXOpal::Sprite::CollisionCheck
    include DXOpal::Sprite::Physics

    # TODO: implement arguments `shot` and `hit`
    def self.check(offences, defences, shot=:shot, hit=:hit)
      if offences.equal?(defences)
        # any-vs-any mode
        sprites = offences.select{|x| x.is_a?(Sprite)}
        n = sprites.length
        %x{
          for (var i=0; i<n; i++) {
            for (var j=i+1; j<n; j++) {
              if (sprites[i]['$==='](sprites[j])) {
                sprites[i]['$hit']();
                sprites[j]['$hit']();
              }
            }
          }
        }
      else
        # offence-vs-defence mode
        %x{
          for (var i=0; i<offences.length; i++) {
            for (var j=i+1; j<defences.length; j++) {
              if (offences[i]['$==='](defences[j])) {
                offences[i]['$shot']();
                defences[j]['$hit']();
              }
            }
          }
        }
      end
    end

    # Default callback methods of `Sprite.check`
    def shot(other); end
    def hit(other); end

    # Call #update on each sprite (unless it is vanished or do not have #update)
    def self.update(sprites)
      sprites.each do |sprite|
        next if !sprite.respond_to?(:update)
        next if sprite.respond_to?(:vanished?) && sprite.vanished?
        sprite.update
      end
    end

    # Remove vanished sprites (and nils) from the array, destructively
    def self.clean(sprites)
      sprites.reject!{|sprite|
        sprite.nil? || sprite.vanished?
      }
    end

    # Draw each of the given sprites (unless it is vanished)
    def self.draw(sprites)
      sprites.flatten.sort_by(&:z).each do |sprite|
        next if sprite.respond_to?(:vanished?) && sprite.vanished?
        sprite.draw
      end
    end

    def initialize(x=0, y=0, image=nil)
      @x, @y, @image = x, y, image
      @z = 0
      @angle = 0
      @scale_x = @scale_y = 1.0
      if image
        @center_x = image.width / 2
        @center_y = image.height / 2
      end

      @visible = true
      @vanished = false
      _init_collision_info(@image)
    end
    attr_accessor :z, :visible

    # Set angle (0~360, default: 0)
    attr_accessor :angle
    # Set horizontal/vertical scale (default: 1.0)
    attr_accessor :scale_x, :scale_y
    # Set rotation center (default: center of `image`)
    attr_accessor :center_x, :center_y

    attr_reader :x, :y

    def x=(newx)
      @x = newx
      _move_matter_body if @_matter_body
    end

    def y=(newy)
      @y = newy
      _move_matter_body if @_matter_body
    end

    def image; @image; end
    def image=(img)
      @image = img
      if @collision.nil?
        self.collision = Rect.new(0, 0, img.width, img.height)
      end
      if @center_x.nil?
        @center_x = img.width / 2
        @center_y = img.height / 2
      end
    end

    def vanish; @vanished = true; end
    def vanished?; @vanished; end

    # Draw this sprite to Window
    def draw
      raise "image not set to Sprite" if @image.nil?
      return if !@visible

      # TODO: scale_x, scale_y
      Window.draw_rot(@x, @y, @image, @angle, @center_x, @center_y)
    end
  end
end
