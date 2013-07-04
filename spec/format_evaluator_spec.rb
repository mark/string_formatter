require 'spec_helper'

describe FormatEvaluator do

  class DummyFormatter
    def escape(object, char)
      "<#{char}>"
    end
  end

  let(:formatter) { DummyFormatter.new }

  subject { FormatEvaluator.new(formatter) }

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

end
