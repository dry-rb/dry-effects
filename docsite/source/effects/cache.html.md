---
title: Cache
layout: gem-single
name: dry-effects
---

Cache provides two interfaces for caching. Set up a handler:

```ruby
require 'dry/effects'

class CacheMiddleware
  # Providing scope is required
  # All cache values will be scoped with this key
  include Dry::Effects::Handler.Cache(:blog)

  def initialize(app)
    @app = app
  end

  def call(env)
    with_cache { @app.env }
  end
end
```

Using `prepend`:

```ruby
require 'dry/effects'

class ShowUsers
  include Dry::Effects.Resolve(:user_repo)
  # It will cache .find_user calls
  # Users with the same id won't be searched twice
  # Effectively (no pun intended),
  # it's `memoize` scoped with the call in CacheMiddleware
  prepend Dry::Effects.Cache(blog: :find_user)

  def call(user_ids)
    users = user_ids.map { find_user(id) }
    # ...
  end

  def find_user(id)
    user_repo.find(id)
  end
end
```

Or using `include`:

```ruby
require 'dry/effects'

class ShowUsers
  include Dry::Effects.Resolve(:user_repo)
  # When included, adds #cache method
  include Dry::Effects.Cache(:blog)

  def call(user_ids)
    users = user_ids.map { cache(:user, id) { user_repo.find(id) } }
    # ...
  end
end
```

### Cache longevity

The default cache handler doesn't (yet) support long-lived storage. Cache values are discarded once `with_cache` returns.

### Using in tests

It's usually OK to have a global handler for cache effects:

```ruby
require 'dry/effects'

with_cache = Object.new.extend(Dry::Effects::Handler.Cache(:my_app, as: :call))

RSpec.configure do |config|
  config.around(:each) { with_cache.(&ex) }
end
```
