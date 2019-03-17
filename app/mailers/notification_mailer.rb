class NotificationMailer < ApplicationMailer
  def send_new_temp_user(user, password)
    @user = user
    @password = password
    mail(
      subject: "[JJ]仮パスワードのご案内",
      from: '"JimonJitou事務局" <jimonjitou@attakait.com>',
      reply_to: '"JimonJitou窓口" <taichi.kanaya@attakait.com>',
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end

  def send_reset_password(user)
    @user = user
    mail(
      subject: "[JJ]仮パスワードのご案内",
      from: '"JimonJitou事務局" <jimonjitou@attakait.com>',
      reply_to: '"JimonJitou窓口" <taichi.kanaya@attakait.com>',
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end
end
