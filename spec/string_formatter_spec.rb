require 'spec_helper'

describe StringFormatter do

  describe "Basic behavior" do

    class UpcaseFormatter < StringFormatter
      f { first_name.upcase }
      l { last_name.upcase  }
    end

    Person = Struct.new(:first_name, :last_name) do
      include Formattable

      define_format_string :strfup, :with => UpcaseFormatter
    end

    it "should generate the right string format" do
      p = Person.new("Bob", "Smith")

      p.strfup('%l, %f').must_equal "SMITH, BOB"
    end

  end

  describe "Punctuation formatter" do
    
    class PunctuationDummy
      include Formattable

      class PunctuationFormatter < StringFormatter
        punctuation
        pipe { "PIPE" }
      end

      define_format_string :format, with: PunctuationFormatter
    end

    it "should handle punctuation formats" do
      PunctuationDummy.new.format('%|').must_equal "PIPE"
    end

  end

  describe "Default formatter" do

    class DefaultDummy
      include Formattable

      class DefaultFormatter < StringFormatter; b { "Default" }; end

      define_format_string :format, with: DefaultFormatter, default: true
    end

    subject { DefaultDummy.new }

    it "should work with %" do
      string = subject % "%b"
      string.must_equal "Default"
    end
    
    it "should still work with the named method" do
      string = subject.format "%b"
      string.must_equal "Default"
    end
  end

  describe "Inline formatters" do

    class InlineDummy
      include Formattable

      define_format_string :strf do
        f { "Foo" }
      end

      class InheritableFormatter < StringFormatter; a { "Foo" }; end

      define_format_string :strf2, with: InheritableFormatter do
        b { "Bar" }
      end
    end

    it "should automtatically define a formatter class if a block is provided" do
      InlineDummy.new.strf("%f").must_equal "Foo"
    end

    it "should inherit from the formatter provided with :with" do
      skip
      InlineDummy.new.strf2("%a %b").must_equal "Foo Bar"
    end
  end

  describe "Multicharacter formatters" do

    class MulticharDummy
      include Formattable
      class MulticharFormatter < StringFormatter
        foo { "FOO" }
      end
      
      define_format_string :format, with: MulticharFormatter
    end

    it "should allow longer format sequences" do
      MulticharDummy.new.format("%foo").must_equal "FOO"
    end

  end


end
