module DXOpal
  class RemoteResource
    # List of registered resources (Contains path_or_url)
    @@resources = Hash.new{|h,k| h[k] = {}}
    # Contains promises
    @@promises = Hash.new{|h,k| h[k] = {}}
    # Contains instances of Image, Sound
    @@instances = Hash.new{|h,k| h[k] = {}}

    # Subclasses of RemoteResource
    @@klasses = {}
    def self.inherited(subklass)
      @@klasses[subklass._klass_name] = subklass
    end

    def self.register(name, path_or_url)
      @@resources[_klass_name] ||= {}
      @@resources[_klass_name][name] = path_or_url
    end

    # Return instance of loaded resource (call on subclasses)
    def self.[](name)
      if (ret = @@instances[_klass_name][name])
        return ret
      else
        raise "#{_klass_name} #{name.inspect} is not registered"
      end
    end

    # Called from Window.load_resources
    def self._load_resources(&block)
      @@resources.each do |klass_name, path_or_urls|
        klass = @@klasses[klass_name] 
        path_or_urls.each do |name, path_or_url|
          if !@@promises[klass_name][name]
            instance, promise = klass._load(path_or_url) 
            @@instances[klass_name][name] = instance
            @@promises[klass_name][name] = promise
          end
        end
      end
      promises = @@promises.values.flat_map(&:values)
      %x{
        Promise.all(#{promises}).then(function() {
          #{block.call}
        });
      }
    end

    # Load actual content (defined on subclasses)
    def self._load
      raise "override me"
    end

    # Return a string like "Image" or "Sound"
    def self._klass_name
      return self.name.split(/::/).last
    end
  end
end
