module MiyohideSan
  class Settings < ::Settingslogic
    namespace ENV["RACK_ENV"]
    source File.expand_path('../../../config/application.yml', __FILE__)
  end
end
