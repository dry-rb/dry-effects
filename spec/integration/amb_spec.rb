# frozen_string_literal: true

RSpec.describe 'ambivalent effect' do
  include Dry::Effects.Amb(:feature)
  include Dry::Effects::Handler.Amb(:feature, as: :alternative)

  it 'runs code with both options' do
    result = alternative do
      if feature?
        :feature
      else
        :no_feature
      end
    end

    expect(result).to eql(%i[no_feature feature])
  end

  context 'choosing the branch' do
    it 'can use one branch or another by passing an argument to the handler' do
      result = alternative(false) do
        if feature?
          fail
        else
          :no_feature
        end
      end

      expect(result).to be(:no_feature)

      result = alternative(true) do
        if feature?
          :feature
        else
          fail
        end
      end

      expect(result).to be(:feature)
    end
  end
end
