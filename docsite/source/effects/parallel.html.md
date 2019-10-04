---
title: Parallel execution
layout: gem-single
name: dry-effects
---

There are two effects for using parallelism:

- `par` creates a unit of parallel execution;
- `join` combines an array of units to the array of their results.

`par`/`join` is almost identical to `defer`/`wait` from [`Defer`](/gems/dry-effects/0.1/effects/defer), the difference is in the semantics. `defer` is not supposed to be always awaited, it's usually fired-and-forgotten. On the contrary, `par` is meant to be `join`ed at some point.

```ruby
class MakeRequests
  include Dry::Effects.Resolve(:make_request)

  def call(urls)
    # Run every request in parallel and combine their results
    urls.map { |url| par { make_request.(url) } }.then { |pars| join(pars) }
  end
end
```

Just as [`Defer`](/gems/dry-effects/0.1/effects/defer), `Parallel` uses `concurrent-ruby` under the hood.
