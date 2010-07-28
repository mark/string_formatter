class StringFormatter

  #############
  #           #
  # Constants #
  #           #
  #############
  
  STRING_FORMAT_REGEX = /[^%]+|%./
  
  SPECIAL_CHARACTER_FORMATS = {
    'ampersand' => '&',
    'at' => '@',
    'backslash' => '\\',
    'backtick' => '`',
    'bang' => '!',
    'caret' => '^',
    'cash' => '$',
    'colon' => ':',
    'comma' => ',',
    'dash' => '-',
    'double_quote' => '"',
    'eight' => '8',
    'equals' => '=',
    'five' => '5',
    'four' => '4',
    'hash' => '#',
    'left_bracket' => '[',
    'left_chevron' => '<',
    'left_paren' => '(',
    'left_stache' => '{',
    'nine' => '9',
    'one' => '1',
    'percent' => '%', # Defining this method is not recommended
    'period' => '.',
    'pipe' => '|',
    'plus' => '+',
    'quote' => "'",
    'right_bracket' => ']',
    'right_chevron' => '>',
    'right_paren' => ')',
    'right_stache' => '}',
    'semicolon' => ';',
    'seven' => '7',
    'six' => '6',
    'slash' => '/',
    'splat' => '*',
    'three' => '3',
    'tilde' => '~',
    'two' => '2',
    'underscore' => '_',
    'what' => '?',
    'zero' => '0'
  }
  
  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(object, format_string)
    @object = object
    @format_string = format_string
  end
  
  #################
  #               #
  # Class Methods #
  #               #
  #################
  
  def self.escape_character(object, char)
    escape_method = @escapes[char]
    escape_method ? escape_method[object] : char
  end
  
  def self.method_missing(meth, *args, &block)
    str = meth.to_s
    if str.length == 1
      @escapes ||= {}
      @escapes[str] = block
    elsif SPECIAL_CHARACTER_FORMATS[str]
      @escapes ||= {}
      @escapes[ SPECIAL_CHARACTER_FORMATS[str] ] = block
    else
      super
    end
  end
  
  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def to_s
    split_string = @format_string.scan STRING_FORMAT_REGEX
    
    split_string.map { |str| translate_component(str) }.join
  end
  
  def translate_component(string)
    if string[0...1] == '%'
      char = string[1..-1]
      self.class.escape_character(@object, char)
    else
      string
    end
  end
  
end

class Module
  
  def define_format_string(formatter_method, options = {})
    formatter_class = options[:with]
    
    define_method formatter_method do |format_string|
      formatter_class.new(self, format_string).to_s
    end
  end
  
end
