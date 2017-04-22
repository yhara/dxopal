module DXOpal
  class Image
    def self.load(path_or_url)
      img_promise = Window._load_remote_image(path_or_url)
      img = new(0, 0)
      %x{
        #{img_promise}.then(function(raw_img){
          img.$_resize(raw_img.width, raw_img.height);
          img.$_draw_raw_image(0, 0, raw_img);
        });
      }
      return img
    end

    def initialize(width, height, color=C_DEFAULT)
      @width, @height = width, height
      @canvas = `document.createElement("canvas")`
      _resize(@width, @height)
      @ctx = `#{@canvas}.getContext('2d')`
    end
    attr_reader :ctx

    def _resize(w, h)
      @width, @height = w, h
      %x{
        #{@canvas}.width = w;
        #{@canvas}.height = h;
      }
    end

    def _draw_raw_image(x, y, raw_img)
      %x{
        #{@ctx}.drawImage(#{raw_img}, x, y)
      }
    end

    def _image_data(x=0, y=0, w=@width, h=@height)
      return `#{@ctx}.getImageData(x, y, w, h)`
    end
  end
end
