require 'spec_helper'

describe FormatParser do

  subject { FormatParser.new(nil) }

  it "should keep characters together" do
    subject.parse("foo").must_equal ["foo"]
  end

  it "should break apart format characters" do
    subject.parse('%a').must_equal [['a']]
  end

  it "should handle strings with format characters inside" do
    subject.parse('foo%bar').must_equal ['foo', ['b'], 'ar']
  end

end
