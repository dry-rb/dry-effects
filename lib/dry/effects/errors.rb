module Dry
  module Effects
    module Errors
      module Error
      end

      class UnhandledEffect < RuntimeError
        include Error

        attr_reader :effect

        def initialize(effect)
          @effect = effect
          super(
            "Effect #{effect.inspect} not handled. "\
            "Effects must be wrapped with corresponding handlers"
          )
        end
      end
    end
  end
end
