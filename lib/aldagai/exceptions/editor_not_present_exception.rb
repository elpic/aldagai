require_relative './base_exception'

module Aldagai
  class EditorNotPresentException < Aldagai::BaseException

    def to_s
      message = <<-MESSAGE
        In order to access interactive mode you neet to set an environment variable with the editor
        you want to use. For example you can run the following command on a terminal
        export EDITOR=vim. This will use vim to enter your variables.
      MESSAGE

      message.gsub(/\s+/, ' ').strip
    end

  end
end
