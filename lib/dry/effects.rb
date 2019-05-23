require "dry/core/constants"
require "dry/effects/version"

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end
  end
end
