class NotificationMailer < ApplicationMailer
  def send_new_temp_user(user, password)
    @user = user
    @password = password
    mail(
      subject: "[MM]仮パスワードのご案内",
      from: '"ManaMana事務局" <manamana@attakait.com>',
      reply_to: '"ManaMana窓口" <taichi.kanaya@attakait.com>',
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end

  def send_reset_password(user)
    @user = user
    mail(
      subject: "[MM]仮パスワードのご案内",
      from: '"ManaMana事務局" <manamana@attakait.com>',
      reply_to: '"ManaMana窓口" <taichi.kanaya@attakait.com>',
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end
end
