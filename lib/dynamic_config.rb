class DynamicConfig
  class << self
    # --- Config accessors that don't follow convention --- #
    def cors_origins
      cors['origins'].split(/\s+/)
    end
    # --- End config accessors that don't follow convention --- #

    # Any config YAML in the config directory can be accessed by calling
    # SsmConfig.config_name. For example, if you wish to access config/foo.yml,
    # just call SsmConfig.foo from anywhere in the app. The YAML will be parsed
    # into a hash.
    def method_missing(meth, *args, &block)
      if yml_file_exists?(meth)
        write_config_accessor_for(meth)
        send(meth)
      else
        super
      end
    end

    def respond_to_missing?(meth, _include_private = false)
      yml_file_exists?(meth)
    end

    private

    def parse_config_file(filename)
      YAML.safe_load(ERB.new(File.read(Rails.root.join("config/#{filename}"))).result).with_indifferent_access
    end

    def parse_config_file_with_env(filename)
      yaml_loaded = parse_config_file(filename)
      (yaml_loaded[Rails.env] || yaml_loaded['any']).with_indifferent_access
    end

    def write_config_accessor_for(meth)
      instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{meth}
          @#{meth} ||= parse_config_file_with_env('#{meth}.yml')
        end
      RUBY
    end

    def yml_file_exists?(meth)
      File.exist?(Rails.root.join('config', "#{meth}.yml"))
    end
  end
end
