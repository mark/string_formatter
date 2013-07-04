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

end
