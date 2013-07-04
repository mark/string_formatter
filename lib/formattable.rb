module Formattable

  module ClassMethods

    def define_format_string(meth, options = {}, &block)
      base_class = options.fetch(:with) { StringFormatter }
      klass      = formatter_class(base_class, block)

      set_formatter_for meth, klass
      
      define_formatter_method(meth)

      define_default_alias(meth) if options[:default]
    end

    def formatter_for(meth)
      @formatters ||= {}
      @formatters[meth]
    end

    protected

      def define_default_alias(meth)
        alias_method :%, meth
      end

      def define_formatter_method(meth)
        define_method(meth) do |format_string|
          formatter = self.class.formatter_for meth
          formatter.format(self, format_string)
        end
      end

      def formatter_class(superclass, inline_definition)
        if inline_definition
          Class.new(superclass, &inline_definition)
        else
          superclass
        end
      end

      def set_formatter_for(meth, formatter_class)
        @formatters ||= {}
        @formatters[meth] = formatter_class.new
      end

  end

  ##################
  #                #
  # Module Methods #
  #                #
  ##################
  
  def self.included(base)
    base.send :extend, ClassMethods
  end

end
