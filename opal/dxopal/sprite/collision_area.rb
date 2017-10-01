require 'dxopal/sprite/collision_checker'

module DXOpal
  class Sprite
    # Methods of Sprite related to collision checking
    module CollisionArea
      class Base
        # Sprite corresponds to this hitarea
        attr_reader :sprite

        # Return a string like "Point", "Rect", etc.
        # Used for type checking in `collides?` (because Opal's Class#is_a? is not very fast)
        def type
          raise "override me"
        end

        def absolute(poss)
          ox = @sprite.x
          oy = @sprite.y
          return poss.map{|(x, y)| [x+ox, y+oy]} if !@sprite.collision_sync
          angle = @sprite.angle
          cx = @sprite.center_x
          cy = @sprite.center_y
          sx = @sprite.scale_x
          sy = @sprite.scale_y

          ret = []
          %x{
            var rad = Math.PI / 180.0 * angle;
            var sin = Math.sin(rad);
            var cos = Math.cos(rad);
            poss.forEach(function(pos){
              var x = pos[0], y = pos[1];
              x2 = (x - cx) * sx * cos - (y - cy) * sy * sin + cx + ox;
              y2 = (x - cx) * sx * sin + (y - cy) * sy * cos + cy + oy;
              ret.push([x2, y2]);
            });
          }
          return ret
        end

        def absolute1(pos)
          absolute([pos]).first
        end
        
        def transback(poss, sprite)
          return poss if !sprite.collision_sync
          angle = sprite.angle
          cx = sprite.x + sprite.center_x
          cy = sprite.y + sprite.center_y
          sx = sprite.scale_x
          sy = sprite.scale_y

          ret = []
          %x{
            var rad = Math.PI / 180.0 * -angle;
            var sin = Math.sin(rad);
            var cos = Math.cos(rad);
            poss.forEach(function(pos){
              var x = pos[0], y = pos[1];
              x2 = ((x - cx) * cos - (y - cy) * sin) / sx + cx;
              y2 = ((x - cx) * sin + (y - cy) * cos) / sy + cy;
              ret.push([x2, y2]);
            });
          }
          return ret
        end

        def transback1(pos, sprite)
          transback([pos], sprite).first
        end

        def aabb(poss)
          x1 = y1 =  Float::INFINITY
          x2 = y2 = -Float::INFINITY
          %x{
            for(var i=0; i<poss.length; i++) {
              if (poss[i][0] < x1) x1 = poss[i][0];
              if (poss[i][1] < y1) y1 = poss[i][1];
              if (poss[i][0] > x2) x2 = poss[i][0];
              if (poss[i][1] > y2) y2 = poss[i][1];
            }
          }
          return [[x1, y1], [x2, y2]]
        end
      end

      class Point < Base
        def initialize(sprite, x, y)
          @sprite, @x, @y = sprite, x, y
          super()
        end

        def type; :Point; end

        def collides?(other)
          case other.type
          when :Point
            self.absolute_pos == other.absolute_pos
          when :Circle
            x, y = *transback1(self.absolute_pos, other.sprite)
            cx, cy = *other.absolute_norot_pos
            `Opal.DXOpal.CCk.check_point_circle(x, y, cx, cy, #{other.r})`
          when :Rect
            x, y = *transback1(self.absolute_pos, other.sprite)
            ((x1, y1), (x2, y2)) = *other.absolute_norot_poss
            `Opal.DXOpal.CCk.check_point_straight_rect(x, y, x1, y1, x2, y2)`
          when :Triangle
            x, y = *absolute_pos
            (x1, y1), (x2, y2), (x3, y3) = *other.absolute_poss
            `Opal.DXOpal.CCk.check_point_triangle(x, y, x1, y1, x2, y2, x3, y3)`
          else raise
          end
        end

        # Return [x, y]
        def absolute_pos
          absolute1([@x, @y])
        end
      end

      class Circle < Base
        def initialize(sprite, x, y, r)
          @sprite, @x, @y, @r = sprite, x, y, r
          super()
        end
        attr_reader :r

        def type; :Circle; end

        # Return true if this is not an ellipsis
        def circle?
          @sprite.scale_x == @sprite.scale_y
        end

        def collides?(other)
          case other.type
          when :Point
            other.collides?(self)
          when :Circle
            collides_circle?(other)
          when :Rect
            cx, cy = *self.absolute_norot_pos
            (x1, y1), (x2, y2), (x3, y3), (x4, y4) = *transback(other.absolute_poss, @sprite)
            `Opal.DXOpal.CCk.check_circle_tilted_rect(cx, cy, #{@r}, x1, y1, x2, y2, x3, y3, x4, y4)`
          when :Triangle
            cx, cy = *self.absolute_norot_pos
            (x1, y1), (x2, y2), (x3, y3) = *transback(other.absolute_poss, @sprite)
            `Opal.DXOpal.CCk.check_circle_triangle(cx, cy, #{@r}, x1, y1, x2, y2, x3, y3)`
          else raise
          end
        end

        # Return [x, y]
        def absolute_pos
          absolute1([@x, @y])
        end

        def absolute_norot_pos
          [@x + @sprite.x, @y + @sprite.y]
        end

        private

        def collides_circle?(other)
          x1, y1 = *self.absolute_pos
          r1 = @r
          x2, y2 = *other.absolute_pos
          r2 = other.r
          if self.circle? && other.circle?
            `Opal.DXOpal.CCk.check_circle_circle(x1, y1, #{@r}, x2, y2, #{other.r})`
          else
            if @sprite.collision_sync
              scale_x1 = @sprite.scale_x
              scale_y1 = @sprite.scale_y
              angle1 = @sprite.angle * Math::PI / 180
            else
              scale_x1 = 1
              scale_y1 = 1
              angle1 = 0
            end
            if other.sprite.collision_sync
              scale_x2 = other.sprite.scale_x
              scale_y2 = other.sprite.scale_y
              angle2 = other.sprite.angle * Math::PI / 180
            else
              scale_x2 = 1
              scale_y2 = 1
              angle2 = 0
            end
            ret = nil
            %x{
              var e1 = {
                fRad_X: scale_x1 * r1,
                fRad_Y: scale_y1 * r1,
                fAngle: angle1,
                fCx: x1,
                fCy: y1,
              }
              var e2 = {
                fRad_X: scale_x2 * r2,
                fRad_Y: scale_y2 * r2,
                fAngle: angle2,
                fCx: x2,
                fCy: y2,
              }
              ret = Opal.DXOpal.CCk.check_ellipse_ellipse(e1, e2);
            }
            ret
          end
        end
      end

      class Rect < Base
        def initialize(sprite, x1, y1, x2, y2)
          @sprite, @x1, @y1, @x2, @y2 = sprite, x1, y1, x2, y2
          @poss = [[x1, y1], [x2, y1], [x2, y2], [x1, y2]]
          super()
        end

        def type; :Rect; end

        def inspect
          "#<CollisionArea::Rect(#{@x1}, #{@y1}, #{@x2}, #{@y2})>"
        end

        def collides?(other)
          case other.type
          when :Point, :Circle
            other.collides?(self)
          when :Rect
            ((ox1, oy1), (ox2, oy2)) = self.absolute_norot_poss
            ((dx1, dy1), (dx2, dy2)) = aabb(transback(other.absolute_poss, @sprite))
            return false unless `Opal.DXOpal.CCk.check_rect_rect(ox1, oy1, ox2, oy2, dx1, dy1, dx2, dy2)`

            ((ox1, oy1), (ox2, oy2)) = other.absolute_norot_poss
            ((dx1, dy1), (dx2, dy2)) = aabb(transback(self.absolute_poss, other.sprite))
            return false unless `Opal.DXOpal.CCk.check_rect_rect(ox1, oy1, ox2, oy2, dx1, dy1, dx2, dy2)`
            true
          when :Triangle
            (ox1, oy1), (ox2, oy2), (ox3, oy3), (ox4, oy4) = *self.absolute_poss
            (dx1, dy1), (dx2, dy2), (dx3, dy3) = *other.absolute_poss
            `Opal.DXOpal.CCk.check_tilted_rect_triangle(ox1, oy1, ox2, oy2, ox3, oy3, ox4, oy4,
                                                        dx1, dy1, dx2, dy2, dx3, dy3)`

          else raise
          end
        end

        def absolute_poss
          absolute(@poss)
        end

        def absolute_norot_poss
          [[@x1 + @sprite.x, @y1 + @sprite.y],
           [@x2 + @sprite.x, @y2 + @sprite.y]]
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
            (ox1, oy1), (ox2, oy2), (ox3, oy3) = *self.absolute_poss
            (dx1, dy1), (dx2, dy2), (dx3, dy3) = *other.absolute_poss
            `Opal.DXOpal.CCk.check_triangle_triangle(ox1, oy1, ox2, oy2, ox3, oy3,
                                                     dx1, dy1, dx2, dy2, dx3, dy3)`
          else raise
          end
        end

        def absolute_poss
          absolute(@poss)
        end
      end
    end
  end
end
