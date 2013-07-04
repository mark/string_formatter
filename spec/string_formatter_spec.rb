require 'spec_helper'

describe StringFormatter do

  class PersonFormatter < StringFormatter    
    f { |p| p.first_name }
    F { |p| p.first_name.upcase }
    l { |p| p.last_name  }

    punctuation

    pipe { |p| 'PIPE' }
  end

  class UpcaseFormatter < StringFormatter
    f { |p| p.first_name.upcase }
    l { |p| p.last_name.upcase  }
  end

  Person = Struct.new(:first_name, :last_name) do
    include Formattable

    define_format_string :strf,   :with => PersonFormatter
    define_format_string :strfup, :with => UpcaseFormatter
  end

  it "should generate the right string format" do
    p = Person.new("Bob", "Smith")

    p.strfup('%l, %f').must_equal "SMITH, BOB"
  end

  it "should handle special characters" do
    p = Person.new("Bob", "Smith")

    p.strf('%l, %f %|').must_equal "Smith, Bob PIPE"
  end  

  describe "Default formatter" do

    class DefaultDummy
      include Formattable

      class DefaultFormatter < StringFormatter; b { |d| "Default" }; end

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
        f { |d| "Foo" }
      end

      class InheritableFormatter < StringFormatter; a { |d| "Foo" }; end

      define_format_string :strf2, with: InheritableFormatter do
        b { |d| "Bar" }
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

end
