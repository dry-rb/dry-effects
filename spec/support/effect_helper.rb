# frozen_string_literal: true

module EffectHelper
  def make_handler(type, *args, **kwargs)
    provider = Dry::Effects.providers[type].new(*args, **kwargs)
    Dry::Effects::Handler.new(provider)
  end
end
