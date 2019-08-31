# frozen_string_literal: true

module Dry
  module Effects
    module Constructors
      def self.register(name, &block)
        define_method(name, &block)
        module_function name
      end
    end
  end
end
