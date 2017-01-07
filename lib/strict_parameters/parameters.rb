module StrictParameters
  class Parameters
    PERMITTED_FILTER_TYPES = [
      StringFilter,
      IntegerFilter
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

    def to_h
      @parameters.to_h
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
    #   age: Filter::Integer,
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
    #     name: StringFilter,
    #   }
    # )
    def permit(filters)
      params = self.class.new

      filters.each do |filter, type|
        unless supported_filter_type?(type)
          raise FilterUnsupported.new(type)
        end

        permit_filter(params, filter, type)
      end

      params
    end

    private

    def supported_filter_type?(type)
      PERMITTED_FILTER_TYPES.include?(type)
    end

    def permit_filter(params, filter, type)
      return unless @parameters.has_key?(filter) && type.supported?(@parameters[filter])

      params[filter] = type.convert(@parameters[filter])
    end
  end
end
