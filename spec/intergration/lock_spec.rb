# frozen_string_literal: true

RSpec.describe 'locking' do
  include Dry::Effects.Lock
  include Dry::Effects::Handler.Lock

  it 'sets locks' do
    locked = handle_lock do
      lock(:foo)
      unlock(lock(:bar))

      [locked?(:foo), locked?(:bar), locked?(:baz)]
    end

    expect(locked).to eql([true, false, false])
  end

  it 'releases locks on exit' do
    locked = handle_lock do
      lock(:foo)
      bar = lock(:bar)

      handle_lock do
        lock(:baz) if locked?(:foo)
        unlock(bar)
      end

      [locked?(:foo), locked?(:bar), locked?(:baz)]
    end

    expect(locked).to eql([true, false, false])
  end

  example 'using blocks' do
    locked = handle_lock do
      [lock(:foo) { locked?(:foo) }, locked?(:foo)]
    end

    expect(locked).to eql([true, false])
  end

  example 'repeated locks' do
    locked = handle_lock do
      lock(:foo) do |locked_outer|
        lock(:foo) do |locked_inner|
          [locked_outer, locked_inner, locked?(:foo)]
        end
      end
    end

    expect(locked).to eql([true, false, true])
  end

  example 'nested handlers with repeated locks' do
    locked = []

    handle_lock do
      lock(:foo) do
        locked_inner = handle_lock do
          lock(:foo) do
            locked << locked?(:foo)
          end
        end

        locked << locked?(:foo)
      end

      locked << locked?(:foo)
    end

    expect(locked).to eql([true, true, false])
  end
end
