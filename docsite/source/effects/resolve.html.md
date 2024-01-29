---
title: Resolve (Dependency Injection)
layout: gem-single
name: dry-effects
---

Resolve is an effect for injecting dependencies. A simple usage example:

```ruby
require 'dry/effects'

class CreateUser
  include Dry::Effects.Resolve(:user_repo)

  def call(values)
    name = values.values_at(:first_name, :last_name).join(' ')
    user_repo.create(**values.merge(name: name))
  end
end
```

Providing `user_repo` in tests:

```ruby
RSpec.describe CreateUser do
  # adds #provide
  include Dry::Effects::Handler.Resolve

  subject(:create_user) { described_class.new }

  let(:user_repo) { double(:user_repo) }

  it 'creates a user' do
    expect(user_repo).to receive(:create).with(
      first_name: 'John',
      last_name: 'Doe',
      name: 'John Doe'
    )

    provide(user_repo: user_repo) { create_user.(first_name: 'John', last_name: 'Doe') }
  end
end
```

Providing dependencies with middleware:

```ruby
class ProviderMiddleware
  include Dry::Effects::Handler.Resolve

  def initialize(app, dependencies)
    @app = app
    @dependencies = dependencies
  end

  def call(env)
    provide(@dependencies) { @app.(env) }
  end
end
```

Then in `config.ru`:

```ruby
# ...some bootstrapping code ...

use ProviderMiddleware, user_repo: UserRepo.new
run Application.new
```

### Compatibility with `dry-container` and `dry-system`

Any object that responds to `.key?` and `.[]` can be used for providing dependencies. Thus, the default Resolve provider is compatible with `dry-container` and `dry-system` out of the box.

```ruby
def call(env)
  # Assuming App is a subclass of Dry::System::Container
  provide(App) { @app.(env) }
end
```

### Providing static values

One can pass a container to the module builder:

```ruby
class ProviderMiddleware
  include Dry::Effects::Handler.Resolve(Application)

  def initialize(app)
    @app = app
  end

  def call(env)
    # Here Application will be used for resolving dependencies
    provide { @app.(env) }
  end
end
```

### Injecting many keys and using aliases

```ruby
require 'dry/effects'

class CreateUser
  include Dry::Effects.Resolve(
    # Injected as .schema
    # but resolved with 'operations.create_user.schema'
    'operations.create_user.schema',
    # Injected as .repo
    # but resolved with 'repos.user_repo'
    repo: 'repos.user_repo'
  )

  def call(values)
    result = schema.(values)

    if result.success?
      user = repo.create(result.to_h)
      [:ok, user]
    else
      [:err, result]
    end
  end
end
```

### Overriding dependencies in test environment

Sometimes you may want to push dependencies through an existing handler. This is normally needed for testing when you want to replace some dependencies in a test environment for an assembled app, like a Rack application. Passing `overridable: true` enables it:

```ruby
require 'dry/effects'

class ProviderMiddleware
  include Dry::Effects::Handler.Resolve

  def initialize(app)
    @app = app
  end

  def call(env)
    provide(Application, overridable: overridable?) { @app.(env) }
  end

  def overridable?
    ENV['RACK_ENV'].eql?('test')
  end
end
```

Now in tests, you can override some dependencies at will:

```ruby
require 'dry/effects'
require 'rack/test'

RSpec.describe do
  include Rack::Test::Methods
  include Dry::Effects::Handler.Provider

  let(:app) do
    # building an assembled rack app
  end

  describe 'POST /users' do
    let(:user_repo) { double(:user_repo) }

    it 'creates a user' do
      expect(user_repo).to receive(:create).with(
        first_name: 'John', last_name: 'Doe'
      ).and_return(1)

      # Overriding one dependency
      # It will only work if `overridable: true` is passed
      # in the middleware
      provide('repos.user_repo' => user_repo) do
        post(
          '/users',
          JSON.dump(first_name: 'John', last_name: 'Doe'),
          'CONTENT_TYPE' => 'application/json'
        )
      end
    end
  end
end
```
