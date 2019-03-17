ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.office365.com',
  domain: 'attakait.com',
  port: 587,
  user_name: 'taichi.kanaya@attakait.com',
  password: 'bshBSH100cp_1989',
  authentication: 'plain',
  enable_starttls_auto: true
}