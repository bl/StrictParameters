module StrictParameters
  class StringFilter
    class << self
      def supported?(object)
        object.is_a?(String) || object.respond_to?(:to_s)
      end

      def convert(object)
        return object if object.is_a?(String)

        object.to_s.tap do |converted|
          raise ConversionUnsupported.new(self, object) unless converted.is_a?(String)
        end
      end
    end
  end
end

