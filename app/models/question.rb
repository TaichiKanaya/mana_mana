class Question < ActiveRecord::Base
  belongs_to :category

  validate :check_param
  # バリデーションチェック
  def check_param

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
    if answer.length > 2000
      errors[:base] << "解答は2000文字以内で入力してください。"
    end
    
    return errors[:base].blank?
  end

  # 取込
  def self.import(file, session_id)
    newCount, updCount, delCount = 0, 0, 0
    CSV.foreach(file.path, headers: true) do |row|
      nowDate = Time.new.strftime("%Y-%m-%d %H:%M:%S")
      if row[0] == "新規"
        question = Question.new
        categoryRecord = Category.select("id").where("name = ? and created_user_id = ?", row[1], session_id).first
        question.category_id = categoryRecord.id
        question.question = row[3]
        question.answer = row[4]
        question.created_at = nowDate
        question.created_user_id = session_id
        question.save!
        newCount += 1
      elsif row[0] == "変更"
        categoryRecord = Category.select("id").where("name = ? and created_user_id = ?", row[1], session_id).first
        question = Question.where("id = ? and created_user_id = ?", row[2], session_id).first
        question.category_id = categoryRecord.id
        question.question = row[3]
        question.answer = row[4]
        question.updated_at = nowDate
        question.updated_user_id = session_id
        question.save!
        updCount += 1
      elsif row[0] == "削除"
        question = Question.where("id = ? and created_user_id = ?", row[2], session_id).first
        question.destroy!
        delCount += 1
      end
    end
    return newCount, updCount, delCount
  end

  def self.updatable_attributes
    ["process","name","id","question","answer"]
  end

end