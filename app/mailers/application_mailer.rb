class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: take this from ENV
  default from: 'from@example.com'
  layout 'mailer'
end
