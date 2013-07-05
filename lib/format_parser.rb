class FormatParser

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :escape_sequences, :escape_options

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(escape_sequences, escape_options)
    @escape_sequences = escape_sequences
    @escape_options   = escape_options
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def parse(string)
    split_string = string.scan(string_format_regex)

    split_string.map { |match| extract_escape(match) }
  end

  protected

    def escape_regexp(escape)
      escape_option = escape_options[escape]
      clean_escape  = Regexp.escape(escape)

      escape_option.to_s + clean_escape
    end

    def escape_regex_fragment
      fragments = sorted_sequences.map { |escape| escape_regexp(escape) }
      fragments << '.'
      fragments.join '|'
    end

    def explicit_sequences
      escape_sequences.select do |escape|
        escape.length > 1 || escape_options[escape]
      end
    end

    def extract_escape(match)
      if match[0]
        match[0]
      else
        extract_options match[1]
      end
    end

    def extract_options(match)
      return [match] if match.length == 1

      matching_escape = explicit_sequences.detect do |escape|
        match =~ /#{Regexp.escape(escape)}$/
      end
      
      if match == matching_escape
        [match]
      else
        options = match[0...-matching_escape.length]

        [matching_escape, options]
      end
    end
    
    def multichar_sequences
      escape_sequences.select { |seq| seq.length > 1 }
    end

    def sorted_sequences
      explicit_sequences.sort_by(&:length).reverse
    end

    def string_format_regex
      /([^%]+)|%(#{ escape_regex_fragment })/
    end

end
