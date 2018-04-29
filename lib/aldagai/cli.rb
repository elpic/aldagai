require 'thor'
require 'aldagai/colors'
require 'aldagai/variable_manager_facade'
require 'aldagai/generators/install'
require 'aldagai/exceptions/base_exception'
require 'aldagai/exceptions/not_enoght_variables_exception'

module Aldagai
  class CLI < Thor
    using Aldagai::Colors

    desc 'install', 'Install aldagai in your application'
    def install
      Aldagai::Generators::Install.start
    end

    desc 'add NAME', 'Add a variable with NAME to be promoted to all environments'
    method_option :values, type: :array, required: false, default: []
    method_option :interactive, type: :boolean, default: false, aliases: '-i'
    def add(name)
      @manager = Aldagai::VariableManagerFacade.build_for(options[:interactive])

      @manager.add(name, options[:values])
    rescue Aldagai::BaseException => exception
      puts exception.to_s.red
      exit(1)
    end

    desc 'clear', 'Clear all the variables that were deployed usefull after a deploy'
    def clear
      @manager = Aldagai::NormalVariableManager.new

      @manager.clear
    end

    desc 'delete NAME', 'Delete the variable with NAME, this will be promoted to all environments'
    def delete(name)
      @manager = Aldagai::NormalVariableManager.new

      @manager.delete(name)
    end

    desc 'show NAME', 'Show the variable NAME that is going to be promoted to all environments'
    def show(name)
      @manager = Aldagai::NormalVariableManager.new

      @manager.show(name)
    end

    desc 'list', 'Show all variables that are going to be promoted'
    def list
      @manager = Aldagai::NormalVariableManager.new

      @manager.list
    end

    desc 'set', 'set'
    def set
      @manager = Aldagai::NormalVariableManager.new

      @manager.set
    end

  end
end
