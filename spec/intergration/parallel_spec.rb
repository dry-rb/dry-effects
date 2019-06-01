RSpec.describe 'using parallel effects' do
  include Dry::Effects[:parallel]
  include Dry::Effects[:current_time]
  include Dry::Effects::Handler[:current_time, as: :with_fixed_time]

  let(:handler) { make_handler(:parallel) }

  let(:time) { Time.now }

  example 'running effectful code in parallel' do
    result = with_fixed_time(time) do
      handler.() do
        join(Array.new(3) { |i| par { ["Thread##{i}", current_time] } })
      end
    end

    expect(result).to eql([["Thread#0", time], ["Thread#1", time], ["Thread#2", time]])
  end
end
