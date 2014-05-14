require "dotenv"
Dotenv.load

require "action_mailer"
require "twitter"
require 'settingslogic'
require "miyohide_san/version"
require "miyohide_san/settings"
require "miyohide_san/doorkeeper"
require "miyohide_san/event"
require "miyohide_san/postman"
require "miyohide_san/yaffle"
require File.expand_path('../../config/application', __FILE__)


module MiyohideSan
  def notify
    if event = MiyohideSan::Event.find_by_one_week_later
      MiyohideSan::Postman.notify(event).deliver
      MiyohideSan::Yaffle.new(event).tweet
    end
  end

  module_function :notify
end
