module StrictParameters
  class ParameterUnsupported < KeyError
    attr_reader :param, :type

    def initialize(type, param)
      @param = param
      super("param value '#{param}' unsupported for '#{type}'")
    end
  end

  class FilterTypeUnsupported < KeyError
    attr_reader :param

    def initialize(param)
      @param = param
      super("filter type unsupported: #{param.is_a?(Class) ? param.name : param.class.name}")
    end
  end
end

