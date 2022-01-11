# frozen_string_literal: true

module RevbitsPam
  class << self
    def with_configuration(config)
      old_value = Thread.current[:revbits_configuration]
      Thread.current[:revbits_configuration] = config
      yield
    ensure
      Thread.current[:revbits_configuration] = old_value
    end

    def configuration
      Thread.current[:revbits_configuration] || (@config ||= Configuration.new)
    end

    def configuration=(config)
      @config = config
    end

    alias config configuration
    alias config= configuration=

    def configure
      yield configuration
    end
  end

  class Configuration
    attr_reader :explicit
    attr_reader :supplied
    attr_reader :computed

    def initialize(options = {})
      @explicit = options.dup
      @supplied = options.dup
      @computed = Hash.new
    end

    class << self
      def accepted_options
        require 'set'
        @options ||= Set.new
      end

      def add_option(name, options = {}, &def_proc)
        accepted_options << name
        allow_env = options[:env].nil? || options[:env]
        env_var = options[:env] || "REVBITS_#{name.to_s.upcase}"
        def_val = options[:default]
        opt_name = name

        def_proc ||= if def_val.respond_to?(:call)
                       def_val
                     elsif options[:required]
                       proc { raise "Missing required option #{opt_name}" }
                     else
                       proc { def_val }
                     end

        convert = options[:convert] || ->(x) { x }
        convert = convert.to_proc if convert.respond_to?(:to_proc)

        define_method("#{name}=") do |value|
          set name, value
        end

        define_method("#{name}_env_var") do
          allow_env ? env_var : nil
        end

        define_method(name) do
          value = computed[name]
          return value unless value.nil?

          if supplied.member?(name)
            supplied[name]
          elsif allow_env && ENV.member?(env_var)
            instance_exec(ENV[env_var], &convert)
          else
            instance_eval(&def_proc)
          end.tap do |value|
            computed[name] = value
          end
        end

        alias_method("#{name}?", name) if options[:boolean]
      end
    end

    def clone(override_options = {})
      self.class.new self.explicit.dup.merge(override_options)
    end

    def set(key, value)
      if self.class.accepted_options.include?(key.to_sym)
        explicit[key.to_sym] = value
        supplied[key.to_sym] = value
        computed.clear
      end
    end

    add_option :appliance_url, required: true
    add_option :api_key, required: true
    add_option :auth_type, default: :pam
  end
end
