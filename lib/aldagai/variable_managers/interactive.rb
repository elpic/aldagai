require 'tempfile'

module Aldagai
  class InteractiveVariableManager < VariableManager

    def add(name, _variables)
      if ENV['EDITOR'].nil?
        raise Aldagai::EditorNotPresentException.new
      end

      super(name, process_variables)
    end

    private

    def process_variables
      @read_variables ||= read_variables
    end

    def read_variables
      file = nil

      begin
        file = Tempfile.new('variables')

        system("#{ENV['EDITOR']} #{file.path}")

        (file.read || '').split("\n")
      ensure
        if file
          file.close
          file.unlink
        end
      end
    end

  end
end
