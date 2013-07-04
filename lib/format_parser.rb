class FormatParser

  #############
  #           #
  # Constants #
  #           #
  #############
  
  STRING_FORMAT_REGEX = /[^%]+|%./

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(formatter)
    @formatter = formatter
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def parse(string)
    Array.new.tap do |parsed|
      string.scan STRING_FORMAT_REGEX do |match|
        parsed << if match[0] == '%'
          Array match[1..-1]
        else
          match
        end
      end
    end
  end

end
