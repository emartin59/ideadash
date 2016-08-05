class AddPaymentStatusesToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :ideadash_fee_processed, :boolean, default: false
    add_column :ideas, :author_fee_processed, :boolean, default: false
    add_column :ideas, :implementer_fee_processed, :boolean, default: false
    add_column :ideas, :refund_fee_processed, :boolean, default: false
  end
end
