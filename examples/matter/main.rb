require 'dxopal'
Window.load_resources do
  box = Sprite.new(200, 200, Image.new(100, 100, C_RED))
  box.angle = 30
  box.physical_body = [:rectangle, 100, 100, `{restitution: 0.9}`]
  box2 = Sprite.new(250, 200, Image.new(30, 30, C_GREEN))
  box2.angle = 30
  box2.physical_body = [:rectangle, 30, 30, `{density: 0.0002, restitution: 0.99}`]

  floor = Sprite.new(0, Window.height, Image.new(Window.width, 10, C_WHITE))
  floor.physical_body = [:rectangle, Window.width, 10, `{isStatic: true}`]

  `#{Sprite._matter_engine}.world.gravity.scale /= 2`

  Window.loop do
    if Input.key_push?(K_R)
      box2.x = 250
      box2.y = 200
    end
    box.draw
    box2.draw
    floor.draw
  end
end

# 
# Equivalent JS version
#

#%x{
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
#    engine: engine,
#    options: {
#      width: 640,
#      height: 480
#    }
#});
#
#// create two boxes and a ground
#var box = Bodies.rectangle(250, 250, 100, 100, {angle: 30*Math.PI/180, restitution: 0.9});
#var box2 = Bodies.rectangle(265, 215, 30, 30, {angle: 30*Math.PI/180, density: 0.0001, restitution: 0.99});
#var ground = Bodies.rectangle(320, 485, 640, 10, { isStatic: true });
#
#engine.world.gravity.scale /= 2;
#
#// add all of the bodies to the world
#World.add(engine.world, [box, box2, ground]);
#
#// run the engine
#Engine.run(engine);
#
#// run the renderer
#Render.run(render);
#}
