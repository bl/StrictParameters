module StrictParameters
  class Parameters
    extend Forwardable

    PERMITTED_FILTER_TYPES = [
      StringFilter,
      IntegerFilter
    ]

    def initialize(parameters = {})
      @parameters = parameters.with_indifferent_access
    end

    def_delegators :@parameters, :to_h, :keys, :key?, :has_key?, :values, :has_value?, :value?, :empty?, :include?

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
      return params unless filters.respond_to?(:each)

      filters.each do |filter, type|
        raise FilterKeyUnsupported.new(filter) unless supported_filter?(filter)
        raise FilterTypeUnsupported.new(type) unless supported_type?(type)

        permit_filter(params, filter, type)
      end

      params
    end

    private

    def supported_filter?(filter)
      filter.is_a?(String) || filter.is_a?(Symbol)
    end

    def supported_type?(type)
      PERMITTED_FILTER_TYPES.include?(type)
    end

    def permit_filter(params, filter, type)
      return unless @parameters.has_key?(filter) && type.supported?(@parameters[filter])

      params[filter] = type.convert(@parameters[filter])
    end
  end
end
