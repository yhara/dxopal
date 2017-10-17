# DXOpal

Game development framework for [Opal](http://opalrb.org/),
API compatible to [DXRuby](http://dxruby.osdn.jp/)

## Demo

https://yhara.github.io/dxopal/

## Status

Early-alpha

## How to create a game

See [dxopal-game](https://github.com/yhara/dxopal-game)

## API difference

### Loading resources

Because of the async nature of JavaScript, `Image.load` and `Sound.new`
are changed to `Image.register`, `Sound.register` and `Window.load_resources`.

`Window.load_resources` tries to load all the resouces declared by `register`
and call the block when all of them are loaded.

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

## License

MIT (including images and sounds under examples/)

## Acknowledgements

- [Opal](http://opalrb.org/)
- [DXRuby](http://dxruby.osdn.jp/)
- [Bxfr](http://www.bfxr.net/) examples/apple_catcher/sounds/Explosion2.wav is made by this

## Contact

https://github.com/yhara/dxopal
