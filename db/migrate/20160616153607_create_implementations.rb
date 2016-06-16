class CreateImplementations < ActiveRecord::Migration
  def change
    create_table :implementations do |t|
      t.string :title, default: '', null: false
      t.string :summary, default: '', null: false
      t.text :description, default: '', null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.belongs_to :idea, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :implementations, [:user_id, :idea_id], :unique => true
  end
end
