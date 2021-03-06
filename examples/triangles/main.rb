require 'dxopal'

class Enemy < Sprite
  SIZE = 40
  def initialize
    x = rand(Window.width)
    y = 0
    @img_normal = Image.new(SIZE, SIZE)
    @img_normal.triangle_fill(0, 0, SIZE-1, 10, 10, SIZE-1, C_WHITE)
    super(x, y, @img_normal)
    @img_hit = Image.new(SIZE, SIZE) 
    @img_hit.triangle_fill(0, 0, SIZE-1, 10, 10, SIZE-1, C_RED)
    self.collision = [0, 0, SIZE-1, 10, 10, SIZE-1]
    @dy = rand(6) + 1
    @drot = rand(8) + 1
    @hit = false
  end

  def hit(other)
    @hit = true
  end

  def update
    self.y += @dy
    if self.y >= Window.height
      self.y = 0
    end
    self.angle = (self.angle + @drot) % 360
    self.image = @hit ? @img_hit : @img_normal
    @hit = false
  end
end

class Bullet < Sprite
  SIZE = 10
  def initialize(px, py)
    x = px
    y = py
    @img_normal = Image.new(SIZE, SIZE)
    @img_normal.circle_fill(SIZE/2, SIZE/2, (SIZE/2)-1, C_YELLOW)
    super(x, y, @img_normal)
    self.collision = [SIZE/2, SIZE/2, (SIZE/2)-1]
    @dx = rand(8) - 4
    @dy = -rand(3) - 3
  end

  def shot(other)
    #self.vanish
  end

  def update
    self.x += @dx
    self.y += @dy
    if self.x < 0 || self.x > Window.width || self.y < 0
      self.vanish
    end
  end
end

class Player < Sprite
  SIZE = 30

  def initialize
    x = Window.width / 2
    y = Window.height - SIZE*2
    @img_normal = Image.new(SIZE, SIZE)
    @img_normal.triangle_fill(SIZE/2, 0, SIZE-1, SIZE-1, 0, SIZE-1, C_GREEN)
    @img_hit = Image.new(SIZE, SIZE) 
    @img_hit.triangle_fill(SIZE/2, 0, SIZE-1, SIZE-1, 0, SIZE-1, C_RED)
    self.collision = [0, 0, SIZE-1, 10, 10, SIZE-1]
    @hit = false
    @bullets = []
    super(x, y, @img_normal)
  end
  attr_reader :bullets

  def make_bullets
    (N_BULLETS - @bullets.length).times{ @bullets << Bullet.new(@x, @y) }
  end

  def shot(other)
    @hit = true
  end

  def update
    self.x += Input.x * 8
    self.x = Window.width if self.x > Window.width
    self.x = 0 if self.x < 0
    self.y += Input.y * 8
    self.y = Window.height if self.y > Window.height
    self.y = 0 if self.y < 0

    self.image = @hit ? @img_hit : @img_normal
    @hit = false
  end
end

N_ENEMIES = 70
N_BULLETS = 30
Window.load_resources do
  player = Player.new
  enemies = N_ENEMIES.times.map{ Enemy.new }

  Window.loop do
    Window.draw_font(0, 0, "FPS: #{Window.real_fps}", Font.default)
    sprites = [player] + player.bullets + enemies
    Sprite.draw(sprites)
    #Sprite.check([player], enemies)
    Sprite.check(player.bullets, enemies)
    Sprite.update(sprites)
    Sprite.clean(enemies)
    Sprite.clean(player.bullets)

    rand(N_ENEMIES - enemies.length).times{ enemies << Enemy.new }
    player.make_bullets
  end

  %x{
    document.getElementById('pause').addEventListener('click', function(){
      #{Window.paused? ? Window.resume : Window.pause}
    });
  }
end
