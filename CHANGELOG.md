# v0.1.2 - 2019-12-15

## Fixed

- Keyword warnings issued by Ruby 2.7 (flash-gordon)

[Compare v0.1.1...v0.1.2](https://github.com/dry-rb/dry-effects/compare/v0.1.1...v0.1.2)

# v0.1.1 - 2019-11-30

## Added

- Extension for RSpec. Some features of RSpec require access to thread-local storage. This extension patches RSpec so that storage is shared between the root fiber and dry-effects context (flash-gordon)

  ```ruby
  # in spec_helper.rb do
  require 'dry/effects'

  Dry::Effects.load_extensions(:rspec)
  ```

[Compare v0.1.0...v0.1.1](https://github.com/dry-rb/dry-effects/compare/v0.1.0...v0.1.1)

# v0.1.0 - 2019-09-28

Initial release.
