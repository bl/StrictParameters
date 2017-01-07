module StrictParameters
  class ParameterMissing < KeyError
    attr_reader :param

    def initialize(param)
      @param = param
      super("param '#{param}' is not present in the provided parameter")
    end
  end

  class ConversionUnsupported < KeyError
    attr_reader :param, :type

    def initialize(type, param)
      @param = param
      @type = type
      super("conversion of '#{param}' unsupported for '#{type}'")
    end
  end

  class FilterUnsupported < KeyError
    attr_reader :param

    def initialize(param)
      @param = param
      super("filter type unsupported: #{param.is_a?(Class) ? param.name : param.class.name}")
    end
  end
end

