---
title: Interrupt
layout: gem-single
name: dry-effects
---

Interrupt is an effect with the semantics of `raise`/`rescue` or `throw`/`catch`. It's added for consistency and compatibility with other effects. Underneath, it uses `raise` + `rescue` so that application code can detect the bubbling.

### Basic usage

If you know what exceptions are, this should look familiar:

```ruby
require 'dry/effects'

class RunDivision
  include Dry::Effects::Handler.Interrupt(:division_by_zero, as: :catch_zero_division)

  def call
    error, answer = catch_zero_division do
      yield
    end

    if error
      :error
    else
      answer
    end
  end
end

class Divide
  include Dry::Effects.Interrupt(:division_by_zero)

  def call(dividend, divisor)
    if divisor.zero?
      division_by_zero
    else
      dividend / divisor
    end
  end
end

run = RunDivision.new
divide = Divide.new

app = -> a, b { run.() { divide.(a, b) } }

app.(10, 2) # => 5
app.(1, 0) # => :error
```

The handler returns a flag indicating whether there was an interruption. `false` means the block was run without interruption, `true` stands for the code was interrupted at some point.

### Payload

Interruption can have a payload:

```ruby
class Callee
  include Dry::Effects.Interrupt(:halt)

  def call
    halt :foo
  end
end

class Caller
  include Dry::Effects::Handler.Interrupt(:halt, as: :catch_halt)

  def call
    _, result = catch_halt do
      yield
      :bar
    end

    result
  end
end

caller = Caller.new
callee = Callee.new

caller.() { callee.() } # => :foo
caller.() { } # => :bar
```

### Composition

Every Interrupt effect has to have an identifier so that they don't overlap. It's an equivalent of exception types. You can nest handlers with different identifiers; they will work just as you would expect:

```ruby
class Catcher
  include Dry::Effects::Handler(:div_error, as: :catch_div)
  include Dry::Effects::Handler(:sqrt_error, as: :catch_sqrt)

  def call
    _, div_result = catch_div do
      _, sqrt_result = catch_sqrt do
        yield
      end

      sqrt_result
    end

    div_result
  end
end
```
