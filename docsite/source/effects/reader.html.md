---
title: Reader
layout: gem-single
name: dry-effects
---

Reader is the simplest effect. It passes a value down to the stack.

```ruby
require 'dry/effects'

class SetLocaleMiddleware
  include Dry::Effects::Handler.Reader(:locale)

  def initialize(app)
    @app = app
  end

  def call(env)
    with_locale(detect_locale(env)) do
      @app.(env)
    end
  end

  def detect_locale(env)
    # arbitrary detection logic
  end
end

### Anywhere in the app

class GreetUser
  include Dry::Effects.Reader(:locale)

  def call(user)
    case locale
    when :en then "Hello #{user.name}"
    when :de then "Hallo #{user.name}"
    when :ru then "Привет, #{user.name}"
    when :it then "Ciao #{user.name}"
    end
  end
end
```

### Testing with Reader

If you run `GreetUser#call` without a Reader handler, it will raise an error. For unit tests you'll need some wrapping code:

```ruby
RSpec.describe GreetUser do
  include Dry::Effects::Handler.Reader(:locale)

  subject(:greet) { described_class.new }

  let(:user) { double(:user, name: 'John') }

  it 'uses the current locale to greet the user' do
    examples = {
      en: 'Hello John',
      de: 'Hallo John',
      ru: 'Привет, John',
      it: 'Ciao John'
    }

    examples.each do |locale, expected_greeting|
      with_locale(locale) do
        expect(greet.(user)).to eql(expected_greeting)
      end
    end
  end
end
```

You can provide locale in an `around(:each)` hook:

```ruby
require 'dry/effects'

# Build a provider object with .call interface
locale_provider = Object.new.extend(Dry::Effects::Handler.Reader(:locale, as: :call))

RSpec.configure do |config|
  config.around(:each) do |ex|
    locale_provider.(:en, &ex)
  end
end
```

### Nesting readers

As a general rule, if there are two handlers in the stack, the nested takes precedence:

```ruby
require 'dry/effects'

extend Dry::Effects::Handler.Reader(:locale)
extend Dry::Effects.Reader(:locale)

with_locale(:en) { with_locale(:de) { locale } } # => :de
```

### Mixing readers

Every Reader has an identifier. Handlers with different identifiers won't interfere:

```ruby
require 'dry/effects'

extend Dry::Effects::Handler.Reader(:locale)
extend Dry::Effects::Handler.Reader(:context)
extend Dry::Effects.Reader(:locale)
extend Dry::Effects.Reader(:context)

with_locale(:en) { with_context(:background) { [locale, context] } } # => [:en, :background]
# Order doesn't matter:
with_context(:background) { with_locale(:en) { [locale, context] } } # => [:en, :background]
```

### Relation to State

Reader is part of the [State](/gems/dry-effects/0.1/effects/state) effect.

### Tradeoffs of implicit passing

Passing values implicitly is not good or bad by itself; you should consider how it affects your code in every case. Providing the current locale is a good example where reader effect can be justified. On the other hand, passing optional values such as the IP-address of the current user should be done explicitly because they are not always present (consider background jobs, rake tasks, etc.).
