module Formattable

  module ClassMethods

    def define_format_string(formatter_method, options = {}, &block)
      formatter_class = options.fetch(:with) { StringFormatter }
      
      if block_given?
        formatter_class = Class.new(formatter_class, &block)
      end

      define_method formatter_method do |format_string|
        formatter_class.new(self, format_string).to_s
      end

      if options[:default]
        define_method :% do |format_string|
          formatter_class.new(self, format_string).to_s
        end
      end
    end

  end

  def self.included(base)
    base.send :extend, ClassMethods
  end

end
