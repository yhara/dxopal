## v0.2.1 ()

- new: Window.real_fps
- improve: Better fps stabillity (use requestAnimationFrame)

## v0.2.0 (2017-06-02)

- new: Add example (apple_catcher)

### Breaking Change: resource loading

Image.load and Sound.new are removed. They look like a synchronous API
but actually were not. It was fun to emulate DXRuby APIs with JS Promise,
but I found it 
very confusing while implementing the AppleCatcher example.

Since v0.2, resource loading look like this.

```rb
Image.register(:player, 'images/player.png')
Sound.register(:game_over, 'sounds/game_over.wav')

Window.load_resources do
  Window.loop do
    # ... Window.draw(0, 0, Image[:player]) ...
    
    # ... Sound[:game_over].play ...
  end
end
```

## v0.1.2 (2017-05-01)

- new: Window.pause, .resume
- new: Window.draw_box_fill
- new: Sprite.update, Sprite.clean

## v0.1.1 (2017-04-30)

- fix: Image#draw now respects alpha channel
- fix: Vanished sprites have no collision
- new: Image#slice

## v0.1.0 (2017-04-24)

- new: Sprite.new, collision detection
- new: Input.mouse_pos_x, mouse_pos_y

## v0.0.3 (2017-04-23)

- fix: Input.key_down? return true after key is released
- new: color constants
- new: Image.new, Image#circle, etc.
- new: console
- refactor: Split source file

## v0.0.2 (2017-04-22)

- Moved demos to yhara/dxopal-game
- Now ruby is not mandatory to make games with DXOpal

## v0.0.1 (2017-04-19)

- Gemified (not pushed to rubygems.org yet)
