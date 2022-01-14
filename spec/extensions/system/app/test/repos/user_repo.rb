# frozen_string_literal: true

module Test
  module Repos
    class UserRepo
      extend Dry::Effects.Reader(:repos)

      def self.new(*)
        super.tap { repos << _1 }
      end

      include App::Import["persistence"]
    end
  end
end
