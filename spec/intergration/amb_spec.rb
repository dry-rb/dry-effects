RSpec.describe 'ambivalent effect' do
  include Dry::Effects.Amb(:feature)
  include Dry::Effects::Handler[amb: :feature, as: :alternative]

  it 'runs code with both options' do
    result = alternative do
      if feature?
        :feature
      else
        :no_feature
      end
    end

    expect(result).to eql([:no_feature, :feature])
  end
end
