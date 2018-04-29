require 'platform-api'
require 'aldagai/colors'

module Aldagai
  class VariableManager
    using Aldagai::Colors

    DEFAULT_ENVIRONMENTS = [
      'development',
      'staging',
      'production',
    ]

    def initialize
      @config    = Aldagai::Config.new
      @encryptor = Aldagai::Encryptor.new(@config.secret)
    end

    def add(name, variables)
      if environments.length == variables.length
        environments.zip(variables).each do |environment, value|
          lines = lines_for_environment_without(environment, name)

          rewrite_file_with_lines(environment, lines) do |file|
            file.puts @encryptor.encrypt("#{name.upcase}=#{value}")
          end
        end
      else
        raise Aldagai::NotEnoghtVariablesException.new(environments.length)
      end
    end

    def delete(name)
      environments.each do |environment|
        lines = lines_for_environment_without(environment, name)

        rewrite_file_with_lines(environment, lines) do |file|
          file.puts @encryptor.encrypt("#{name.upcase}=")
        end
      end
    end

    def show(name)
      puts "\n  ==== Variable actions ====\n".blue

      environments.each do |environment|
        line = line_for_environment_with(environment, name)

        if line
          name, value = line.split('=')
          value = value_presence(value)

          log_variable_will_be_added_or_removed(name, value, environment)
        else
          log_no_variables_promoted(environment)
        end
      end

      log_empty_line
    end

    def list
      puts "\n  ==== Variable actions ====\n".blue

      environments.each do |environment|
        lines = lines_for_environment(environment)

        if lines.empty?
          log_no_variables_promoted(environment)
        else
          lines.each do |line|
            name, value = line.split('=')
            value = value_presence(value)

            log_variable_will_be_added_or_removed(name, value, environment)
          end

          log_empty_line
        end
      end

      log_empty_line
    end

    def clear
      environments.each do |environment|
        rewrite_file_with_lines(environment, [])
      end
    end

    def set
      heroku = PlatformAPI.connect_oauth(ENV['ALDAGAI_HEROKU_TOKEN'])
      lines  = lines_for_environment(ENV['ALDAGAI_PIPELINE_ENV'])

      if lines.empty?
        log_no_variables_promoted(environment)
      else
        variables = {}

        lines.each do |line|
          name, value = line.split('=')
          value = value_presence(value)

          log_variable_was_added_or_removed(name, value)

          variables.merge!({name => value})
        end

        heroku.config_var.update(ENV['ALDAGAI_APP_NAME'], variables)
      end
    end

    private

    def environments
      DEFAULT_ENVIRONMENTS
    end

    def rewrite_file_with_lines(environment, lines, &block)
      open(environment_file(environment), 'w') do |file|
        file.truncate(0)

        lines.each do |line|
          file.puts line
        end

        block.call(file) if block_given?
      end
    end

    def log_empty_line
      puts ''
    end

    def log_variable_will_be_added_or_removed(name, value, environment)
      if value
        puts "  ➥ add variable \"#{name}\" with value \"#{value}\" in #{environment}".green
      else
        puts "  ➥ remove variable \"#{name}\" from #{environment}".red
      end
    end

    def log_variable_was_added_or_removed(name, value)
      if value
        puts "  ➥ variable \"#{name}\" was added".green
      else
        puts "  ➥ variable \"#{name}\" was removed".red
      end
    end

    def log_no_variables_promoted(environment)
      puts "  ✘ no variable/s are not going to be promoted to #{environment}".red
    end

    def lines_for_environment(environment)
      file  = environment_file(environment)
      lines = File.exists?(file) && File.readlines(file) || []

      lines.map(&decrypt_line_proc)
    end

    def lines_for_environment_without(environment, name)
      lines_for_environment(environment).select(&does_not_match_line_proc(name))
    end

    def lines_for_environment_with(environment, name)
      lines_for_environment(environment).select(&match_line_proc(name))
    end

    def line_for_environment_with(environment, name)
      lines_for_environment(environment).find(&match_line_proc(name))
    end

    def decrypt_line_proc
      proc { |line| (decrypt_line(line)) }
    end

    def match_line_proc(name)
      proc { |line| (line.start_with?("#{name.upcase}=")) }
    end

    def does_not_match_line_proc(name)
      proc { |line| !(line.start_with?("#{name.upcase}=")) }
    end

    def environment_file(environment)
      File.expand_path("./.#{environment}")
    end

    def decrypt_line(line)
      @encryptor.decrypt(line.gsub("\n", ''))
    end

    def value_presence(value)
      value && value.strip != '' ? value : nil
    end

  end
end
