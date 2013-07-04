class FormatParser

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :escape_sequences

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(escape_sequences)
    @escape_sequences = escape_sequences
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

    def extract_escape(match)
      if match[0]
        match[0]
      else
        match[1..-1]
      end
    end

    def multichar_sequences
      escape_sequences.select { |seq| seq.length > 1 }
    end

    def escape_regex_fragment
      sorted_sequences = multichar_sequences.sort_by(&:length).reverse
      escaped_sequence = sorted_sequences.map { |str| Regexp.escape(str) }
      components       = escaped_sequence << '.'

      components.join '|'
    end

    def string_format_regex
      /([^%]+)|%(#{ escape_regex_fragment })/
    end

end
