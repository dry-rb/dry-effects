# frozen_string_literal: true

module Test
  class App < Dry::Effects::System::Container
    configure do |config|
      config.root = ::File.expand_path(::File.join(__dir__, ".."))
      config.component_dirs.default_namespace = "test"
      config.component_dirs.add_to_load_path = true
      config.component_dirs.add "app"
    end

    Import = injector

    boot(:persistence) do |container|
      init {}
      start {}
    end
  end
end
