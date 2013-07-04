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
        evaluations[format] = ->() { format }
      end
    end

    def evaluate_component(object, component)
      case component
        when String
          component
        when Array
          evaluate_format(object, *component)
        else
          raise ArgumentError, component.inspect
      end
    end

    def evaluate_format(object, format, *options)
      behavior = behavior_for(format)

      object.instance_exec(*options, &behavior)
    end

end
