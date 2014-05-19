require "dotenv"
Dotenv.load

require 'forwardable'
require "twitter"
require 'settingslogic'
require "action_mailer"
require 'active_support/dependencies/autoload'

require "doorkeeper"
require "miyohide_san/version"
require "miyohide_san/settings"

require File.expand_path('../../config/application', __FILE__)

module MiyohideSan
  extend ActiveSupport::Autoload
  autoload :Event
  autoload :Postman
  autoload :Yaffle
  autoload :LastEvent
  autoload :Gmail

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def testament
    if event = Event.find_by_one_week_later
      #Postman.testament(event).deliver
      Yaffle::Testament.new(event).tweet
    end

    logger.info "testament: #{event}"
  end

  def newborn
    event = Event.last
    if event.new_record?
      #Postman.newborn(event).deliver
      Yaffle::Newborn.new(event).tweet
    end

    logger.info "newborn: #{event}"
  end

  def login
    Gmail.login
  end

  def test
    Postman.test.deliver
  end

  module_function :testament, :newborn, :login, :test
end
