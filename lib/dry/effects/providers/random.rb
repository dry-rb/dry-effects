# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Random < Provider[:random]
        public :rand
      end
    end
  end
end
