# frozen_string_literal: true

module Dry
  module Effects
    module Constructors
      # @api public
      def CurrentTime(**kwargs)
        if kwargs.empty?
          Effects::CurrentTime::CurrentTime
        else
          Effects::CurrentTime::CurrentTime.(**kwargs)
        end
      end

      # @api public
      def Resolve(identifier)
        Effects::Resolve::Resolve.(identifier)
      end

      # @api public
      def Retry(scope) = Effects::Retry::Retry.new(type: :retry, scope: scope)

      # @api public
      def Read(scope) = Effects::State::State.new(type: :state, name: :read, scope: scope)

      # @api public
      def Write(scope, value)
        Effects::State::State.new(type: :state, name: :write, scope: scope, payload: [value])
      end

      instance_methods(false).each { module_function(_1) }
    end
  end
end
