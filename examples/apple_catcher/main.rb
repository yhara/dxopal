include DXOpal

Image.register(:player, 'images/noschar.png') 
Image.register(:apple, 'images/apple.png') 
Image.register(:bomb, 'images/bomb.png') 

Sound.register(:get, 'sounds/get.wav')
Sound.register(:explosion, 'sounds/explosion.wav')

module AppleCatcher
  class GameInfo
    def initialize(player)
      @player = player
      @score = 0
      @game_over = false
    end
    attr_accessor :player, :score, :game_over
  end

  def self.game_info; @@game_info; end
  def self.game_info=(info); @@game_info = info; end

  def self.scene; @@scene; end
  def self.scene=(sym)
    if ![:title, :playing, :game_over].include?(sym)
      raise "Unknown scene: #{sym}"
    end
    @@scene = sym
  end

  class Background < Sprite
    def initialize
      image = Image.new(640, 480, [128, 255, 255])
      image.box_fill(0, 0,   640, 480, [128, 255, 255])
      image.box_fill(0, 400, 640, 480, [0, 128, 0])
      super(0, 0, image)
    end
  end

  class ScoreDisp < Sprite
    def draw
      score = AppleCatcher.game_info.score
      Window.draw_font(0, 0, "SCORE: #{score}", Font.default)
    end
  end

  class Player < Sprite
    def initialize
      @anim_idx = 0
      @anim_ct = 0
      @tile_images = Image[:player].slice_tiles(4, 4)  # 4x4
      @char_images = @tile_images.first(4)
      super(240, 400-32)
    end

    def update
      @anim_ct += 1
      @anim_ct = 0 if @anim_ct >= 40
      self.image = @char_images[@anim_ct/10]

      self.x += Input.x * 8
      self.x = 640-16 if self.x > 640-16
      self.x = -16 if self.x < -16
    end
  end

  class Item < Sprite
    def initialize(img)
      super(rand(640-32), 0, img)
      @vy = rand(9)+4
    end

    def update
      self.y += @vy
      if self.y > 480
        self.vanish
      elsif self === AppleCatcher.game_info.player
        self.hit
      end
    end

    class Apple < Item
      def initialize
        super(Image[:apple])
        self.collision = [0, 15, 75, 80]
      end

      def hit
        Sound[:get].play
        AppleCatcher.game_info.score += 10
        self.vanish
      end
    end

    class Bomb < Item
      def initialize
        super(Image[:bomb])
        self.collision = [15, 31, 61, 76]
      end

      def hit
        Sound[:explosion].play
        AppleCatcher.game_info.game_over = true
      end
    end
  end

  class Items
    N = 5

    def initialize
      @items = []
    end

    def update
      @items.each{|x| x.update}
      @items.reject!{|x| x.vanished?}

      (N - @items.size).times do
        klass = (rand(100) < 80) ? Item::Bomb : Item::Apple
        @items.push(klass.new)
      end
    end

    def draw
      Sprite.draw(@items)
    end
  end
end

Window.load_resources do
  background = AppleCatcher::Background.new
  score_disp = AppleCatcher::ScoreDisp.new
  player = AppleCatcher::Player.new
  items = AppleCatcher::Items.new
  AppleCatcher.game_info = AppleCatcher::GameInfo.new(player)
  AppleCatcher.scene = :title

  Window.loop do
    case AppleCatcher.scene
    when :title
      if Input.key_push?(K_SPACE)
        AppleCatcher.scene = :playing
      end

      background.draw
      score_disp.draw
      Window.draw_font(0, 30, "PRESS SPACE TO START", Font.default)
    when :playing
      player.update
      items.update
      if AppleCatcher.game_info.game_over
        AppleCatcher.scene = :game_over
      end

      background.draw
      items.draw
      player.draw
      score_disp.draw
    when :game_over
      if Input.key_push?(K_SPACE)
        player = AppleCatcher::Player.new; player.update
        items = AppleCatcher::Items.new
        AppleCatcher.game_info = AppleCatcher::GameInfo.new(player)
        AppleCatcher.scene = :playing
      end

      background.draw
      items.draw
      player.draw
      score_disp.draw
      Window.draw_font(0, 30, "PRESS SPACE TO RESTART", Font.default)
    end
  end

  %x{
    document.getElementById('pause').addEventListener('click', function(){
      #{Window.paused? ? Window.resume : Window.pause}
    });
  }
end
