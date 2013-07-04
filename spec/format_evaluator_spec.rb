require 'spec_helper'

describe FormatEvaluator do

  let(:keys) { %w(foo bar a) }

  let(:evaluations) do
    { 'a'   => ->(obj) { "<a>"   },
      'foo' => ->(obj) { "<foo>" },
      'bar' => ->(obj) { "<bar>" }
    }
  end

  subject { FormatEvaluator.new(evaluations) }

  it "should pass through strings" do
    subject.evaluate(nil, ['foo']).must_equal "foo"
  end

  it "should format arrays" do
    subject.evaluate(nil, [['a']]).must_equal "<a>"
  end

  it "should join the results" do
    subject.evaluate(nil, ['foo', 'bar']).must_equal "foobar"
  end

  it "should handle combinations of strings and arrays" do
    subject.evaluate(nil, ['foo', ['a'], 'bar']).must_equal "foo<a>bar"
  end

  it "should handle multichar formats" do
    subject.evaluate(nil, [['foo']]).must_equal "<foo>"
  end

  describe "Undefined behaviors" do
    let(:evaluations) { Hash.new }

    it "should return the escape as the text when not defined" do
      subject.evaluate(nil, [['a']]).must_equal 'a'
    end
  end

end
