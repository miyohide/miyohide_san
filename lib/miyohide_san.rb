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

  def notify
    if event = Event.find_by_one_week_later
      Postman.notify(event).deliver
      Yaffle.new(event).tweet
    end
  end

  module_function :notify
end
