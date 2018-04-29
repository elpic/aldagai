The aim of this gem is to help developers promoting heroku variables during the deployment process.

## Getting Started

* Add aldagai to you Gemfile

    ```
    source 'https://rubygems.org'

    # More gems

    gem 'aldagai', '0.1.1'
    ```

* Run the following command to install aldagai in your application

    $ bundle exec aldagai install

    This command will create the file `.aldagai.secret` with the secret used to encrypt your
    variables, and one file for each of the environments. This command will also add the
    `.aldagai.secret` to your `.gitignore` file.

* Add a new environment variable to each of your applications on the pipeline (by default we assume
  that you have 3 different environments development, staging, and production) with the name
  `ALDAGAI_SECRET` containing the same string that you have on the file `.aldagai.secret`

    $ heroku config:set ALDAGAI_SECRET="MySuperSecretPasswordUsingForEncryptTheMessage" -a yourapp

* Generate a new api token to intereact with heroku api

    $ heroku plugins:install heroku-cli-oauth
    $ heroku authorizations:create -d "YouApp"

* Add a new environment variables to intereact with heroku api. One of those variables should be
  named `ALDAGAI_HEROKU_TOKEN` with the value that was generated by the previous command, and the
  other one should be named `ALDAGAI_APP_NAME` with the name of the application in heroku, and
  then another one named `ALDAGAI_PIPELINE_ENV` indicating the envrionment of the PIPELINE for
  example `development`.

### Aldagai Generators

#### install

    $ bundle exec aldagai install

Install aldagai on your application

### Aldagai Commands

A list of all commands available through aldagai with their different options

#### add

*Normal Mode*

    $ bundle exec aldagai add VARIABLE_NAME --values 1 2 3

Values are the variables that are going to be promoted to the different environments (by default we
use 3 environments development, staging, and production)

*Interactive Mode*

    $ export EDITOR=vim
    $ bundle exec aldagai add VARIABLE_NAME -i

Variables values are obtained from what you type on your prefered editor, values are separated by a
blank line.

#### show

    $ bundle exec aldagai show VARIABLE_NAME

Show the VARIABLE_NAME if that variable is going to be deployed (either if is going to be removed or
modified, this is checked locally)

#### list

    $ bundle exec aldagai list

Show all variables that are going to be deployed (either if is going to be removed or modified, this
is checked locally)

#### delete

    $ bundle exec aldagai delete

Enqueue a variable to be deleted.

#### clear

Clear all file, creating a new start point for the next deploy.

Note: Variables that are already and are identicall to what heroku has are not being promoted.
