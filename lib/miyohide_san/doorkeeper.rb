require 'uri'
require 'ostruct'
require 'net/http'

module Doorkeeper
  extend ActiveSupport::Autoload
  autoload :Event, 'miyohide_san/doorkeeper/event'
  autoload :Group, 'miyohide_san/doorkeeper/group'
end
