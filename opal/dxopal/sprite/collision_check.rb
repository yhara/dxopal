module DXOpal
  class Sprite
    # Methods of Sprite related to collision checking
    module CollisionCheck
      Point = Struct.new(:x, :y)
      Circle = Struct.new(:x, :y, :r)
      class Rect < Struct.new(:x1, :y1, :x2, :y2)
        def inspect
          "#<Rect#{[x1, y1, x2, y2].inspect}>"
        end
      end
      Triangle = Struct.new(:x1, :y1, :x2, :y2, :x3, :y3)

      # Called from Sprites#initialize
      def _init_collision_info(image)
        @collision = nil
        @collision_enable = true
        @_collision_areas = image ? [Rect.new(0, 0, image.width, image.height)] : nil
      end
      attr_accessor :collision_enable
      attr_reader :collision, :_collision_areas

      def collision=(arg)
        areas = (arg[0] === Array) ? arg : [arg]
        @_collision_areas = areas.map{|x|
          case x.length
          when 2 then Point.new(*x)
          when 3 then Circle.new(*x)
          when 4 then Rect.new(*x)
          when 6 then Triangle.new(*x)
          else 
            raise "Inlivad area data: #{x.inspect}"
          end
        }
        @collision = arg
      end

      # Return true when this sprite collides with other sprite(s)
      def ===(sprite_or_sprites)
        return check(sprite_or_sprites).any?
      end

      # Return list of sprites collides with this sprite
      def check(sprite_or_sprites)
        sprites = Array(sprite_or_sprites)
        return sprites.select{|sprite| _collides?(sprite)}
      end

      # Return true when this sprite collides with `sprite`
      def _collides?(sprite)
        raise "Sprite image not set" if @_collision_areas.nil?
        return false if !self._collidable? || !sprite._collidable?
        return @_collision_areas.any?{|area1|
          sprite._collision_areas.any?{|area2|
            CollisionCheck.collides?(area1, @x, @y,
                                     area2, sprite.x, sprite.y)
          }
        }
      end

      # Return true when this sprite may collide
      def _collidable?
        return !@vanished && @collision_enable
      end

      # Return true when two areas collide with each other
      def self.collides?(a, ax, ay, b, bx, by)
        if a.is_a?(Rect) && b.is_a?(Rect)
          ret = a.x2 + ax >= b.x1 + bx &&
                a.x1 + ax <= b.x2 + bx &&
                a.y2 + ay >= b.y1 + by &&
                a.y1 + ay <= b.y2 + by
          ret
        else
          raise NotImplementedError, "collision detection not yet "+
            "implemented for #{a.inspect} and #{b.inspect}"
        end
      end
    end
  end
end
