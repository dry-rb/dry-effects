# frozen_string_literal: true

module Test
  module Repos
    class UserRepo
      extend Dry::Effects.Reader(:repos)

      def self.new(*)
        super.tap { |i| repos << i }
      end

      include App::Import['persistence']
    end
  end
end
