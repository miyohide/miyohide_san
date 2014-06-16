require "uri"
require "net/http"
require "mongoid"
require "settingslogic"
require 'active_support/all'
require "miyohide_san/version"

module MiyohideSan
  extend ActiveSupport::Autoload

  autoload :Settings
  autoload :Zapierable
  autoload :Event
  autoload :Group
  autoload :Postman
  autoload :Yaffle
  autoload :Doorkeeper

  def recent
    if doorkeeper = Doorkeeper.recent
      Event.new(doorkeeper).tap do |event|
        event.previous_notice
      end
    end
  end

  module_function :recent
end

#
# Mongoid Setting
#
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__), (ENV["RACK_ENV"] || :development))
