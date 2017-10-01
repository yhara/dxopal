require 'dxopal'

module CollisionExample
  BLINK = 20

  class Base < Sprite
    def initialize(x, y, img, opts)
      super(x, y, img)
      @hit = false
      self.scale_x = opts[:scale_x] || 1
      self.scale_y = opts[:scale_y] || 1
      self.center_x = 0
      self.center_y = 0
      self.angle = opts[:angle] || 0
      @drot = opts[:drot] || 0
    end

    def shot(other)
      @hit = true
    end

    def hit(other)
      @hit = true
    end
    
    def update
      self.angle = (self.angle + @drot) % 360
      self.image = @hit ? @img_hit : @img
      @hit = false
    end
  end

  class Point < Base
    SIZE = 80
    def initialize(x, y, opts={})
      @color = C_RED
      @img = Image.new(SIZE, SIZE)
      @img.circle(SIZE/2, SIZE/2, SIZE/2 - 2, @color)
      @img.circle_fill(SIZE/2, SIZE/2, 2, @color)
      @img_hit = Image.new(SIZE, SIZE)
      @img_hit.circle_fill(SIZE/2, SIZE/2, SIZE/2 - 2, @color)
      @img_hit.circle_fill(SIZE/2, SIZE/2, 2, @color)
      super(x, y, @img, opts)
      self.collision = [SIZE/2, SIZE/2]
    end

    def inspect
      "#<Point(#{x}, #{y})>"
    end
  end

  class Circle < Base
    SIZE = 80
    def initialize(x, y, opts={})
      @color = C_RED
      @img = Image.new(SIZE, SIZE)
      @img.circle(SIZE/2, SIZE/2, SIZE/2 - 2, @color)
      @img_hit = Image.new(SIZE, SIZE)
      @img_hit.circle_fill(SIZE/2, SIZE/2, SIZE/2 - 2, @color)
      super(x, y, @img, opts)
      self.collision = [SIZE/2, SIZE/2, SIZE/2 - 2]
    end

    def inspect
      "#<Circle(#{x}, #{y})>"
    end
  end

  class Rect < Base
    SIZE = 80
    def initialize(x, y, opts={})
      @color = C_RED
      @img = Image.new(SIZE, SIZE)
      @img.box(0, 0, SIZE-1, SIZE-1, @color)
      @img_hit = Image.new(SIZE, SIZE)
      @img_hit.box_fill(0, 0, SIZE-1, SIZE-1, @color)
      super(x, y, @img, opts)
      self.collision = [0, 0, SIZE-1, SIZE-1]
    end

    def inspect
      "#<Rect(#{x}, #{y})>"
    end
  end

  class Triangle < Base
    SIZE = 80
    def initialize(x, y, opts={})
      @color = C_RED
      @img = Image.new(SIZE, SIZE)
      @img.triangle(SIZE/2, 0, SIZE-1, SIZE-1, 0, SIZE-1, @color)
      @img_hit = Image.new(SIZE, SIZE)
      @img_hit.triangle_fill(SIZE/2, 0, SIZE-1, SIZE-1, 0, SIZE-1, @color)
      super(x, y, @img, opts)
      self.collision = [SIZE/2, 0, SIZE-1, SIZE-1, 0, SIZE-1]
    end

    def inspect
      "#<Triangle(#{x}, #{y})>"
    end
  end

  class ShapeSet
    def initialize(x, y, sprites)
      @x, @y, @sprites = x, y, sprites
    end
    attr_reader :x, :y, :sprites

    def move(dx, dy)
      @sprites.each{|_| _.x += dx}
      @sprites.each{|_| _.y += dy}
    end
  end
end

include CollisionExample

MOVE = 10
Window.load_resources do
  opts1 = {drot: 1, scale_x: 2.0, scale_y: 0.75}
  x = y = 100
  set1 = ShapeSet.new(x, y, [
    Point.new(x, y, opts1),
    Circle.new(x + Point::SIZE, y, opts1),
    Rect.new(x + Point::SIZE + Circle::SIZE, y, opts1),
    Triangle.new(x + Point::SIZE + Circle::SIZE + Rect::SIZE, y, opts1),
  ])

  opts2 = {angle: 3, scale_x: 1.1, scale_y: 0.9}
  x = y = 200
  set2 = ShapeSet.new(x, y, [
    Point.new(x, y, opts2),
    Circle.new(x + Point::SIZE, y, opts2),
    Rect.new(x + Point::SIZE + Circle::SIZE, y, opts2),
    Triangle.new(x + Point::SIZE + Circle::SIZE + Rect::SIZE, y, opts2),
  ])

  all_sprites = set1.sprites + set2.sprites

  Window.loop do
    Window.draw_font(0, 0, "FPS: #{Window.real_fps} / PRESS ARROW KEYS", Font.default)

    set2.move(-MOVE, 0) if Input.key_push?(K_LEFT)
    set2.move(+MOVE, 0) if Input.key_push?(K_RIGHT)
    set2.move(0, -MOVE) if Input.key_push?(K_UP)
    set2.move(0, +MOVE) if Input.key_push?(K_DOWN)

    Sprite.check(set2.sprites, set1.sprites)
    Sprite.update(all_sprites)
    Sprite.draw(all_sprites)
  end

  %x{
    document.getElementById('pause').addEventListener('click', function(){
      #{Window.paused? ? Window.resume : Window.pause}
    });
  }
end
