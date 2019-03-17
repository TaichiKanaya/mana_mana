class NotificationMailer < ApplicationMailer
  default from: "jimonjitou@attakait.com"
  def send_new_temp_user(user, password)
    @user = user
    @password = password
    mail(
      subject: "[JJ]仮パスワードのご案内",
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end

  def send_reset_password(user)
    @user = user
    mail(
      subject: "[JJ]仮パスワードのご案内",
      to: @user.mail_address
    ) do |format|
      format.text
    end
  end
end
