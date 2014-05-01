require 'settingslogic'
require "action_mailer"
require "clockwork"
require "twitter"
require "miyohide_san/version"
require "miyohide_san/settings"
require "miyohide_san/doorkeeper"
require "miyohide_san/event"
require "miyohide_san/postman"
require "miyohide_san/yaffle"
require File.expand_path('../../config/application', __FILE__)

include Clockwork

every(1.day, 'notify.job', at: '05:00') do
  if event = MiyohideSan::Event.find_by_after_week
    MiyohideSan::Postman.notify(event).deliver
  end
end
