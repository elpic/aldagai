require 'thor/group'
require 'securerandom'

module Aldagai
  module Generators
    class Install < Thor::Group

      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__) + '/install'
      end

      def copy_secret
        template('.aldagai.secret', '.aldagai.secret')
      end

      def copy_environments
        template('.development', '.development')
        template('.staging',     '.staging')
        template('.production',  '.production')
      end

      def ignore_secret
        create_file '.gitignore', '', skip: true
        append_to_file '.gitignore', '.aldagai.secret'
      end

      def say_next_instructions
        say ''
        say 'What is next:', :blue
        say ''
        say '* Run `$ heroku plugins:install heroku-cli-oauth`', :blue
        say '* Run `$ heroku authorizations:create -d "YouApp"` and copy the Token', :blue
        say '* Set ALDAGAI_HEROKU_TOKEN on heroku with the Token that was just generated', :blue
        say '* Set ALDAGAI_APP_NAME on heroku with the name of the application', :blue
        say '* Set ALDAGAI_PIPELINE_ENV on heroku with the name of the environment on the pipeline', :blue
        say '* Add `bundle exec aldagai set` to release part on the Procfile', :blue
        say ''
        say 'For more information about release phase go to ' +
          'https://devcenter.heroku.com/articles/release-phase', :green
        say ''
      end

    end
  end
end
