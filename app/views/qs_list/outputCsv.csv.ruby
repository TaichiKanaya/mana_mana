require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(取込作業専用列(新規 or 変更 or 削除) カテゴリ 問題ID（新規時は空欄にしてください） 問題 解答)
  csv << csv_column_names
  @questions.load.each do |data|
    csv_column_values = [
      '',
      data.name,
      data.id,
      data.question,
      data.answer
    ]
    csv << csv_column_values
  end
end