class FormatEvaluator

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :formatter

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
  
  def evaluate(object, parsed_components)
    evaluated = parsed_components.map do |component|
      evaluate_component(object, component)
    end

    evaluated.join ''
  end

  protected

    def evaluate_component(object, component)
      if component.kind_of? String
        component
      elsif component.kind_of? Array
        evaluate_format(object, *component)
      else
        raise ArgumentError, component.inspect
      end
    end

    def evaluate_format(object, format, options = nil)
      formatter.escape(object, format)
    end

end
