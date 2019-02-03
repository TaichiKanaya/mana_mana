class Informations < ActiveRecord::Base
  validate :add_error_sample
  # バリデーションチェック
  def add_error_sample

    # 必須チェック
    if (!((announce_date.blank? && title.blank? && contents.blank?) || (!announce_date.blank? && !title.blank? && !contents.blank?)))
      errors[:base] << "公開日、タイトル、内容は全て入力するか、全て未入力である必要があります。"
    end
  end
end