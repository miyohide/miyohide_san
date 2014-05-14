require 'uri'
require 'ostruct'
require 'net/http'
require 'active_support/dependencies/autoload'

module Doorkeeper
  extend ActiveSupport::Autoload
  autoload :Event
  autoload :Group
end
