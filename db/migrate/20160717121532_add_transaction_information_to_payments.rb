class AddTransactionInformationToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :transaction_fee, :decimal, null: false, default: 0, precision: 9, scale: 2
    add_column :payments, :paypal_payer_id, :string, index: true
  end
end
