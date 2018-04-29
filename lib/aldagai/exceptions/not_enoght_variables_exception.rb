require_relative './base_exception'

module Aldagai
  class NotEnoghtVariablesException < Aldagai::BaseException

    def initialize(required_variables)
      @required_variables = required_variables
    end

    def to_s
      message = <<-MESSAGE
        Not enoght variables, #{@required_variables} are required. You can set them
        using --values (-v) for normal mode or your preferred editor using interactive mode (-i)
      MESSAGE

      message.gsub(/\s+/, ' ').strip
    end

  end
end
