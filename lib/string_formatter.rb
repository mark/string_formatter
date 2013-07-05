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
    'left_brace'    => '{',
    'left_bracket'  => '[',
    'left_chevron'  => '<',
    'left_paren'    => '(',
    'left_shovel'   => '<<',
    'left_stache'   => '{{',
    'nine'          => '9',
    'one'           => '1',
    # Defining this method is not recommended:
    'percent'       => '%',
    'period'        => '.',
    'pipe'          => '|',
    'plus'          => '+',
    'quote'         => "'",
    'right_brace'   => '}',
    'right_bracket' => ']',
    'right_chevron' => '>',
    'right_paren'   => ')',
    'right_shovel'  => '>>',
    'right_stache'  => '}}',
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

    set_escape(escape_sequence, behavior)
    set_escape_options(escape_sequence, args.first) if args.length > 0
  end

  def self.punctuation
    @parsing_punctuation = true
  end

  protected

    def self.characters_for_punctuation_sequence(sequence)
      PUNCTUATION_FORMATS.fetch(sequence.to_s)
    end

    def self.escapes
      @escapes ||= {}
    end

    def self.escape_options
      @escape_options ||= {}
    end

    def self.escaping_as_punctuation?
      @parsing_punctuation
    end

    def self.set_escape(escape_sequence, behavior)
      escapes[escape_sequence.to_s] = behavior
    end

    def self.set_escape_options(escape_sequence, options_regex)
      escape_options[escape_sequence.to_s] = options_regex
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
    
    def escape_options
      self.class.escape_options
    end
    
    def escape_sequences
      self.class.escapes.keys
    end

    def evaluations
      self.class.escapes
    end

    def evaluator
      @evaluator ||= FormatEvaluator.new(evaluations)
    end

    def parser
      @parser ||= FormatParser.new(escape_sequences, escape_options)
    end

end
