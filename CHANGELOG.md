## HEAD

- feat: Multi-touch (#26)

## v1.4.3 (2020-01-18)

- feat: Maximize Window by setting nil to .width, .height (#27)
- fix: Disable pull-to-refresh on mobile devices (#28)

## v1.4.2 (2020-01-18)

- fix: Downgrade opal to 0.11 (#25)

## v1.4.1 (2020-01-18/yanked: see #25)

- change: starter-kit is discontinued
- feat: Touch events (experimental) (#21)
- feat: Added some more keycodes
- fix: `LoadError: cannot load such file -- dxopal` (#19)
- fix: Resource loading does not work on v1.4.0 (#20)

## v1.4.0 (2019-06-02/yanked: see #20)

- new: `dxopal new APP_PATH` (#14)
- new: `Image.load` (#17)
- new: `Font.get_width` (#18)
- fix: `Window.draw_box(C_WHITE)` draws a gray rectangle (#16)
- chores: Update Opal to 1.0.0
- internal: Moved ./opal to ./lib (#15)

## v1.3.0 (2018-09-29)

- new: [Support blend mode `:add`](https://github.com/yhara/dxopal/pull/11)
- Update gems 

## v1.2.0 (2018-05-16)

- new: Support shift/ctrl key 
- new: Added some opal stdlibs
  - singleton
  - delegate, forwardable
  - promise
  - set
  - time
  - ([Let me know](https://github.com/yhara/dxopal/issues/) if you need some more)
- new: Sound#stop
- fix: `z` for draw_xx did not work correctly

## v1.1.0 (2018-02-05)

### Breaking change: matter.js is split from dxopal.js

To use `DXOpal::Sprite::Physics`, you need to load matter.js explicitly.

Old:
    
    <script src="dxopal.min.js"></script>

New:

    <script src="matter.js"></script>
    <script src="dxopal.min.js"></script>

### Other improvements:

- new: Image#set_color_key
- new: Window.draw_scale
- new: Show the message of an exception if there is a `<div id='dxopal-errors'>`
- new: Add --port to dxopal command
- fix: shot/hit method names for Sprite.check are now customizable
- fix: Multiple loops runs when Window.loop is called more than once
- internal: Upgrade to Opal 0.11.0

## v1.0.0 (2017-10-26)

### Breaking change: canvas id

Old:

    <canvas id="canvas">

New:

    <canvas id="dxopal-canvas">

### Other improvements:

- new: Sprite.check (collision detection)
- new: Window.bgcolor
- new: Input.mouse_down?, mouse_push?, mouse_release?
- new: Input.keyevent_target
- new: Matter.js support (experimental)
- new: Window.loop can be called twice
- fix: Image transparency was ignored
- fix: Sprite.clean was broken
- fix: Window.width=, height= did not work

## v0.3.0 (2017-08-03)

- new: Window.real_fps
- new: Some more drawing methods
- new: SoundEffect class
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
