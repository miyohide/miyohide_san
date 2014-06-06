#
# Mongoid Setting
#
Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__), (ENV["RACK_ENV"] || :development))
