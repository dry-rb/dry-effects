module EffectHelper
  def effect(type, name, identifier, *payload)
    Dry::Effects::Effect.new(
      type: type, name: name, identifier: identifier, payload: payload
    )
  end
end
