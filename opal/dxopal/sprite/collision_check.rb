require 'dxopal/sprite/collision_area'

module DXOpal
  class Sprite
    # Methods of Sprite related to collision checking
    module CollisionCheck
      # Called from Sprites#initialize
      def _init_collision_info(image)
        @collision ||= nil
        @collision_enable = true if @collision_enable.nil?
        @collision_sync = true if @collision_sync.nil?
        @_collision_area ||=
          if image
            CollisionArea::Rect.new(self, 0, 0, image.width, image.height)
          else
            nil
          end
      end
      # Whether collision is detected for this object (default: true)
      attr_accessor :collision_enable
      # Whether collision areas synchronize with .scale and .angle (default: true)
      # Setting this to false may improve collision detection performance
      attr_accessor :collision_sync
      # Return an array represents its collision area
      attr_reader :collision
      # (internal) Return a CollisionArea object
      attr_reader :_collision_area

      # Set collision area of this sprite
      def collision=(area_spec)
        @_collision_area =
          case area_spec.length
          when 2 then CollisionArea::Point.new(self, *area_spec)
          when 3 then CollisionArea::Circle.new(self, *area_spec)
          when 4 then CollisionArea::Rect.new(self, *area_spec)
          when 6 then CollisionArea::Triangle.new(self, *area_spec)
          else 
            raise "Inlivad area data: #{x.inspect}"
          end
        @collision = area_spec
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
        if @_collision_area.nil? || sprite._collision_area.nil?
          raise "Sprite image not set"
        end
        return false if !self._collidable? || !sprite._collidable?
        return @_collision_area.collides?(sprite._collision_area)
      end

      # Return true when this sprite may collide
      def _collidable?
        return !@vanished && @collision_enable
      end

#      # Return true when two areas collide with each other
#      def self.collides?(a, ax, ay, b, bx, by)
#        if a.is_a?(Rect) && b.is_a?(Rect)
#          # Opal 
#          ax1 = a.x1 + ax
#          ay1 = a.y1 + ay
#          ax2 = a.x2 + ax
#          ay2 = a.y2 + ay
#          bx1 = b.x1 + bx
#          by1 = b.y1 + by
#          bx2 = b.x2 + bx
#          by2 = b.y2 + by
#
#          return ax2 >= bx1 &&
#          ax1 <= bx2 &&
#          ay2 >= by1 &&
#          ay1 <= by2 
#
#          # JS
##          return %x{ ax2 >= bx1 &&
##            ax1 <= bx2 &&
##            ay2 >= by1 &&
##            ay1 <= by2 
##          }
#
#          # WASM
##          return `window.rect_rect(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2) ==  1`
#        elsif a.is_a?(Circle) && b.is_a?(Circle)
#          # Opal
#          ax, ay = a.x+ax, a.y+ay
#          bx, by = b.x+bx, b.y+by
#          ar, br = a.r, b.r
##          Math.sqrt((ax-bx)**2 + (ay-by)**2) < a.r + b.r
#
#          # JavaScript
#          %x{
#//            var ax = a['$$data'].x+ax, ay = a['$$data'].y+ay,
#//                bx = b['$$data'].x+bx, by = b['$$data'].y+by;
#//            return Math.sqrt((ax-bx)**2 + (ay-by)**2) < a['$$data'].r + b['$$data'].r
#            return Math.sqrt((ax-bx)**2 + (ay-by)**2) < ar + br
#          }
#        else
#          raise NotImplementedError, "collision detection not yet "+
#            "implemented for #{a.inspect} and #{b.inspect}"
#        end
#      end
    end
  end
end
