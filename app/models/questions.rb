class Questions < ActiveRecord::Base
  belongs_to :category
  validate :add_error_sample
  # バリデーションチェック
  def add_error_sample

    # カテゴリID
    if category_id.blank?
      errors[:base] << "カテゴリを選択してください"
    else
      @result = Category.find_by(id: category_id)
      unless @result then
        errors[:base] << "存在しないカテゴリが選択されています"
      end
    end

    # 問題
    if question.blank?
      errors[:base] << "問題を入力してください"
    else
      if question.length > 2000
        errors[:base] << "問題は2000文字以内で入力してください。"
      end
    end

    # 解答
    if answer.blank?
      errors[:base] << "解答を入力してください"
    else
      if answer.length > 2000
        errors[:base] << "解答は2000文字以内で入力してください。"
      end
    end
  end
end