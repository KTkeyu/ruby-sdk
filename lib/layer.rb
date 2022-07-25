class Layer
  attr_accessor :name
  attr_accessor :rule_id

  def initialize(name, value = {}, rule_id = '', exposure_log_func = nil)
    @name = name
    @value = value
    @rule_id = rule_id
    @exposure_log_func = exposure_log_func
  end

  def get(index, default_value)
    return default_value if @value.nil? || !@value.key?(index)

    if @exposure_log_func.is_a? Proc
      @exposure_log_func.call(self, index)
    end

    @value[index]
  end

  def get_typed(index, default_value)
    return default_value if @value.nil? || !@value.key?(index)
    return default_value if @value[index].class != default_value.class and default_value.class != TrueClass and default_value.class != FalseClass

    if @exposure_log_func.is_a? Proc
      @exposure_log_func.call(self, index)
    end

    @value[index]
  end
end