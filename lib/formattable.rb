module Formattable

  module ClassMethods

    def define_format_string(meth, options = {}, &block)
      formatter_class = options.fetch(:with) { StringFormatter }
      
      if block_given?
        formatter_class = Class.new(formatter_class, &block)
      end

      set_formatter meth, formatter_class.new
      
      define_method meth do |format_string|
        formatter = self.class.formatter(meth)
        formatter.format(self, format_string)
      end

      alias_method(:%, meth) if options[:default]
    end

    def formatter(meth)
      @formatters ||= {}
      @formatters[meth]
    end

    protected

      def set_formatter(meth, formatter)
        @formatters ||= {}
        @formatters[meth] = formatter
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
