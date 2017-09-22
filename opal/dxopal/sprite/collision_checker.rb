module DXOpal
  class Sprite
    class CollisionChecker
      %x{
        (function(){
          var check_line_line = function(x1, y1, x2, y2, x3, y3, x4, y4){
            return !((((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
                      ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4)) > 0.0) ||
                     (((x3 - x4) * (y1 - y3) + (y3 - y4) * (x3 - x1)) *
                      ((x3 - x4) * (y2 - y3) + (y3 - y4) * (x3 - x2)) > 0.0 ));
          };
          var check_point_triangle = function(x, y, x1, y1, x2, y2, x3, y3){
            if ((x1 - x3) * (y1 - y2) == (x1 - x2) * (y1 - y3))
              return false;

            var cx = (x1 + x2 + x3) / 3,
                cy = (y1 + y2 + y3) / 3;

            if (intersect( x1, y1, x2, y2, x, y, cx, cy ) < 0.0 ||
                intersect( x2, y2, x3, y3, x, y, cx, cy ) < 0.0 ||
                intersect( x3, y3, x1, y1, x, y, cx, cy ) < 0.0 ) {
              return false;
            }
            return true;
          };
          var intersect = function(x1, y1, x2, y2, x3, y3, x4, y4){
            return ((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
                   ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4));
          };

          Opal.DXOpal.JsCollisionChecker = {
            check_triangle_triangle: function(ox, oy, dx, dy) {
              return check_line_line(ox[0], oy[0], ox[1], oy[1], dx[1], dy[1], dx[2], dy[2]) ||
                     check_line_line(ox[0], oy[0], ox[1], oy[1], dx[2], dy[2], dx[0], dy[0]) ||
                     check_line_line(ox[1], oy[1], ox[2], oy[2], dx[0], dy[0], dx[1], dy[1]) ||
                     check_line_line(ox[1], oy[1], ox[2], oy[2], dx[2], dy[2], dx[0], dy[0]) ||
                     check_line_line(ox[2], oy[2], ox[0], oy[0], dx[0], dy[0], dx[1], dy[1]) ||
                     check_line_line(ox[2], oy[2], ox[0], oy[0], dx[1], dy[1], dx[2], dy[2]) ||
                     check_point_triangle(ox[0], oy[0], dx[0], dy[0], dx[1], dy[1], dx[2], dy[2]) ||
                     check_point_triangle(dx[0], dy[0], ox[0], oy[0], ox[1], oy[1], ox[2], oy[2]);
            }
          };
        })();
      }

      def self.check_triangle_triangle(ox, oy, dx, dy)
        `Opal.DXOpal.JsCollisionChecker.check_triangle_triangle(ox, oy, dx, dy)`
      end
    end
  end
end
