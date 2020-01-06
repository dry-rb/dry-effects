# frozen_string_literal: true

RSpec.describe 'forking' do
  include Dry::Effects.State(:counter)
  include Dry::Effects::Handler.State(:counter)
  include Dry::Effects.Fork
  include Dry::Effects::Handler.Fork

  it 'duplicates a handler with the current stack' do
    result = with_fork do
      with_counter(0) do
        begin
          self.counter += 1
          fork do |with_stack|
            with_stack.() do
              self.counter += 10
              [:done, self.counter]
            end
          end
        ensure
          self.counter += 1
        end
      end
    end

    expect(result).to eql([2, [:done, 11]])
  end

  it "doesn't share state between runs" do
    result = with_fork do
      with_counter(0) do
        fork do |with_stack|
          with_stack.() do
            self.counter += 10

            with_stack.() { self.counter += 20 }
          end
        end
      end
    end

    expect(result).to eql([0, 20])
  end

  it 'captures current stack values' do
    _, with_stack = with_fork { with_counter(10) { fork { |stack| stack } } }

    expect(with_stack.() { counter }).to eql(10)
  end
end
