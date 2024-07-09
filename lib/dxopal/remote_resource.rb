module DXOpal
  # A base class for resources acquired through JS Promises.
  # Provides `<klass>.register` and `<klass>[name]`.
  # A subclass must impelment `<klass>._load`.
  #
  # TODO: better name? (SoundEffect is not actually 'remote')
  class RemoteResource
    # List of registered resources (Contains path_or_url)
    @@resources = Hash.new{|h,k| h[k] = {}}
    # Contains promises
    @@promises = Hash.new{|h,k| h[k] = {}}
    # Contains instances of Image, Sound
    @@instances = Hash.new{|h,k| h[k] = {}}
    # `true` if the resource is loaded
    @@loaded = Hash.new{|h,k| h[k] = {}}

    # Subclasses of RemoteResource
    @@klasses = {}
    def self.add_class(subklass)
      @@klasses[subklass._klass_name] = subklass
    end

    # Reserve instance generation
    def self.register(name, *args, &block)
      @@resources[_klass_name] ||= {}
      @@resources[_klass_name][name] = [block, args]
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
      @@resources.each do |klass_name, items|
        klass = @@klasses[klass_name] 
        items.each do |name, (block2, args)|
          if !@@promises[klass_name][name]
            instance, promise = klass._load(*args, &block2)
            @@instances[klass_name][name] = instance
            @@loaded[klass_name][name] = false
            @@promises[klass_name][name] = promise.JS.then{ 
              @@loaded[klass_name][name] = true
              RemoteResource._update_loading_status
            }
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
    # Return `[instance, promise]`
    def self._load(*args)
      raise "override me"
    end

    # Return a string like "Image" or "Sound"
    def self._klass_name
      return self.name.split(/::/).last
    end

    # Update loading status if `dxopal-loading` is defined.
    def self._update_loading_status
      done = true
      report = "DXOpal loading...\n" +
        @@promises.map{|klass_name, promises|
          n_total = @@resources[klass_name].count
          n_loaded = @@loaded[klass_name].values.count(true)
          done = false if n_loaded < n_total
          "#{klass_name}: #{n_loaded}/#{n_total}\n"
        }.join
      div = `document.getElementById('dxopal-loading')`
      if `div`
        %x{
          let pre = div.firstChild;
          if (!pre) {
            pre = document.createElement('pre');
            div.appendChild(pre);
          }
          pre.textContent = #{report};
          if (#{done}) {
            div.style.display = 'none';
          }
        }
      end
    end
  end
end
