module DXOpal
  class Image
    def self.load(path_or_url)
      raw_img = Window._load_remote_image(path_or_url)
      new(raw_img)
    end

    def initialize(raw_img)
      @raw_img = raw_img
    end
    attr_reader :raw_img
  end
end
