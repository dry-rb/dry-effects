---
title: State
layout: gem-single
name: dry-effects
---

State is a mutation effect. It allows [reading](/gems/dry-effects/0.1/effects/reader) and _writing_ non-local values.

### Basic usage

Handling code:

```ruby
require 'dry/effects'

class CountCalls
  include Dry::Effects::Handler.State(:counter)

  def call
    counter, result = with_counter(0) do
      yield
    end

    puts "Counter: #{counter}"

    result
  end
end
```

Using code:

```ruby
require 'dry/effects'

class HeavyLifting
  include Dry::Effects.State(:counter)

  def call
    self.counter += 1
    # ... do heavy work ...
  end
end
```

Now it's simple to count calls by gluing two pieces:

```ruby
count_calls = CountCalls.new
heavy_lifting = HeavyLifting.new

count_calls.() { 1000.times { heavy_lifting.() }; :done }
# Counter: 1000
# => :done
```

### Handler interface

As shown above, the State handler returns two values: the accumulated state and the return value of the block:

```ruby
include Dry::Effects::Handler.State(:state)

def run(&block)
  accumulated_state, result = with_state(initial_state) do
    block.call
  end

  # result holds the return value of block.call

  # accumulated_state refers to the last written value
  # or initial_value if the state wasn't changed
end
```

### Identifiers and mixing states

All state handlers and effects have an identifier. Effects with different identifiers are compatible without limitations but swapping the handlers may change the result:

```ruby
require 'dry/effects'

class Program
  include Dry::Effects.State(:sum)
  include Dry::Effects.State(:product)

  def call
    1.upto(10) do |i|
      self.sum += i
      self.product *= i
    end

    :done
  end
end

program = Program.new

extend Dry::Effects::Handler.State(:sum)
extend Dry::Effects::Handler.State(:product)

with_sum(0) { with_product(1) { program.call } }
# => [55, [3628800, :done]]
with_product(1) { with_sum(0) { program.call } }
# => [3628800, [55, :done]]
```

### Relation to Reader

A State handler eliminates Reader effects with the same identifier:

```ruby
require 'dry/effects'

extend Dry::Effects::Handler.State(:counter)
extend Dry::Effects.Reader(:counter)

with_counter(100) { "Counter value is #{counter}" }
# => [100, "Counter values is 100"]
```

### Not providing an initial value

There are cases when an initial value cannot be provided. You can skip the initial value but in this case, reading it _before_ writing will raise an error:

```ruby
extend Dry::Effects::Handler.State(:user)
extend Dry::Effects.State(:user)

with_user { user }
# => Dry::Effects::Errors::UndefinedStateError (+user+ is not defined, you need to assign it first by using a writer, passing initial value to the handler, or providing a fallback value)

with_user do
  self.user = 'John'

  "Hello, #{user}"
end
# => ["John", "Hello, John"]
```

One example is testing middleware without mutating `env`:

```ruby
RSpec.describe AddingSomeMiddleware do
  include Dry::Effects::Handler.State(:env)
  include Dry::Effects.State(:env)

  let(:app) do
    lambda do |env|
      self.env = env
      [200, {}, ["ok"]]
    end
  end

  subject(:middleware) { described_class.new(app) }

  it 'adds SOME_KEY to env' do
    captured_env, _ = middleware.({})

    expect(captured_env).to have_key('SOME_KEY')
  end
end
```

### Default value for Reader effects

When no initial value is given, you can use a block for providing a default value:

```ruby
extend Dry::Effects::Handler.State(:artist)
extend Dry::Effects.State(:artist)

with_artist { artist { 'Unknown Artist' } } # => "Unknown Artist"
```

### When to use?

State is a classic example of an effect. However, using it often can make your code harder to follow.
