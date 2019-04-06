ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'manamana.attakait@gmail.com',
  password: 'hfdjidmeklumngds',
  authentication: 'plain',
  enable_starttls_auto: true
}