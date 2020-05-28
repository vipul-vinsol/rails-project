class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: take this from ENV
  default from: 'from@example.com'
  layout 'mailer'

  #FIXME_AB: add app env to all mails subject except production. use mail interceptor. https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-and-observing-emails
end
