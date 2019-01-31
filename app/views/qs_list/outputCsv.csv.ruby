require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(カテゴリ 問題 解答 登録日時)
  csv << csv_column_names
  @questions.load.each do |data|
    puts 'bbbbb'
    puts data.inspect
    puts 'bbbbb'
    csv_column_values = [
      data.category_name,
      data.question,
      data.answer,
      data.reg_date
    ]
    csv << csv_column_values
  end
end