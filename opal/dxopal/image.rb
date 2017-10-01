require 'dxopal/remote_resource'

module DXOpal
  class Image < RemoteResource
    RemoteResource.add_class(Image)

    # Load remote image (called via Window.load_resources)
    def self._load(path_or_url)
      raw_img = `new Image()`
      img_promise = %x{
        new Promise(function(resolve, reject) {
          raw_img.onload = function() {
            resolve(raw_img);
          };
          raw_img.src = path_or_url;
        });
      }

      img = new(0, 0)
      %x{
        #{img_promise}.then(function(raw_img){
          img.$_resize(raw_img.width, raw_img.height);
          img.$_draw_raw_image(0, 0, raw_img);
        });
      }
      return img, img_promise
    end

    # Create an instance of Image
    def initialize(width, height, color=C_DEFAULT, canvas: nil)
      @width, @height = width, height
      @canvas = canvas || `document.createElement("canvas")`
      @ctx = `#{@canvas}.getContext('2d')`
      _resize(@width, @height)
      box_fill(0, 0, @width, @height, color)
    end
    attr_reader :ctx, :canvas, :width, :height

    # Set size of this image
    def _resize(w, h)
      @width, @height = w, h
      %x{
        #{@canvas}.width = w;
        #{@canvas}.height = h;
      }
    end

    # Draw an Image on this image
    def draw(x, y, image)
      %x{
        #{@ctx}.drawImage(#{image.canvas}, x, y);
      }
      return self
    end

    # Draw an Image on this image with rotation
    # - angle: Rotation angle (radian)
    # - center_x, center_y: Rotation center in the `image` (default: center of the `image`)
    def draw_rot(x, y, image, angle, center_x=nil, center_y=nil)
      draw_ex(x, y, image, angle: angle, center_x: center_x, center_y: center_y)
    end

    def draw_ex(x, y, image, options={})
      scale_x = options[:scale_x] || 1
      scale_y = options[:scale_y] || 1
      center_x = options[:center_x] || image.width/2
      center_y = options[:center_y] || image.height/2 
      # TODO: alpha
      # TODO: blend
      angle = options[:angle] || 0

      cx = x + center_x
      cy = y + center_y
      %x{
        #{@ctx}.translate(cx, cy);
        #{@ctx}.rotate(angle * Math.PI / 180.0);
        #{@ctx}.scale(scale_x, scale_y);
        #{@ctx}.drawImage(#{image.canvas}, x-cx, y-cy);
        #{@ctx}.setTransform(1, 0, 0, 1, 0, 0); // reset
      }
      return self
    end

    # Draw some text on this image
    def draw_font(x, y, string, font, color=[255,255,255])
      ctx = @ctx
      %x{
        ctx.font = #{font._spec_str};
        ctx.textBaseline = 'top';
        ctx.fillStyle = #{_rgba(color)};
        ctx.fillText(string, x, y);
      }
      return self
    end

    # Get a pixel as ARGB array
    def [](x, y)
      ctx = @ctx
      ret = nil
      %x{
        var pixel = ctx.getImageData(x, y, 1, 1);
        var rgba = pixel.data;
        ret = [rgba[3], rgba[0], rgba[1], rgba[2]];
      }
      return ret
    end

    # Put a pixel on this image
    def []=(x, y, color)
      box_fill(x, y, x, y, color)
    end

    # Return true if the pixel at `(x, y)` has the `color`
    def compare(x, y, color)
      ctx = @ctx
      rgba1 = _rgba_ary(color)
      rgba2 = nil
      ret = nil
      %x{
        var pixel = ctx.getImageData(x, y, 1, 1);
        rgba2 = pixel.data;
        // TODO: what is the right way to compare an Array and an Uint8ClampedArray?
        ret = rgba1[0] == rgba2[0] &&
              rgba1[1] == rgba2[1] &&
              rgba1[2] == rgba2[2] &&
              rgba1[3] == rgba2[3]
      }
      return ret
    end

    # Draw a line on this image
    def line(x1, y1, x2, y2, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgba(color)};
        ctx.moveTo(x1, y1); 
        ctx.lineTo(x2, y2); 
        ctx.stroke(); 
      }
      return self
    end

    # Draw a rectangle on this image
    def box(x1, y1, x2, y2, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgba(color)};
        ctx.rect(x1, y1, x2-x1+1, y2-y1+1); 
        ctx.stroke(); 
      }
      return self
    end

    # Draw a filled box on this image
    def box_fill(x1, y1, x2, y2, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgba(color)};
        ctx.fillRect(x1, y1, x2-x1+1, y2-y1+1); 
      }
      return self
    end

    # Draw a circle on this image
    def circle(x, y, r, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgba(color)};
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
        ctx.fillStyle = #{_rgba(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.fill();
      }
      return self
    end

    # Draw a triangle on this image
    def triangle(x1, y1, x2, y2, x3, y3, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgba(color)};
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.lineTo(x3, y3);
        ctx.lineTo(x1, y1);
        ctx.stroke();
      }
      return self
    end

    # Draw a filled triangle on this image
    def triangle_fill(x1, y1, x2, y2, x3, y3, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgba(color)};
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.lineTo(x3, y3);
        ctx.fill();
      }
      return self
    end

    # Fill this image with `color`
    def fill(color)
      box_fill(0, 0, @width-1, @height-1, color)
    end

    # Clear this image (i.e. fill with `[0,0,0,0]`)
    def clear
      fill([0, 0, 0, 0])
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

    # Return a string like 'rgba(255, 255, 255, 128)'
    # `color` is 3 or 4 numbers
    def _rgba(color)
      return "rgba(" + _rgba_ary(color).join(', ') + ")"
    end

    # Return an array like `[255, 255, 255, 128]`
    def _rgba_ary(color)
      case color.length
      when 4
        # color is ARGB in DXRuby, so move A to the last
        color[1, 3] + [color[0]/255.0]
      when 3
        # Complement 255 as alpha 
        color + [1.0]
      else
        raise "invalid color: #{color.inspect}"
      end
    end
  end
end
