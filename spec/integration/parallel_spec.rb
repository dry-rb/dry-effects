# frozen_string_literal: true

RSpec.describe "using parallel effects" do
  include Dry::Effects.Parallel
  include Dry::Effects.CurrentTime
  include Dry::Effects.State(:counter)
  include Dry::Effects::Handler.Parallel
  include Dry::Effects::Handler.CurrentTime(as: :with_fixed_time)
  include Dry::Effects::Handler.State(:counter, as: :with_counter)

  let(:handler) { make_handler(:parallel) }

  let(:time) { Time.now }

  example "running effectful code in parallel" do
    result = with_fixed_time(proc { time }) do
      with_parallel do
        join(Array.new(3) { |i| par { ["Thread##{i}", current_time] } })
      end
    end

    expect(result).to eql([["Thread#0", time], ["Thread#1", time], ["Thread#2", time]])
  end

  example "running effectful code in parallel" do
    result = with_counter(0) do
      with_parallel do
        threads = Array.new(2) do
          par do
            self.counter += 1
          end
        end
        join(threads)
      end
    end

    expect(result).to eql([0, [1, 1]])
  end
end
