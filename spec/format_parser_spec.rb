require 'spec_helper'

describe FormatParser do

  let(:escapes) { [] }

  subject { FormatParser.new(escapes) }

  it "should keep characters together" do
    subject.parse("foo").must_equal ["foo"]
  end

  it "should break apart format characters" do
    subject.parse('%a').must_equal [['a']]
  end

  it "should not include blanks" do
    subject.parse('%a%b').must_equal [['a'],['b']]
  end

  it "should handle strings with format characters inside" do
    subject.parse('foo%bar').must_equal ['foo', ['b'], 'ar']
  end

  describe "Simple multicharacter escapes" do

    let(:escapes) { %w(foo) }

    it "should handle multiformat escapes" do
      subject.parse("%foo").must_equal [['foo']]
    end

  end

  describe "Greedy multicharacter escapes" do

    let(:escapes) { %w(f fo foo) }

    it "should handle multiformat escapes" do
      subject.parse("%foo").must_equal [['foo']]
    end

    it "should get the longest first" do
      subject.parse("%foo%fo%f").must_equal [['foo'], ['fo'], ['f']]
    end

  end

  describe "Escaping regex punctuation" do

    let(:escapes) { %w(++) }

    it "should not get confused when a regex symbol is an escape char" do
      subject.parse('%++').must_equal [['++']]
    end

  end


end
