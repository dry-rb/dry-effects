# frozen_string_literal: true

module Dry
  module Effects
    module Constructors
      # @api private
      def self.register(name, &block)
        define_method(name, &block)
        module_function name
      end

      # @api private
      def self.method_missing(name, *args, &block)
        effect_name = name.to_s

        if effect_name[0].match?(/[A-Z]/)
          Effects.const_get(name)

          if respond_to?(name)
            public_send(name, *args, &block)
          else
            raise ArgumentError, "no constructor for #{name} effect"
          end
        else
          super
        end
      end
    end
  end
end
