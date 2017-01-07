module StrictParameters
  class IntegerFilter
    class << self
      def supported?(object)
        object.is_a?(Integer) || object.respond_to?(:to_i)
      end

      def convert(object)
        return object if object.is_a?(Integer)

        object.to_i.tap do |converted|
          raise ConversionUnsupported.new(self, object) unless converted.is_a?(Integer)
        end
      end
    end
  end
end
