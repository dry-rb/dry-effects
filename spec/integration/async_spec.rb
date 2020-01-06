# frozen_string_literal: true

RSpec.describe 'scheduling effect' do
  include Dry::Effects.Async
  include Dry::Effects::Handler.Async

  def request(i)
    async { i**2 }
  end

  example 'fork-join style' do
    results = []
    snapshots = []

    with_async do
      tasks = Array.new(3) do |i|
        async do
          result = 0

          (i + 1).times do |j|
            result += await request(j)
          end

          results << result
        end
      end

      snapshots << results.dup

      tasks.each do |task|
        await(task)
        snapshots << results.dup
      end
    end

    expect(snapshots).to eql([
                               [],
                               [0],
                               [0, 1],
                               [0, 1, 5]
                             ])
  end
end
