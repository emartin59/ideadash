class ActsAsCommentableWithThreadingMigration < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.string :title
      t.text :body
      t.string :subject
      t.belongs_to :user, :null => false, index: true, foreign_key: true
      t.integer :parent_id, :lft, :rgt
      t.integer :flags_count, default: 0
      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end

  def self.down
    drop_table :comments
  end
end
