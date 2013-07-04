class FormatEvaluator

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :evaluations

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(evaluations)
    @evaluations = evaluations
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

    def behavior_for(format)
      format = format.to_s
      
      evaluations.fetch(format) do
        evaluations[format] = ->(obj) { format }
      end
    end

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
      behavior = behavior_for(format)

      behavior[object]
    end

end
