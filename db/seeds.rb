require 'csv'
csv_text = File.read(Rails.root.join('lib', 'seeds', 'ideas.csv'))

csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
  Idea.create(title: row['title'], summary: row['summary'], user: User.order('random()').first)
end
