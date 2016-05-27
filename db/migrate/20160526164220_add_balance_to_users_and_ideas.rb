class AddBalanceToUsersAndIdeas < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, default: 0, precision: 8, scale: 2
    add_column :ideas, :balance, :decimal, default: 0, precision: 8, scale: 2
  end
end
