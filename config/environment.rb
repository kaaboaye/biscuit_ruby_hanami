require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/biscuit'
require_relative '../apps/web/application'

Hanami.configure do
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/biscuit_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/biscuit_development'
    #    adapter :sql, 'mysql://localhost/biscuit_development'
    #
    # adapter :sql, ENV.fetch('DATABASE_URL')
    adapter :sql, 'postgresql://postgres:mysecretpassword@localhost:3255/postgres'

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/biscuit/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end
