module DXOpal
  class Sprite
    # Experimental Matter.js (physics engine) support
    #
    # You need to load matter.js in advance to using these features.
    module Physics
      # Create Matter Body and register it to the World
      # - type: :rectangle, etc.
      def physical_body=(ary)
        raise "Call Sprite#initialize before calling physical_body=" if self.x.nil?
        type = ary[0]
        case type
        when :rectangle
          _, width, height, opts = *ary
          x = self.x + width/2
          y = self.y + height/2
          info = [width, height]
          `opts.angle = opts.angle || #{self.angle * Math::PI / 180}`
          @_matter_body = `Matter.Bodies[type](x, y, width, height, opts)`
        else
          raise "type #{type.inspect} is unknown or not supported yet"
        end
        Sprite._add_matter_body(@_matter_body, type, self, info)
      end
      attr_reader :_matter_body

      def _move_matter_body
        # TODO: support non-default center_x, center_y
        `Matter.Body.setPosition(#{@_matter_body},
           Matter.Vector.create(#{@x+@center_x}, #{@y+@center_y}))`
      end

      def _move_to_matter_body(mx, my)
        @x = mx - @center_x
        @y = my - @center_y
      end
    end

    # (internal) Matter.Engine instance
    def self._matter_engine
      @matter_engine ||= `Matter.Engine.create()`
    end

    # (internal) Matter.Runner instance
    def self._matter_runner
      @matter_runner ||= `Matter.Runner.create()`
    end

    # (internal) 
    def self._matter_sprites
      @matter_bodies ||= {}
    end

    def self._add_matter_body(body, type, sprite, info)
      _matter_sprites[`body.id`] = [type, sprite, info]
      `Matter.World.addBody(#{Sprite._matter_engine}.world, body)`
    end

    # Return true if `physical_body=` is ever called
    def self.matter_enabled?
      # Note: we cannot use `!!` here because @matter_engine may be a JS object,
      # which does not have Ruby's `!@` method
      @matter_engine ? true : false
    end

    # Call Matter.Runner.tick
    # - time: time given by requestAnimationFrame
    def self.matter_tick(time)
      %x{
        Matter.Runner.tick(#{Sprite._matter_runner}, #{Sprite._matter_engine}, time);
        Matter.Composite.allBodies(#{Sprite._matter_engine}.world).forEach((body) => {
          var [type, sprite, info] = #{Sprite._matter_sprites[`body.id`]};
          switch(type) {
          case "rectangle":
            var [width, height] = info;
            sprite['$_move_to_matter_body'](body.position.x, body.position.y);
            sprite['$angle='](body.angle / Math.PI * 180);
            break;
          default:
            `#{raise "unknown type: #{type}"}`
          }
        });
      }
    end
  end
end
