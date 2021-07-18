# frozen_string_literal: true

RSpec.describe "comparative effect" do
  include Dry::Effects.Cmp(:feature)
  include Dry::Effects::Handler.Cmp(:feature, as: :alternative)

  it "runs code with both options" do
    result = alternative do
      if feature?
        :feature
      else
        :no_feature
      end
    end

    expect(result).to eql(%i[no_feature feature])
  end

  context "choosing the branch" do
    it "can use one branch or another by passing an argument to the handler" do
      result = alternative(false) do
        if feature?
          raise
        else
          :no_feature
        end
      end

      expect(result).to be(:no_feature)

      result = alternative(true) do
        if feature?
          :feature
        else
          raise
        end
      end

      expect(result).to be(:feature)
    end
  end
end
