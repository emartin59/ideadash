class AddBalanceIndexOnIdeas < ActiveRecord::Migration
  def change
    add_index :ideas, :balance
  end
end
