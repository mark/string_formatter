require 'spec_helper'

describe FormatEvaluator do

  let(:keys) { %w(foo bar a) }

  let(:evaluations) do
    { 'a'   => ->(*args) { "<a>"   },
      'foo' => ->(*args) { "<foo>" },
      'bar' => ->(*args) { "<bar>" }
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

  describe "Evaluating on an object" do

    DummyClass = Struct.new(:bar)
    
    let(:source) { DummyClass.new("baz") }

    let(:evaluations) do
      { 'foo' => ->() { bar } }
    end

    it "should call foo on the evaluated object" do
      subject.evaluate(source, [['foo']]).must_equal 'baz'
    end

  end

  describe "Undefined behaviors" do
    let(:evaluations) { Hash.new }

    it "should return the escape as the text when not defined" do
      subject.evaluate(nil, [['a']]).must_equal 'a'
    end
  end

  describe "Escape options" do

    let(:evaluations) do
      { 'a' => ->(opt)   { opt },
        'b' => ->(*opts) { opts.length },
        'c' => ->()      { 'C' } }
    end

    it "should accept escape options" do
      subject.evaluate(nil, [['a', 'b']]).must_equal 'b'
    end

    it "should accept multiple options" do
      subject.evaluate(nil, [['b', 'foo'], ' ', ['b', 'foo', 'bar']]).must_equal '1 2'
    end

    it "should not complain if there are the wrong # of options" do
      skip # I'm not sure if I want this test to be valid...
      subject.evaluate(nil, [['c'], ['c', 1]]).must_equal 'CC'
    end

  end

end
