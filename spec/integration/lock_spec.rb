# frozen_string_literal: true

RSpec.describe 'locking' do
  include Dry::Effects.Lock
  include Dry::Effects::Handler.Lock

  it 'sets locks' do
    locked = with_lock do
      lock(:foo)
      unlock(lock(:bar))

      [locked?(:foo), locked?(:bar), locked?(:baz)]
    end

    expect(locked).to eql([true, false, false])
  end

  it 'releases locks on exit' do
    locked = with_lock do
      lock(:foo)
      bar = lock(:bar)

      with_lock do
        lock(:baz) if locked?(:foo)
        unlock(bar)
      end

      [locked?(:foo), locked?(:bar), locked?(:baz)]
    end

    expect(locked).to eql([true, false, false])
  end

  example 'using blocks' do
    locked = with_lock do
      [lock(:foo) { locked?(:foo) }, locked?(:foo)]
    end

    expect(locked).to eql([true, false])
  end

  example 'repeated locks' do
    locked = with_lock do
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

    with_lock do
      lock(:foo) do
        with_lock do
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

  context 'injectable backend' do
    let(:backend) { double(:backend) }

    let(:handle) { double(:handle) }

    it 'sets and unsets locks' do
      expect(backend).to receive(:lock).with(:foo, Dry::Effects::Undefined).and_return(handle)
      expect(backend).to receive(:unlock).with(handle)

      with_lock(backend) { lock(:foo) }
    end
  end

  context 'meta' do
    it 'allows to add metadata about locks and retrieve it thereafter' do
      with_lock do
        lock(:foo, meta: 'Foo lock acquired')

        expect(lock_meta(:foo)).to eql('Foo lock acquired')
      end
    end

    it 'returns nil when no meta given' do
      with_lock do
        lock(:foo)

        expect(lock_meta(:foo)).to be_nil
      end
    end

    it 'returns nil when no lock exists' do
      with_lock do
        expect(lock_meta(:foo)).to be_nil
      end
    end
  end
end
