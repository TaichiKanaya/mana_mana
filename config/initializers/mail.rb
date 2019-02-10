ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'localhost',
  domain: 'attakait.com',
  port: 1025,
  authentication: 'plain',
  enable_starttls_auto: true
}