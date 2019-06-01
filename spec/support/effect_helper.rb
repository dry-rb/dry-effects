module EffectHelper
  def effect(type, name, identifier, *payload)
    Dry::Effects::Effect.new(
      type: type, name: name, identifier: identifier, payload: payload
    )
  end

  def make_handler(type, identifier = Dry::Effects::Undefined)
    provider = Dry::Effects.providers[type]
    Dry::Effects::Handler.new(provider, identifier)
  end
end
