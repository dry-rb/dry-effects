---
title: Introduction
layout: gem-single
type: gem
name: dry-effects
sections:
  - effects
---

`dry-effects` is a practical, production-oriented implementation of algebraic effects in Ruby.

### Why?

Algebraic effects are a powerful tool for writing composable and testable code in a safe way. Fundamentally, any effect consists of two parts: introduction (throwing effect) and elimination (handling effect with an _effect provider_). One of the many things you can do with them is sharing state:

```ruby
require 'dry/effects'

class CounterMiddleware
  # This adds a `counter` effect provider. It will handle (eliminate) effects
  include Dry::Effects::Handler.State(:counter)

  def initialize(app)
    @app = app
  end

  def call(env)
    # Calling `with_counter` makes the value available anywhere in `@app.call`
    counter, response = with_counter(0) do
      @app.(env)
    end

    # Once processing is complete, the result value
    # will be stored in `counter`

    response
  end
end

### Somewhere deep in your app

class CreatePost
  # Adds counter accessor (by introducing state effects)
  include Dry::Effects.State(:counter)

  def call(values)
    # Value is passed from middleware
    self.counter += 1
    # ...
  end
end
```

`CreatePost#call` can only be called when there's `with_counter` somewhere in the stack. If you want to test `CreatePost` separately, you'll need to use `with_counter` in tests too:

```ruby
require 'dry/effects'
require 'posting_app/create_post'

RSpec.describe CreatePost do
  include Dry::Effects::Handler::State(:counter)

  subject(:create_post) { described_class.new }

  it 'updates the counter' do
    counter, post = with_counter(0) { create_post.(post_values) }

    expect(counter).to be(1)
  end
end
```

Any introduced effect must have a handler. If no handler found you'll see an error:

```ruby
CreatePost.new.({})
# => Dry::Effects::Errors::MissingStateError (Value of +counter+ is not set, you need to provide value with an effect handler)
```

In a statically typed with support for algebraic effects you won't be able to run code without providing all required handlers, it'd be a type error.

It may remind you using global state, but it's not actually global. It should instead be called "goto on steroids" or "goto made unharmful."

### Cmp

State sharing is one of many effects already supported; another example is comparative execution. Imagine you test a new feature that ideally shouldn't affect application responses.

```ruby
require 'dry/effects'

class TestNewFeatureMiddleware
  # `as:` renames handler method
  include Dry::Effects::Handler.Cmp(:feature, as: :test_feature)

  def initialize(app)
    @app = app
  end

  def call(env)
    without_feature, with_feature = test_feature do
      @app.(env)
    end

    if with_feature != without_feature
      # something is different!
    end

    without_feature
  end
end

### Somewhere deep in your app

class PostView
  include Dry::Effects.Cmp(:feature)

  def call
    if feature?
      # do render with feature
    else
      # do render without feature
    end
  end
end
```

The `Cmp` provider will run your code twice so that you can compare the results and detect differences.

### Composition

So far effects haven't shown anything algebraic about themselves. Here comes composition. Any effect is composable with one another. Say we have code using both `State` and `Cmp` effects:

```ruby
require 'dry/effects'

class GreetUser
  include Dry::Effects.Cmp(:excitement)
  include Dry::Effects.State(:greetings_given)

  def call(name)
    self.greetings_given += 1

    if excitement?
      "#{greetings_given}. Hello #{name}!"
    else
      "#{greetings_given}. Hello #{name}"
    end
  end
end
```

It's a simple piece of code that requires a single argument and two effect handlers to run:

```ruby
class Context
  include Dry::Effects::Handler.Cmp(:excitement, as: :test_excitement)
  include Dry::Effects::Handler.State(:greetings_given)

  def initialize
    @greeting = GreetUser.new
  end

  def call(name)
    test_excitement do
      with_greetings_given(0) do
        @greeting.(name)
      end
    end
  end
end

Context.new.('Alice')
# => [[1, "1. Hello Alice"], [1, "1. Hello Alice!"]]
```

The result is two branches with `excitement=false` and `excitement=true`. Every variant has its state handler and hence returns another array with the number of greetings given and the greeting. However, neither our code nor algebraic effects restrict the order in which the effects are meant to be handled so let's swap the handlers:

```ruby
class Context
  # ...
  def call(name)
    with_greetings_given(0) do
      test_excitement do
        @greeting.(name)
      end
    end
  end
end

Context.new.('Alice')
# => [2, ["1. Hello Alice", "2. Hello Alice!"]]
```

Now the same code returns a different result! Even more, it has a different shape (or type, if you will): `((Integer, String), (Integer, String))` vs. `(Integer, (String, String))`!

### Algebraic effects

Algebraic effects are relatively recent research describing a possible implementation of the effect system. An effect is some capability your code requires to be executed. It gives control over what your code does and helps a lot with testing without involving any magic like `allow(Time).to receive(:now).and_return(@time_now)`. Instead, getting the current time is just another effect, as simple as that.

Algebraic effects lean towards functional programming enabling things like dependency injection, mutable state, obtaining the current time and random values in pure code. All that is done avoiding troubles accompanying monad stacks and monad transformers. Even things like JavaScript's `async`/`await` and Python's `asyncio` can be generalized with algebraic effects.

If you're interested in the subject, there is a list of articles, papers, and videos, in no particular order:

- [Algebraic Effects for the Rest of Us](https://overreacted.io/algebraic-effects-for-the-rest-of-us/) by Dan Abramov, an (unsophisticated) introduction for React/JavaScript developers.
- [An Introduction to Algebraic Effects and Handlers](https://www.eff-lang.org/handlers-tutorial.pdf) is an approachable paper describing the semantics. Take a look if you want to know more on the subject.
- [Algebraic Effects for Functional Programming](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/algeff-tr-2016-v2.pdf) is another paper by Microsoft Research.
- [Asynchrony with Algebraic Effects](https://www.youtube.com/watch?v=hrBq8R_kxI0) intro given by Daan Leijen, the author of the previous paper and the [Koka](https://github.com/koka-lang/koka) programming language created specifically for exploring algebraic effects.
- [Do Be Do Be Do](https://arxiv.org/pdf/1611.09259.pdf) describes the Frank programming language with typed effects and ML-like syntax.

### Goal of dry-effects

Despite different effects are compatible one with each other, libraries implementing them (not using them!) are not compatible out of the box. `dry-effects` is aimed to be the standard implementation across dry-rb and rom-rb gems (and possibly others).
