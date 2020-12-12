RSpec.describe Enumerator::Lazy do
  include Dry::Effects::Handler.Fork
  include Dry::Effects.Fork
  include Dry::Effects::Handler.Reader(:multiplier)
  include Dry::Effects.Reader(:multiplier)

  it "works using fork" do
    enumerator = with_fork do
      with_multiplier(2) do
        fork do |stack|
          Enumerator::Lazy.new([1, 2, 3]) do |yielder, element|
            yielder << stack.() { element * multiplier }
          end
        end
      end
    end

    expect(enumerator.to_a).to eql([2, 4, 6])
    expect(enumerator.any?).to be(true)
  end
end
