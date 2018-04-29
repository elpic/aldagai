require 'aldagai/variable_managers/base'
require 'aldagai/variable_managers/interactive'
require 'aldagai/variable_managers/normal'

module Aldagai
  class VariableManagerFacade

    def self.build_for(interactive)
      if interactive
        Aldagai::InteractiveVariableManager.new
      else
        Aldagai::NormalVariableManager.new
      end
    end

  end
end
