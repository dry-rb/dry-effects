# frozen_string_literal: true

module Test
  class App < Dry::Effects::System::Container
    configure do |config|
      config.root = ::File.expand_path(::File.join(__dir__, ".."))
      config.component_dirs.namespaces.add "test", key: nil
      config.component_dirs.add_to_load_path = true
      config.component_dirs.add "app"
    end

    Import = injector

    register_provider(:persistence) do
      prepare {}
      start {}
    end
  end
end
