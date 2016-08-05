class AddAmountRaisedToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :amount_raised, :decimal, null: false, default: 0, precision: 9, scale: 2
  end
end
