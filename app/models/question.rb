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
    unless answer.blank?
      if answer.length > 2000
        errors[:base] << "解答は2000文字以内で入力してください。"
      end
    end

    return errors[:base].blank?
  end

  # 取込
  def self.import(file, session_id, errors)
    if file.original_filename.match(/.*.csv$/).blank?
      errors << "アップロードファイルの拡張子がcsvではありません。"
    return
    end
    if file.size > 99999
      errors << "100Kバイト以上のデータは一度に登録できません。ファイルを分割してください。"
    return
    end
    
    questionCount = Question.where("created_user_id = ?", session_id).size
    rowCount = 0
    regAbleCount = 1000 - questionCount
    CSV.foreach(file.path, headers:true) do |row|
      if row[0] == "新規"
        rowCount += 1
      end
      if (rowCount > regAbleCount)
        errors << "問題の最大登録可能件数を超過しています（一人あたり1000件まで）。他の問題を削除して再登録してください。"
        return
      end
      Question.new.check_import(session_id, row, $., errors)
    end
    unless errors.blank?
    return
    end
    newCount, updCount, delCount = 0, 0, 0
    CSV.foreach(file.path, headers: true) do |row|
      questionModel = Question.new
      nowDate = Time.new.strftime("%Y-%m-%d %H:%M:%S")
      if row[0] == "新規"
        question = Question.new
        categoryRecord = questionModel.get_category(row[1], session_id)
        question.category_id = categoryRecord.id
        question.question = row[3]
        question.answer = row[4]
        question.created_at = nowDate
        question.created_user_id = session_id
        question.save!
        newCount += 1
      elsif row[0] == "変更"
        categoryRecord = questionModel.get_category(row[1], session_id)
        question = questionModel.get_question(row[2], session_id)
        question.category_id = categoryRecord.id
        question.question = row[3]
        question.answer = row[4]
        question.updated_at = nowDate
        question.updated_user_id = session_id
        question.save!
        updCount += 1
      elsif row[0] == "削除"
        question = questionModel.get_question(row[2], session_id)
        question.destroy!
        delCount += 1
      end
    end
    return newCount, updCount, delCount
  end

  def self.updatable_attributes
    ["process","name","id","question","answer"]
  end

  def check_import session_id, row, index, errors
    if ! row[0].blank?
      # システム専用列
      if ! ['新規', '変更', '削除'].include?(row[0])
        errors << index.to_s + "行目付近 新規、変更、削除以外の値が指定されています。"
      end

      # カテゴリ
      if row[1].blank?
        errors << index.to_s + "行目付近 カテゴリが入力されていません。"
      else
        categories = get_category(row[1], session_id)
        if categories.blank?
          errors << index.to_s + "行目付近 存在しないカテゴリ名（" + row[1].to_s + "）です。"
        elsif categories.all_share_flg == 1
          errors << index.to_s + "行目付近 全てのユーザにシェア中のカテゴリ（" + row[1].to_s + "）のため、このカテゴリに対して操作できません。シェアを取り消してから操作してください。"
        end
      end

      # 問題ID
      if row[0] != '新規'
        if row[2].blank?
          errors << index.to_s + "行目付近 問題IDが入力されていません。CSV出力を行ってください。"
        else
          if get_question(row[2], session_id).blank?
            errors << index.to_s + "行目付近 存在しない問題ID（" + row[2].to_s + "）です。"
          else
            category = get_category_by_question(row[2], session_id)
            if category.all_share_flg == 1
              errors << index.to_s + "行目付近 問題IDに紐付くカテゴリが全てのユーザにシェア中のカテゴリ（" + category.category_name.to_s + "）のため、このカテゴリに対して操作できません。シェアを取り消してから操作してください。"
            end
          end
        end
      end

      # 問題
      if row[3].blank?
        errors << index.to_s + "行目付近 問題が入力されていません。"
      else
        if row[3].length > 2000
          errors << index.to_s + "行目付近 問題は2000文字以内で入力してください。"
        end
      end

      # 解答
      unless row[4].blank?
        if row[4].length > 2000
          errors << index.to_s + "行目付近 解答は2000文字以内で入力してください。"
        end
      end
    end
  end

  def get_category category_name, session_id
    return Category.select("id, all_share_flg").where("name = ? and created_user_id = ?", category_name, session_id).first
  end

  def get_question question_id, session_id
    return Question.where("id = ? and created_user_id = ?", question_id, session_id).first
  end
  
  def get_category_by_question question_id, session_id
    return Question.joins(:category).select("categories.id, categories.all_share_flg, categories.name category_name")
            .where("questions.id = ? and questions.created_user_id = ?", question_id, session_id).first
  end

end