# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Random < Provider[:random]
        param :seed, default: -> { Undefined }

        public :rand
      end
    end
  end
end
