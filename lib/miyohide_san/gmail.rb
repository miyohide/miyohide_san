module MiyohideSan
  class Gmail
    def self.login
      Net::SMTP.new(Settings.smtp.address, Settings.smtp.port).tap do |smtp|
        smtp.enable_starttls_auto(Net::SMTP.default_ssl_context)
        smtp.start(Settings.smtp.domain, Settings.smtp.user_name,Settings.smtp.password) do |mail|
          MiyohideSan.logger.info "Gmail login succeed. #{mail}"
        end
      end
    end
  end
end
