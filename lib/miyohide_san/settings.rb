module MiyohideSan
  class Settings < ::Settingslogic
    namespace Rack.env
    source File.expand_path('../../../config/application.yml', __FILE__)
  end
end
