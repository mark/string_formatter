require 'spec_helper'

describe FormatParser do

  let(:escapes) { [] }

  let(:options) { {} }

  subject { FormatParser.new(escapes, options) }

  describe "Without explicit escapes" do
    
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

  describe "Sequences with options" do

    let(:escapes) { %w(a bc c) }

    let(:options) { { 'a' => /\d/, 'c' => /b/ } }

    it "should correctly parse the options" do
      subject.parse('%1a').must_equal [['a', '1']]
    end

    it "should not parse invalid options" do
      subject.parse('%xa').must_equal [['x'], 'a']
    end

    it "should do I don't know what?" do
      subject.parse('%a').must_equal [['a']]
    end

    it "should favor longer matches instead of shorter+options" do
      subject.parse('%bc').must_equal [['bc']]
    end

  end

  describe "Longer sequences with options" do
  
    let(:escapes) { %w(foo oo) }

    let(:options) { { 'foo' => /\d/, 'oo' => /f/ } }

    it "should correctly handle escapes with options" do
      subject.parse('%1foo').must_equal [['foo', '1']]
    end

    it "should favor longer matches instead of shorter+options" do
      subject.parse('%foo').must_equal [['foo']]
    end

  end


end
