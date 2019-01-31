class Informations < ActiveRecord::Base
  validate :add_error_sample
  # バリデーションチェック
  def add_error_sample

    # 必須チェック
    if (title.blank? && ! contents.blank?) || (! title.blank? && contents.blank?)
      errors[:base] << "タイトルと内容は両方入力する必要があります"
    end
  end
end