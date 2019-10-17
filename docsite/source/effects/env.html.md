---
title: Environment
layout: gem-single
name: dry-effects
---

Configuring code via `ENV` can be handy, but testing it by mutating a global constant is usually not. Env is similar to Reader but exists for passing simple key-value pairs, precisely what `ENV` does.

### Providing environment

```ruby
require 'dry/effects'

class EnvironmentMiddleware
  include Dry::Effects::Handler.Env(environment: ENV['RACK_ENV'])

  def initialize(app)
    @app = app
  end

  def call(env)
    with_env { @app.(env) }
  end
end
```

### Using environment

By default, `Effects.Env` creates accessor to keys with the same name:

```ruby
class CreateUser
  include Dry::Effects.Env(:environment)

  def call(...)
    #
    log unless environemnt.eql?('test')
  end
end
```

But you can pass a hash and use arbitrary method names:

```ruby
class CreateUser
  include Dry::Effects.Env(env: :environment)

  def call(...)
    #
    log unless env.eql?('test')
  end
end
```

### Interaction with `ENV`

The Env handler will search for keys in `ENV` as a fallback:

```ruby
class SendRequest
  include Dry::Effects.Env(endpoint: 'THIRD_PARTY')

  def call(...)
    # some code using `endpoint`
  end
end
```

In a production environment, it would be enough to pass `THIRD_PARTY` an environment variable and call `with_env` at the top of the application:

```ruby
require 'dry/effects'

class SidekiqEnvMiddleware
  include Dry::Effects::Handler.Env

  def call(_worker, _job, _queue, &block)
    with_env(&block)
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add SidekiqEnvMiddleware
  end
end
```

In tests, you can pass `THIRD_PARTY` without modifying `ENV`:

```ruby
RSpec.describe SendRequest do
  include Dry::Effects::Handler.Env

  subject(:send_request) { described_class.new }

  let(:endpoint) { "fake server" }

  around { with_env('THIRD_PARTY' => endpoint, &ex) }

  it 'sends a request to a fake server' do
    send_request.(...)
  end
end
```

### Overriding handlers

By passing `overridable: true` you can override values provided by the nested handler:

```ruby
class Application
  include Dry::Effects.Env(:foo)

  def call
    puts foo
  end
end

class ProvidingContext
  include Dry::Effects::Handler.Env

  def call
    with_env({ foo: 100 }, overridable: true) { yield }
  end
end

class OverridingContext
  include Dry::Effects::Handler.Env

  def call
    with_env(foo: 200) { yield }
  end
end

overriding = OverridingContext.new
providing = ProvidingContext.new
app = Application.new

overriding.() { providing.() { app.() } }
# prints 200, coming from overriding context
```

Again, this is useful for testing, you pass `overridable: true` in the test environment and override environment values in specs.
