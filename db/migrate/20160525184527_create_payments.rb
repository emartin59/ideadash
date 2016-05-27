class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :sender, index: true, polymorphic: true
      t.belongs_to :recipient, index: true, polymorphic: true
      t.decimal :amount, null: false, default: 0, precision: 9, scale: 2
      t.string :paypal_id, index: true
      t.string :paypal_status

      t.timestamps null: false
    end
  end
end
