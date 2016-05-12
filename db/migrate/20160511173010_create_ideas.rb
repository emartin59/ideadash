class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title, null: false, default: ''
      t.string :summary, null: false, default: ''
      t.text :description, null: false, default: ''
      t.belongs_to :user, null: false, index: true

      t.timestamps null: false
    end
  end
end
