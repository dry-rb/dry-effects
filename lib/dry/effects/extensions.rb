# frozen_string_literal: true

require "dry/core/extensions"

Dry::Effects.extend(Dry::Core::Extensions)

Dry::Effects.register_extension(:auto_inject) do
  require "dry/effects/extensions/auto_inject"
end

Dry::Effects.register_extension(:system) do
  require "dry/effects/extensions/system"
end

Dry::Effects.register_extension(:rspec) do
  require "dry/effects/extensions/rspec"
end

Dry::Effects.register_extension(:active_support_tagged_logging) do
  require "dry/effects/extensions/active_support/tagged_logging"
end

Dry::Effects.register_extension(:active_support) do
  Dry::Effects.load_extensions(:active_support_tagged_logging)
end
