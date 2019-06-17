# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider[:current_time]
        param :time, default: -> { Undefined }

        def current_time
          Undefined.default(time) { Time.now }
        end
      end
    end
  end
end
