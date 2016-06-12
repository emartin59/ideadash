class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :flaggable, index: true, polymorphic: true
      t.string :kind, null: false, default: 'spam'
      t.string :description, default: '', null: false

      t.timestamps null: false
    end

    add_index :flags, [:user_id, :flaggable_id, :flaggable_type], unique: true

    add_column :ideas, :flags_count, :integer, default: 0, null: false
    add_column :ideas, :approved, :boolean, default: false, null: false
  end
end
