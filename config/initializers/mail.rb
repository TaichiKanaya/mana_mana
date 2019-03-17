ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'jimonjitou.attakait@gmail.com',
  password: 'uituodcypvfklhfm',
  authentication: 'plain',
  enable_starttls_auto: true
}