---
title: Current Time
layout: gem-single
name: dry-effects
---

Obtaining the current time with `Time.now` is a classic example of a side effect. Code relying on accessing system time is harder to test. One possible solution is passing time around explicitly, but using effects can save you some typing depending on the case.

Providing and obtaining the current time is straightforward:

```ruby
require 'dry/effects'

class CurrentTimeMiddleware
  include Dry::Effects::Handler.CurrentTime

  def initialize(app)
    @app = app
  end

  def call(env)
    # It will use Time.now internally once and set it fixed
    with_current_time do
      @app.(env)
    end
  end
end

###

class CreateSubscription
  include Dry::Effects.Resolve(:subscription_repo)
  include Dry::Effects.CurrentTime

  def call(values)
    subscription_repo.create(
      values.merge(start_at: current_time)
    )
  end
end
```

### Providing time in tests

A typical usage would be:

```ruby
require 'dry/effects'

RSpec.configure do |config|
  config.include Dry::Effects::Handler.CurrentTime
  config.include Dry::Effects.CurrentTime

  config.around { |ex| with_current_time(&ex) }
end
```

Then anywhere in tests, you can use it:

```ruby
it 'uses current time as a start' do
  subscription = create_subscription(...)
  expect(subscription.start_at).to eql(current_time)
end
```

To change the time, call `with_current_time` with a proc:

```ruby
it 'closes a subscription with current time' do
  future = current_time + 86_400
  closed_subscription = with_current_time(proc { future }) { close_subscription(subscription) }
  expect(closed_subscription.closed_at).to eql(future)
end
```

Wrapping time with a proc is required, read about generators below.

### Time rounding

`current_time` accepts an argument for rounding time values. It can be passed statically to the module builder or dynamically to the effect constructor:

```ruby
class CreateSubscription
  include Dry::Effects.CurrentTime(round: 3)

  def call(...)
    # value will be rounded to milliseconds
    current_time
    # value will be rounded to microseconds
    current_time(round: 6)
  end
end
```

### Time is fixed

By default, calling `with_current_time` even without arguments will freeze the current time. This means `current_time` will return the same value during request processing etc.

You can "unfix" time with passing `fixed: false` to the handler builder:

```ruby
include Dry::Effects::Handler.CurrentTime(fixed: false)
```

However, this is not recommended because it will make the behavior of `current_time` different in tests (where you pass a fixed value) and in a production environment.

### Using a custom generator

The default time provider accepts a custom generator which is a simple callable object. This way you can pass a proc with fixed time:

```ruby
frozen = Time.now
with_fixed_time(proc { frozen }) do
  # ...
end
```

Or you can change time on every call:

```ruby
start = Time.now
with_fixed_time(proc { start += 0.1 }) do
  # ...
end
```

### Discrete time shifts

If you pass `step: x` to the handler, it will shift the current time on every access by `x`:

```ruby
with_fixed_time(step: 0.1) do
  current_time # => ... 18:00:00.000
  current_time # => ... 18:00:00.100
  current_time # => ... 18:00:00.200
end
```

You can also pass initial time:

```ruby
initial = Time.new(1970)
with_fixed_time(initial: initial, step: 60) do
  current_time # => 1970-01-01 00:00:00 +0000
  current_time # => 1970-01-01 00:01:00 +0000
  current_time # => 1970-01-01 00:02:00 +0000
end
```

### Overriding handlers

Handlers of current time can be overridden by an outer handler if you pass `overridable: true`:

```ruby
require 'dry/effects'

class CurrentTimeMiddleware
  include Dry::Effects::Handler.CurrentTime

  def initialize(app)
    @app = app
  end

  def call(env)
    with_current_time(overridable: ENV['RACK_ENV'].eql?('test')) do
      @app.(env)
    end
  end
end
```

It's usually done in tests:

```ruby
# Using global time
frozen_time = Time.now

puts "Running with time #{frozen_time.iso8601}" if ENV['CI']

RSpec.configure do |config|
  config.include Dry::Effects::Handler.CurrentTime
  config.include(Module.new { define_method(:current_time) { frozen_time } })
  config.around { |ex| with_current_time(proc { frozen_time }, &ex) }
end
```
