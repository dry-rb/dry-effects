---
title: Timeout
layout: gem-single
name: dry-effects
---

`Timeout` consists of two methods:

- `timeout` returns an ever-decreasing number of seconds until this number reaches 0.
- `timed_out?` checks if no time left.

The handler provides the initial timeout and uses the monotonic time for counting down.

A practical example is limiting the length of all external HTTP calls during request processing. Sample class for making HTTP requests in an application:

```ruby
class MakeRequest
  include Dry::Effects.Timeout(:http)

  def call(url)
    HTTParty.get(url, timeout: timeout)
  end
end
```

Handling timeouts:

```ruby
class WithTimeout
  include Dry::Effects::Handler.Timeout(:http)
  
  def initialize(app)
    @app = app
  end

  def call(env)
    with_timeout(10.0) { @app.(env) }
  rescue Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout
    [504, {}, ["Gateway Timeout"]]
  end
end
```

The code above guarantees all requests made with `MakeRequest` during `@app.(env)` will finish within 10 seconds. If `@app` doesn't spend much time somewhere else, it gives a reasonably reliable hard limit on request processing.
