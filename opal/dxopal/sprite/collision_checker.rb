module DXOpal
  class Sprite
    module CollisionChecker
      class Base
        def check_triangle_triangle(ox, oy, dx, dy)
          raise "override me"
        end
      end

      class OpalChecker
        def check_triangle_triangle(ox, oy, dx, dy)
          return check_line_line(ox[0], oy[0], ox[1], oy[1], dx[1], dy[1], dx[2], dy[2]) ||
                 check_line_line(ox[0], oy[0], ox[1], oy[1], dx[2], dy[2], dx[0], dy[0]) ||
                 check_line_line(ox[1], oy[1], ox[2], oy[2], dx[0], dy[0], dx[1], dy[1]) ||
                 check_line_line(ox[1], oy[1], ox[2], oy[2], dx[2], dy[2], dx[0], dy[0]) ||
                 check_line_line(ox[2], oy[2], ox[0], oy[0], dx[0], dy[0], dx[1], dy[1]) ||
                 check_line_line(ox[2], oy[2], ox[0], oy[0], dx[1], dy[1], dx[2], dy[2]) ||
                 check_point_triangle(ox[0], oy[0], dx[0], dy[0], dx[1], dy[1], dx[2], dy[2]) ||
                 check_point_triangle(dx[0], dy[0], ox[0], oy[0], ox[1], oy[1], ox[2], oy[2])
        end

        private

        def check_line_line(x1, y1, x2, y2, x3, y3, x4, y4)
          !((((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
             ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4)) > 0.0) ||
            (((x3 - x4) * (y1 - y3) + (y3 - y4) * (x3 - x1)) *
             ((x3 - x4) * (y2 - y3) + (y3 - y4) * (x3 - x2)) > 0.0 ))
        end

        # checktriangle
        def check_point_triangle(x, y, x1, y1, x2, y2, x3, y3)
          return false if (x1 - x3) * (y1 - y2) == (x1 - x2) * (y1 - y3)

          cx = (x1 + x2 + x3) / 3
          cy = (y1 + y2 + y3) / 3

          if (intersect( x1, y1, x2, y2, x, y, cx, cy ) < 0.0 ||
              intersect( x2, y2, x3, y3, x, y, cx, cy ) < 0.0 ||
              intersect( x3, y3, x1, y1, x, y, cx, cy ) < 0.0 )
            return false
          end
          return true
        end

        def intersect(x1, y1, x2, y2, x3, y3, x4, y4)
          ((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
          ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4))
        end
      end

      class JsChecker
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

        def check_triangle_triangle(ox, oy, dx, dy)
          `Opal.DXOpal.JsCollisionChecker.check_triangle_triangle(ox, oy, dx, dy)`
        end
      end

      class WasmChecker
        def self.load(&after)
          %x{
            var importObject = {imports: {}};
            fetch('/wasm/collision_checker_orig.wasm').then(function(response){
              return response.arrayBuffer();
            }).then(function(buffer){
              return WebAssembly.instantiate(buffer, importObject);
            }).then(function(result) {
              var instance = result.instance;

              Opal.DXOpal.WasmCollisionChecker = {
                check_triangle_triangle: function(ox, oy, dx, dy) {
                  var i32 = new Uint32Array(instance.exports.memory.buffer);

                  i32[ 0] = ox[0];
                  i32[ 1] = ox[1];
                  i32[ 2] = ox[2];
                  i32[ 3] = oy[0];
                  i32[ 4] = oy[1];
                  i32[ 5] = oy[2];
                  i32[ 6] = dx[0];
                  i32[ 7] = dx[1];
                  i32[ 8] = dx[2];
                  i32[ 9] = dy[0];
                  i32[10] = dy[1];
                  i32[11] = dy[2];

                  return instance.exports.check_triangle_triangle(0*4, 3*4, 6*4, 9*4);
                }
              };
            }).then(after)
            .catch((reason) => {
              console.error("Failed to load wasm file. Reason:", reason);
              after();
            });
          }
        end

        def check_triangle_triangle(ox, oy, dx, dy)
          `Opal.DXOpal.WasmCollisionChecker.check_triangle_triangle(ox, oy, dx, dy) != 0`
        end
      end
    end
  end
end
