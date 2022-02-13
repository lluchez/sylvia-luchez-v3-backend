class Exceptions::ValidationException < StandardError
  attr_reader :field, :value

  def initialize(message, field, value)
    super(message)
    @field = field
    @value = value
  end
end
