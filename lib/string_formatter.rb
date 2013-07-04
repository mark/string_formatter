require_relative 'formattable'
require_relative 'format_parser'
require_relative 'format_evaluator'

class StringFormatter

  #############
  #           #
  # Constants #
  #           #
  #############
  
  PUNCTUATION_FORMATS = {
    'ampersand'     => '&',
    'at'            => '@',
    'backslash'     => '\\',
    'backtick'      => '`',
    'bang'          => '!',
    'caret'         => '^',
    'cash'          => '$',
    'colon'         => ':',
    'comma'         => ',',
    'dash'          => '-',
    'double_quote'  => '"',
    'eight'         => '8',
    'equals'        => '=',
    'five'          => '5',
    'four'          => '4',
    'hash'          => '#',
    'left_bracket'  => '[',
    'left_chevron'  => '<',
    'left_paren'    => '(',
    'left_brace'    => '{',
    'nine'          => '9',
    'one'           => '1',
    # Defining this method is not recommended:
    'percent'       => '%',
    'period'        => '.',
    'pipe'          => '|',
    'plus'          => '+',
    'quote'         => "'",
    'right_bracket' => ']',
    'right_chevron' => '>',
    'right_paren'   => ')',
    'right_brace'   => '}',
    'semicolon'     => ';',
    'seven'         => '7',
    'six'           => '6',
    'slash'         => '/',
    'splat'         => '*',
    'three'         => '3',
    'tilde'         => '~',
    'two'           => '2',
    'underscore'    => '_',
    'what'          => '?',
    'zero'          => '0'
  }.freeze
  
  #################
  #               #
  # Class Methods #
  #               #
  #################
  
  def self.method_missing(escape_sequence, *args, &behavior)
    super unless behavior

    if escaping_as_punctuation? && valid_punctuation_sequence?(escape_sequence)
      escape_sequence = characters_for_punctuation_sequence(escape_sequence)
    end

    escape(escape_sequence, behavior)
  end

  def self.punctuation
    @parsing_punctuation = true
  end

  protected

    def self.characters_for_punctuation_sequence(sequence)
      PUNCTUATION_FORMATS.fetch(sequence.to_s)
    end

    def self.escape(escape_sequence, behavior)
      escapes[escape_sequence.to_s] = behavior
    end

    def self.escapes
      @escapes ||= {}
    end

    def self.escaping_as_punctuation?
      @parsing_punctuation
    end

    def self.valid_punctuation_sequence?(sequence)
      PUNCTUATION_FORMATS.include? sequence.to_s
    end

  public
  
  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################

  def escape(object, format_string)
    escape_method = self.class.escapes[format_string]
    escape_method ? escape_method[object] : format_string
  end
  
  def format(object, format_string)
    parsed_string = parser.parse(format_string)

    evaluator.evaluate(object, parsed_string)
  end

  protected
    
    def evaluator
      @evaluator ||= FormatEvaluator.new(self)
    end

    def parser
      @parser ||= FormatParser.new(self)
    end

end
