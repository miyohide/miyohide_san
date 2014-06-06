module MiyohideSan
  class Settings < ::Settingslogic
    source File.expand_path('../../../config/application.yml', __FILE__)
  end
end
