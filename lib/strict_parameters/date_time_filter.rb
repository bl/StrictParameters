module StrictParameters
  class DateTimeFilter
    class << self
      def supported?(object)
        return true if object.is_a?(DateTime) || object.respond_to?(:to_datetime)

        DateTime.parse(object)
        true
      rescue ArgumentError
        false
      end

      def convert(object)
        return object if object.is_a?(DateTime)
        if object.respond_to?(:to_datetime)
          return object.to_datetime.tap do |converted|
            raise ConversionUnsupported.new(self, object) unless converted.is_a?(DateTime)
          end
        end

        DateTime.parse(object)
      rescue ArgumentError => e
        raise ConversionUnsupported.new(self, object)
      end
    end
  end
end
