require 'dxopal/sprite/collision_area'

module DXOpal
  class Sprite
    # Methods of Sprite related to collision checking
    module CollisionCheck
      module ClassMethods
        # Run collision checking for set of sprites
        # - offences: Sprite or [Sprite]
        # - defences: Sprite or [Sprite]
        # - shot: method name
        # - hit: method name
        #
        # This method has two modes.
        # - If `offences` and `defences` are the same, collision check will
        #   be performed on each pair from the array. Method `hit` is called
        #   on the each sprite, with the other sprite as an argument.
        # - Otherwise, collision check will be performed on each pair
        #   of offence sprite and defence sprite. In this case,
        #   method `shot` is called on the offence sprite and
        #   method `hit` is called on the defence sprite, with the
        #   other sprite as an argument.
        #
        # TODO: return true if any collition is detected
        # TODO: skip collision checking if shot/hit returned `:discard`
        def check(offences, defences, shot=:shot, hit=:hit)
          offences = Array(offences)
          defences = Array(defences)
          i = j = 0  # trick to use i, j in the `#{}`
          if offences.equal?(defences)
            # any-vs-any mode
            sprites = offences.select{|x| x.is_a?(Sprite)}
            n = sprites.length
            %x{
              for (var i=0; i<n; i++) {
                for (var j=i+1; j<n; j++) {
                  if (#{sprites[i] === sprites[j]}) {
                    #{sprites[i].__send__(hit)};
                    #{sprites[j].__send__(hit)};
                  }
                }
              }
            }
          else
            # offence-vs-defence mode
            %x{
              for (var i=0; i<offences.length; i++) {
                for (var j=0; j<defences.length; j++) {
                  if (#{offences[i] === defences[j]}) {
                    #{offences[i].__send__(shot, defences[j])};
                    #{defences[j].__send__(hit, offences[i])};
                  }
                }
              }
            }
          end
        end
      end

      # Default callback methods of `Sprite.check`
      def shot(other); end
      def hit(other); end

      # Called from Sprites#initialize
      def _init_collision_info(image)
        @collision ||= nil
        @collision_enable = true if @collision_enable.nil?
        @collision_sync = true if @collision_sync.nil?
        @_collision_area ||=
          if image
            CollisionArea::Rect.new(self, 0, 0, image.width, image.height)
          else
            nil
          end
      end
      # Whether collision is detected for this object (default: true)
      attr_accessor :collision_enable
      # Whether collision areas synchronize with .scale and .angle (default: true)
      # Setting this to false may improve collision detection performance
      attr_accessor :collision_sync
      # Return an array represents its collision area
      attr_reader :collision
      # (internal) Return a CollisionArea object
      attr_reader :_collision_area

      # Set collision area of this sprite
      def collision=(area_spec)
        @_collision_area =
          case area_spec.length
          when 2 then CollisionArea::Point.new(self, *area_spec)
          when 3 then CollisionArea::Circle.new(self, *area_spec)
          when 4 then CollisionArea::Rect.new(self, *area_spec)
          when 6 then CollisionArea::Triangle.new(self, *area_spec)
          else 
            raise "Inlivad area data: #{x.inspect}"
          end
        @collision = area_spec
      end

      # Return true when this sprite collides with other sprite(s)
      def ===(sprite_or_sprites)
        return check(sprite_or_sprites).any?
      end

      # Return list of sprites collides with this sprite
      def check(sprite_or_sprites)
        sprites = Array(sprite_or_sprites)
        return sprites.select{|sprite| _collides?(sprite)}
      end

      # Return true when this sprite collides with `sprite`
      def _collides?(sprite)
        if @_collision_area.nil? || sprite._collision_area.nil?
          raise "Sprite image not set"
        end
        return false if !self._collidable? || !sprite._collidable?
        return @_collision_area.collides?(sprite._collision_area)
      end

      # Return true when this sprite may collide
      def _collidable?
        return !@vanished && @collision_enable
      end
    end
  end
end
