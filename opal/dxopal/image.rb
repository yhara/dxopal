module DXOpal
  class Image
    # Load remote image
    # Instance of Image is returned immediately, but Window.loop will
    # wait until image is load
    # Image#width, #height will return 0 until image is load
    def self.load(path_or_url)
      raw_img = `new Image()`
      img_promise = %x{
        new Promise(function(resolve, reject) {
          raw_img.onload = function() {
            resolve(raw_img);
          };
          raw_img.src = path_or_url;
        });
      }
      Window._add_remote_resource(img_promise)

      img = new(0, 0)
      %x{
        #{img_promise}.then(function(raw_img){
          img.$_resize(raw_img.width, raw_img.height);
          img.$_draw_raw_image(0, 0, raw_img);
        });
      }
      return img
    end

    # Create an instance of Image
    def initialize(width, height, color=C_DEFAULT, canvas: nil)
      @width, @height = width, height
      @canvas = canvas || `document.createElement("canvas")`
      @ctx = `#{@canvas}.getContext('2d')`
      _resize(@width, @height)
      box_fill(0, 0, @width, @height, color)
    end
    attr_reader :ctx, :width, :height

    # Set size of this image
    def _resize(w, h)
      @width, @height = w, h
      %x{
        #{@canvas}.width = w;
        #{@canvas}.height = h;
      }
    end

    # Draw this image on Window
    def draw(x, y, image)
      %x{
        #{@ctx}.putImageData(#{image._image_data}, x, y);
      }
      return self
    end

    # Draw a filled box on this image
    def box_fill(x1, y1, x2, y2, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.fillRect(x1, y1, x2-x1, y2-y1); 
      }
      return self
    end

    # Draw a circle on this image
    def circle(x, y, r, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.stroke();
      }
      return self
    end

    # Draw a filled circle on this image
    def circle_fill(x, y, r, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.fill();
      }
      return self
    end

    # Return an Image which is a copy of the specified area
    def slice(x, y, width, height)
      newimg = Image.new(width, height)
      data = _image_data(x, y, width, height)
      newimg._put_image_data(data, 0, 0)
      return newimg
    end

    # Slice this image into xcount*ycount tiles
    def slice_tiles(xcount, ycount)
      tile_w = @width / xcount
      tile_h = @height / ycount
      return (0...ycount).flat_map{|v|
        (0...xcount).map{|u|
          slice(tile_w * u, tile_h * v, tile_w, tile_h)
        }
      }
    end

    # Copy an <img> onto this image
    def _draw_raw_image(x, y, raw_img)
      %x{
        #{@ctx}.drawImage(#{raw_img}, x, y)
      }
    end

    # Return .getImageData
    def _image_data(x=0, y=0, w=@width, h=@height)
      return `#{@ctx}.getImageData(x, y, w, h)`
    end

    # Call .putImageData
    def _put_image_data(image_data, x, y)
      `#{@ctx}.putImageData(image_data, x, y)`
    end

    # Return a string like 'rgb(255, 255, 255)'
    # `color` is 3 or 4 numbers
    def _rgb(color)
      case color.length
      when 4
        # Just ignore alpha
        rgb = color[1, 3]
      when 3
        rgb = color
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgb(" + rgb.join(', ') + ")";
    end

    # Return a string like 'rgb(255, 255, 255, 128)'
    # `color` is 3 or 4 numbers
    def _rgba(color)
      case color.length
      when 4
        rgba = color[3] + color[1, 3]
      when 3
        # Complement 255 as alpha 
        rgba = color + [255]
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgba(" + rgba.join(', ') + ")"
    end
  end
end
