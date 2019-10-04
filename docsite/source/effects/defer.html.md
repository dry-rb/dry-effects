---
title: Deferred execution
layout: gem-single
name: dry-effects
---

`Defer` adds three methods for working with deferred code execution:

- `defer` accepts a block and executes it (potentially) on a thread pool. It returns an object that can be awaited with `wait`. These objects are `Promise`s made by `concurrent-ruby`. You can use their API, but it's not fully supported and tested in conjunction with effects.
- `wait` accepts a promise or an array of promises returned by `defer` and returns their values. The method blocks the current thread until all values are available.
- `later` postpones block execution until the handler is finished (see examples below).

### Defer

A simple example:

```ruby
class CreateUser
  include Dry::Effects.Resolve(:user_repo, :send_invitation)
  include Dry::Effects.Defer

  def call(values)
    user = user_repo.create(values)
    defer { send_invitation.(user) }
    user
  end
end
```

In the code above, `send_invitation` is run on a thread pool. It's the simplest way to run code concurrently.

Code within the `defer` block can use some effects but not all of them. For instance, `Interrupt` is not supported because you cannot return from one thread to another. This is a limitation of Ruby and threads in general.

### Handling

The default handler uses `concurrent-ruby` to do the heavy lifting. As an option, it accepts the executor—usually a thread pool where the code will be run.

> Three special values are also supported: `:io` returns the global pool for long, blocking (IO) tasks, `:fast` returns the global pool for short, fast operations, and `:immediate` returns the global ImmediateExecutor object.

By default, `Dry::Effects::Handler.Defer` uses `:io`.

```ruby
class HandleDefer
  include Dry::Effects::Handler.Defer(executor: :immediate)

  def initialize(app)
    @app = app
  end

  def call(env)
    # defer tasks in @app will be run on the same thread
    with_defer { @app.(env) }
  end
end
```

The executor can be passed directly to `with_defer`:

```ruby
def call(env)
  with_defer(executor: :fast) { @app.(env) }
end
```

### Using null executor

For skipping deferred tasks, create a mocked executor

```ruby
require 'concurrent/executor/executor_service'

NullExecutor = Object.new.extend(Concurrent::ExecutorService).tap do |null|
  def null.post
  end
end
```

and provide it in middleware

```ruby
class HandleDefer
  include Dry::Effects::Handler.Defer
  include Dry::Effects::Handler.Env(:environment)

  def initialize(app)
    @app = app
  end

  def call(env)
    with_defer(executor: executor) { @app.(env) }
  end

  def executor
    environment.equal?(:test) ? NullExecutor : :io
  end
end
```

### Later

`later` doesn't return a result that can be awaited. Instead, it starts deferred blocks on handler exit. Consider this example:

```ruby
class CreateUser
  def call(values)
    user_repo.transaction do
      user = user_repo.create(values)
      defer { send_invitation.(user) }
      user_account = account_repo.create(user)
      user
    end
  end
end
```

There is no guarantee `send_invitation` will be run _after_ the transaction finishes. It may lead to race conditions or anomalies. If `account_repo.create` fails with an exception, the transaction will be rolled back yet the invitation will be sent!

`later` captures the block but doesn't run it:

```ruby
later { send_invitation.(user) }
```

The invitaition will be sent when `with_defer` exits:

```ruby
with_defer { @app.(env) }
```

It usually happens outside of any transaction so that anomalies don't occur.
