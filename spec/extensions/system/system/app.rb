# frozen_string_literal: true

module Test
  class App < Dry::Effects::System::Container
    config.root = ::File.expand_path(::File.join(__dir__, '..'))
    config.default_namespace = 'test'

    Import = injector

    load_paths!('app')
    auto_register!('app')

    boot(:persistence) do |container|
      init() {}
      start() {}
    end
  end
end
