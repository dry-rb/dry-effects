# frozen_string_literal: true

module EffectHelper
  def make_handler(type, *args, **kwargs)
    provider = Dry::Effects.providers[type]
    Dry::Effects::Handler.new(provider, args, kwargs)
  end
end
