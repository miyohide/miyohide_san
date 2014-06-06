require "dotenv"
Dotenv.load

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
        Yaffle::PreviousNotice.new(event).tap do |yaffle|
          yaffle.post
        end

        Postman::PreviousNotice.new(event).tap do |postman|
          postman.post
        end
      end
    end
  end

  module_function :recent
end

require File.expand_path('../../config/application', __FILE__)
