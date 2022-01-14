# frozen_string_literal: true

module Test
  module Operations
    class CreateUser
      extend Dry::Effects.Reader(:operations)

      def self.new(*)
        super.tap { operations << _1 }
      end

      include App::Import["repos.user_repo"]
    end
  end
end
