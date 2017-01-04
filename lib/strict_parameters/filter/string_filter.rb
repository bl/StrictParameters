module StrictParameters
  module Filter
    class StringFilter
      SUPPORTED_CLASSES = [String, Symbol]
      class << self
        def supported?(klass)
          SUPPORTED_CLASSES.include?(klass)
        end

        def convert(object)
          raise ParameterUnsupported.new(self, object) unless object.respond_to?(:to_s)
          object.to_s
        end
      end
    end
  end
end

