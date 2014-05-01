#
# SMTP Setting
#
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = Settings.smtp.to_h.symbolize_keys!
ActionMailer::Base.prepend_view_path(File.expand_path('../../templates', __FILE__))
