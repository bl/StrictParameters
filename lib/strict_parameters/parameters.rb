module StrictParameters
  class Parameters
    PERMITTED_FILTER_TYPES = [
      Filter::StringFilter     
    ]

    def initialize(parameters = {})
      @parameters = parameters.with_indifferent_access
    end

    def [](key)
      @parameters[key]
    end

    def []=(key, value)
      @parameters[key] = value
    end

    def require_hash(key)
      value = @parameters[key]
      if value.present? || value == false
        value
      else
        raise ParameterMissing.new(key)
      end

      self.class.new(value)
    end

    # params = StrictParameters::Parameters.new({
    #   person: {
    #     name: 'Francesco',
    #     age: 25
    #   }
    # })
    #
    # params.require_hash(:person).permit(
    #   name: 'Francesco',
    #   age: Integer,
    # )
    #
    # params = StrictParameters::Parameters.new({
    #   person: {
    #     contact: {
    #       name: 'Francesco',
    #     }
    #   }
    # })
    #
    # params.require_hash(:person).permit(
    #   contact: {
    #     name: String,
    #   }
    # )
    def permit(filters)
      params = self.class.new

      filters.each do |filter, type|
        unless supported_filter_type?(type)
          raise UnsupportedFilterType.new(type)
        end

        permit_filter(params, filter, type)
      end

      params
    end

    private

    def supported_filter_type?(type)
      return false if type.is_a?(Hash)
      PERMITTED_FILTER_TYPES.any? { |filter| filter.supported?(type) }
    end

    def permit_filter(params, filter, type)
      return unless @parameters.has_key?(filter)

      params[filter] = type.convert(@parameters[key])
    end
  end
end
