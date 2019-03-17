ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'k.t.sz1989@gmail.com',
  password: 'hkwvftwfyvtbvubx',
  authentication: 'plain',
  enable_starttls_auto: true
}