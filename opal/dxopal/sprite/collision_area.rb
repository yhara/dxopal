require 'dxopal/sprite/collision_checker'

module DXOpal
  class Sprite
    # Methods of Sprite related to collision checking
    module CollisionArea
      class Base
        def initialize
          #@checker = CollisionChecker::OpalChecker.new
          #@checker = CollisionChecker::JsChecker.new
          @checker = CollisionChecker::WasmChecker.new
        end

        # Return a string like "Point", "Rect", etc.
        # Used for type checking in `collides?` (because Opal's Class#is_a? is not very fast)
        def type
          raise "override me"
        end

        def absolute(poss)
          return poss if !@sprite.collision_sync
          xs = []
          ys = []
          %x{
            var rad = Math.PI / 180.0 * #{@sprite.angle};
            var sin = Math.sin(rad);
            var cos = Math.cos(rad);
            var data1x = #{@sprite.scale_x} * cos;
            var data1y = #{@sprite.scale_y} * sin;
            var data2x = #{@sprite.scale_x} * sin;
            var data2y = #{@sprite.scale_y} * cos;
            var cx = #{@sprite.center_x};
            var cy = #{@sprite.center_y};
            poss.forEach(function(pos){
              var x = pos[0], y = pos[1];
              x2 = (x - cx) * data1x - (y - cy) * data1y + cx + #{@sprite.x}
              y2 = (x - cx) * data2x + (y - cy) * data2y + cy + #{@sprite.y}
              xs.push(x2)
              ys.push(y2)
            });
          }
          return xs, ys
        end
      end

      class Point < Base
        def initialize(sprite, x, y)
          @sprite, @x, @y = sprite, x, y
          super()
        end

        def type; :Point; end

        def pos
          absolute_pos([@x, @y])
        end

        def collides?(other)
          case other.type
          when :Point
            self.pos == other.pos
          when :Circle
            TODO
          when :Rect
            TODO
          when :Triangle
            TODO
          else raise
          end
        end
      end

      class Circle < Base
        def initialize(sprite, x, y, r)
          @sprite, @x, @y, @r = sprite, x, y, r
          super()
        end

        def type; :Circle; end

        def collides?(other)
          case other.type
          when :Point
            other.collides?(self)
          when :Circle
            TODO
          when :Rect
            TODO
          when :Triangle
            TODO
          else raise
          end
        end
      end

      class Rect < Base
        def initialize(sprite, x1, y1, x2, y2)
          @sprite, @x1, @y1, @x2, @y2 = sprite, x1, y1, x2, y2
          super()
        end
        attr_reader :x1, :y1, :x2, :y2

        def type; :Rect; end

        def inspect
          "#<CollisionArea::Rect(#{@x1}, #{@y1}, #{@x2}, #{@y2})>"
        end

        def collides?(other)
          case other.type
          when :Point, :Circle
            other.collides?(self)
          when :Rect
            raise "TODO" if @sprite.angle != 0 || @sprite.scale_x != 1 || @sprite.scale_y != 1
            collides_rect?(other)
          when :Triangle
            TODO
          else raise
          end
        end

        def absolute_xy
          return [@sprite.x + x1, @sprite.y + y1, @sprite.x + x2, @sprite.y + y2]
        end

        private

        def collides_rect?(other)
          ax1, ay1, ax2, ay2 = *absolute_xy
          bx1, by1, bx2, by2 = *other.absolute_xy
          return `ax1 < bx2 &&
                  ay1 < by2 &&
                  bx1 < ax2 &&
                  by1 < ay2`
        end
      end

      class Triangle < Base
        def initialize(sprite, x1, y1, x2, y2, x3, y3)
          @sprite = sprite
          @poss = [[x1, y1], [x2, y2], [x3, y3]]
          super()
        end

        def type; :Triangle; end

        def collides?(other)
          case other.type
          when :Point, :Circle, :Rect
            other.collides?(self)
          when :Triangle
            collides_triangle?(other)
          else
            raise
          end
        end

        def absolute_xy
          absolute(@poss)
        end

        private

        def collides_triangle?(other)
          ox, oy = self.absolute_xy
          dx, dy = other.absolute_xy

          return @checker.check_triangle_triangle(ox, oy, dx, dy)
        end
      end
    end
  end
end
