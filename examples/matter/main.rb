require 'dxopal'
#  class Window
#    def self.loop(&block)
#      @@block = block
#      %x{
#        window.requestAnimationFrame((time) => {
#          if (#{Sprite.matter_enabled?}) {
#            Matter.Runner.tick(#{Sprite._matter_runner},
#                               #{Sprite._matter_engine},
#                               time);
#          }
#          #{_loop(&block)}
#        });
#      }
#    end
#  end


Window.load_resources do
  box = Sprite.new(200, 200, Image.new(100, 100, C_RED))
  box.angle = 30
  box.physical_body = [:rectangle, 100, 100, `{restitution: 0.9}`]
  box2 = Sprite.new(250, 200, Image.new(30, 30, C_GREEN))
  box2.angle = 30
  box2.physical_body = [:rectangle, 30, 30, `{density: 0.0001, restitution: 0.99}`]

  floor = Sprite.new(0, Window.height, Image.new(Window.width, 10, C_WHITE))
  floor.physical_body = [:rectangle, Window.width, 10, `{isStatic: true}`]

  `#{Sprite._matter_engine}.world.gravity.scale /= 2`

  Window.loop do
    if Input.key_push?(K_R)
      p box2
      box2.x = 250
      box2.y = 200
    end
    box.draw
    box2.draw
    floor.draw
  end
end

#%x{
#
#// module aliases
#var Engine = Matter.Engine,
#    Render = Matter.Render,
#    World = Matter.World,
#    Bodies = Matter.Bodies;
#
#// create an engine
#var engine = Engine.create();
#
#// create a renderer
#var render = Render.create({
#    element: document.body,
#    engine: engine
#});
#
#// create two boxes and a ground
#var boxA = Bodies.rectangle(400, 200, 80, 80, {angle: 10});
#var boxB = Bodies.rectangle(450, 50, 80, 80);
#var ground = Bodies.rectangle(400, 610, 810, 60, { isStatic: true });
#
#// add all of the bodies to the world
#World.add(engine.world, [boxA, ground]);
#
#// run the engine
#Engine.run(engine);
#
#// run the renderer
#Render.run(render);
#
#setTimeout(() => console.log(boxA), 1000);
#}
