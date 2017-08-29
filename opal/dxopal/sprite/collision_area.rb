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

        def absolute(poss)
          return poss if !@sprite.collision_sync
          rad = Math::PI / 180.0 * @sprite.angle
          sin = Math.sin(rad)
          cos = Math.cos(rad)
          data1x = @sprite.scale_x * cos
          data1y = @sprite.scale_y * sin
          data2x = @sprite.scale_x * sin
          data2y = @sprite.scale_y * cos
          cx = @sprite.center_x
          cy = @sprite.center_y
          xs = []
          ys = []
          poss.each do |x, y|
            x2 = (x - cx) * data1x - (y - cy) * data1y + cx + @sprite.x
            y2 = (x - cx) * data2x + (y - cy) * data2y + cy + @sprite.y
            xs.push(x2)
            ys.push(y2)
          end
          return xs, ys
        end
      end

      class Point < Base
        def initialize(sprite, x, y)
          @sprite, @x, @y = sprite, x, y
          super()
        end

        def pos
          absolute_pos([@x, @y])
        end

        def collides?(other)
          case other
          when Point
            self.pos == other.pos
          when Circle
            TODO
          when Rect
            TODO
          when Triangle
            TODO
          end
        end
      end

      class Circle < Base
        def initialize(sprite, x, y, r)
          @sprite, @x, @y, @r = sprite, x, y, r
          super()
        end

        def collides?(other)
          case other
          when Point
            other.collides?(self)
          when Circle
            TODO
          when Rect
            TODO
          when Triangle
            TODO
          end
        end
      end

      class Rect < Base
        def initialize(sprite, x1, y1, x2, y2)
          @sprite, @x1, @y1, @x2, @y2 = sprite, x1, y1, x2, y2
          super()
        end

        def collides?(other)
          case other
          when Point, Circle
            other.collides?(self)
          when Rect
            TODO
          when Triangle
            TODO
          end
        end
      end

      class Triangle < Base
        def initialize(sprite, x1, y1, x2, y2, x3, y3)
          @sprite = sprite
          @poss = [[x1, y1], [x2, y2], [x3, y3]]
          super()
        end

        def collides?(other)
          case other
          when Point, Circle, Rect
            other.collides?(self)
          when Triangle
            collides_triangle?(other)
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
