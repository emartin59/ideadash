class CreateIdeasRatingIndex < ActiveRecord::Migration
  def up
    execute <<-SQL
  CREATE INDEX index_ideas_on_rating ON ideas ((positive_votes_count::float / (positive_votes_count + negative_votes_count + 1)));
    SQL
  end
  def down
    execute <<-SQL
  DROP INDEX index_ideas_on_rating;
    SQL
  end
end
