# vim: set ft=javascript:
# Collision checking algorithm, implemented in JavaScript.
# Available as `Opal.DXOpal.CollisionChecker` in the runtime.
%x{ (function(){

var intersect = function(x1, y1, x2, y2, x3, y3, x4, y4){
  return ((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
         ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4));
};

var check_line_line = function(x1, y1, x2, y2, x3, y3, x4, y4){
  return !((((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
            ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4)) > 0.0) ||
           (((x3 - x4) * (y1 - y3) + (y3 - y4) * (x3 - x1)) *
            ((x3 - x4) * (y2 - y3) + (y3 - y4) * (x3 - x2)) > 0.0 ));
};

var check_circle_line = function(x, y, r, x1, y1, x2, y2) {
  var vx = x2-x1, vy = y2-y1;
  var cx = x-x1, cy = y-y1;

  if (vx == 0 && vy == 0 )
    return CCk.check_point_circle(x, y, r, x1, y1);

  var n1 = vx * cx + vy * cy;
  if (n1 < 0)
    return cx*cx + cy*cy < r * r;

  var n2 = vx * vx + vy * vy;
  if (n1 > n2) {
    var len = (x2 - x)*(x2 - x) + (y2 - y)*(y2 - y);
    return len < r * r;
  }
  else
  {
    var n3 = cx * cx + cy * cy;
    return n3-(n1/n2)*n1 < r * r;
  }
};

var CCk = {
  check_point_circle: function(px, py, cx, cy, cr) {
    return (cr*cr) >= ((cx-px) * (cx-px) + (cy-py) * (cy-py));
  },

  check_point_straight_rect: function(x, y, x1, y1, x2, y2) {
    return ((x) >= (x1) &&
            (y) >= (y1) &&
            (x) < (x2) &&
            (y) < (y2));
  },

  check_point_triangle: function(x, y, x1, y1, x2, y2, x3, y3){
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
  },

  check_circle_circle: function(ox, oy, or, dx, dy, dr) {
    return ((or+dr) * (or+dr) >= (ox-dx) * (ox-dx) + (oy-dy) * (oy-dy));
  },

  check_ellipse_ellipse: function(E1, E2) {
     var DefAng = E1.fAngle-E2.fAngle;
     var Cos = Math.cos( DefAng );
     var Sin = Math.sin( DefAng );
     var nx = E2.fRad_X * Cos;
     var ny = -E2.fRad_X * Sin;
     var px = E2.fRad_Y * Sin;
     var py = E2.fRad_Y * Cos;
     var ox = Math.cos( E1.fAngle )*(E2.fCx-E1.fCx) + Math.sin(E1.fAngle)*(E2.fCy-E1.fCy);
     var oy = -Math.sin( E1.fAngle )*(E2.fCx-E1.fCx) + Math.cos(E1.fAngle)*(E2.fCy-E1.fCy);

     var rx_pow2 = 1/(E1.fRad_X*E1.fRad_X);
     var ry_pow2 = 1/(E1.fRad_Y*E1.fRad_Y);
     var A = rx_pow2*nx*nx + ry_pow2*ny*ny;
     var B = rx_pow2*px*px + ry_pow2*py*py;
     var D = 2*rx_pow2*nx*px + 2*ry_pow2*ny*py;
     var E = 2*rx_pow2*nx*ox + 2*ry_pow2*ny*oy;
     var F = 2*rx_pow2*px*ox + 2*ry_pow2*py*oy;
     var G = (ox/E1.fRad_X)*(ox/E1.fRad_X) + (oy/E1.fRad_Y)*(oy/E1.fRad_Y) - 1;

     var tmp1 = 1/(D*D-4*A*B);
     var h = (F*D-2*E*B)*tmp1;
     var k = (E*D-2*A*F)*tmp1;
     var Th = (B-A)==0 ? 0 : Math.atan( D/(B-A) ) * 0.5;

     var CosTh = Math.cos(Th);
     var SinTh = Math.sin(Th);
     var A_tt = A*CosTh*CosTh + B*SinTh*SinTh - D*CosTh*SinTh;
     var B_tt = A*SinTh*SinTh + B*CosTh*CosTh + D*CosTh*SinTh;
     var KK = A*h*h + B*k*k + D*h*k - E*h - F*k + G > 0 ? 0 : A*h*h + B*k*k + D*h*k - E*h - F*k + G;
     var Rx_tt = 1+Math.sqrt(-KK/A_tt);
     var Ry_tt = 1+Math.sqrt(-KK/B_tt);
     var x_tt = CosTh*h-SinTh*k;
     var y_tt = SinTh*h+CosTh*k;
     var JudgeValue = x_tt*x_tt/(Rx_tt*Rx_tt) + y_tt*y_tt/(Ry_tt*Ry_tt);

     return (JudgeValue <= 1);
  },

  check_circle_tilted_rect: function(cx, cy, cr, x1, y1, x2, y2, x3, y3, x4, y4){
    return CCk.check_point_triangle(cx, cy, x1, y1, x2, y2, x3, y3) || 
           CCk.check_point_triangle(cx, cy, x1, y1, x3, y3, x4, y4) || 
           check_circle_line(cx, cy, cr, x1, y1, x2, y2) ||
           check_circle_line(cx, cy, cr, x2, y2, x3, y3) ||
           check_circle_line(cx, cy, cr, x3, y3, x4, y4) ||
           check_circle_line(cx, cy, cr, x4, y4, x1, y1);
  },

  check_circle_triangle: function(cx, cy, cr, x1, y1, x2, y2, x3, y3) {
    return CCk.check_point_triangle(cx, cy, x1, y1, x2, y2, x3, y3) || 
           check_circle_line(cx, cy, cr, x1, y1, x2, y2) ||
           check_circle_line(cx, cy, cr, x2, y2, x3, y3) ||
           check_circle_line(cx, cy, cr, x3, y3, x1, y1);
  },

  check_rect_rect: function(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2) {
    return ax1 < bx2 &&
           ay1 < by2 &&
           bx1 < ax2 &&
           by1 < ay2;
  },

  // Rect(may be tilted) vs Triangle
  check_tilted_rect_triangle: function(ox1, oy1, ox2, oy2, ox3, oy3, ox4, oy4,
                                       dx1, dy1, dx2, dy2, dx3, dy3) {
    return check_line_line(ox1, oy1, ox2, oy2, dx1, dy1, dx2, dy2) ||
           check_line_line(ox1, oy1, ox2, oy2, dx2, dy2, dx3, dy3) ||
           check_line_line(ox1, oy1, ox2, oy2, dx3, dy3, dx1, dy1) ||
           check_line_line(ox2, oy2, ox3, oy3, dx1, dy1, dx2, dy2) ||
           check_line_line(ox2, oy2, ox3, oy3, dx2, dy2, dx3, dy3) ||
           check_line_line(ox2, oy2, ox3, oy3, dx3, dy3, dx1, dy1) ||
           check_line_line(ox3, oy3, ox4, oy4, dx1, dy1, dx2, dy2) ||
           check_line_line(ox3, oy3, ox4, oy4, dx2, dy2, dx3, dy3) ||
           check_line_line(ox3, oy3, ox4, oy4, dx3, dy3, dx1, dy1) ||
           check_line_line(ox4, oy4, ox1, oy1, dx1, dy1, dx2, dy2) ||
           check_line_line(ox4, oy4, ox1, oy1, dx2, dy2, dx3, dy3) ||
           check_line_line(ox4, oy4, ox1, oy1, dx3, dy3, dx1, dy1) ||
           CCk.check_point_triangle(dx1, dy1, ox1, oy1, ox2, oy2, ox3, oy3) || 
           CCk.check_point_triangle(dx1, dy1, ox1, oy1, ox3, oy3, ox4, oy4) || 
           CCk.check_point_triangle(ox1, oy1, dx1, dy1, dx2, dy2, dx3, dy3);
  },

  // Triangle vs Triangle
  check_triangle_triangle: function(ox1, oy1, ox2, oy2, ox3, oy3,
                                    dx1, dy1, dx2, dy2, dx3, dy3) {
    return check_line_line(ox1, oy1, ox2, oy2, dx2, dy2, dx3, dy3) ||
           check_line_line(ox1, oy1, ox2, oy2, dx3, dy3, dx1, dy1) ||
           check_line_line(ox2, oy2, ox3, oy3, dx1, dy1, dx2, dy2) ||
           check_line_line(ox2, oy2, ox3, oy3, dx3, dy3, dx1, dy1) ||
           check_line_line(ox3, oy3, ox1, oy1, dx1, dy1, dx2, dy2) ||
           check_line_line(ox3, oy3, ox1, oy1, dx2, dy2, dx3, dy3) ||
           CCk.check_point_triangle(ox1, oy1, dx1, dy1, dx2, dy2, dx3, dy3) ||
           CCk.check_point_triangle(dx1, dy1, ox1, oy1, ox2, oy2, ox3, oy3);
  }
};

Opal.DXOpal.CollisionChecker = CCk;
Opal.DXOpal.CCk = CCk; // Alias

})(); }
