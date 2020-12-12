# frozen_string_literal: true

RSpec.describe "resolving implicits" do
  include Dry::Effects.Implicit(:show)

  context "dynamic implicits" do
    include Dry::Effects::Handler.Implicit(:show)

    example "providing implicits" do
      shown = with_implicit(Integer => -> int { "<#{int}>" }) do
        show(5)
      end

      expect(shown).to eql("<5>")
    end

    example "multiple handlers" do
      shown = with_implicit(String => -> str { str.inspect }) do
        with_implicit(Integer => -> int { "<#{int}>" }) do
          [show(5), show("foo")]
        end
      end

      expect(shown).to eql(["<5>", '"foo"'])
    end

    example "extra arguments" do
      shown = with_implicit(Integer => -> x, y { "<#{x + y}>" }) do
        show(5, 5)
      end

      expect(shown).to eql("<10>")
    end
  end

  context "static implicits" do
    include Dry::Effects::Handler.Implicit(
      :show,
      Integer => -> int { "<#{int}>" },
      String => -> str { str.inspect }
    )

    example "using static lookup" do
      shown = with_implicit do
        [show(5), show("foo")]
      end

      expect(shown).to eql(["<5>", '"foo"'])
    end

    describe "with dynamic implicits" do
      example "dynamic implicits are added and take precedence" do
        map = {
          Integer => -> int { "[#{int}]" },
          Time => -> t { t.strftime("%Y-%m-%d") }
        }

        shown = with_implicit(map) do
          [show(5), show("foo"), show(Time.new(2020, 1, 1))]
        end

        expect(shown).to eql(["[5]", '"foo"', "2020-01-01"])
      end
    end
  end
end
