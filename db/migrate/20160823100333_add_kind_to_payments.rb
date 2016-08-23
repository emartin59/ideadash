class AddKindToPayments < ActiveRecord::Migration
  def up
    add_column :payments, :kind, :string, default: 'funding', index: true

    Payment.successful.find_each do |payment|
      next if payment.sender_type == 'User' && payment.recipient_type == 'Idea'
      ideadash_fee = (payment.sender.amount_raised * 0.05).round(2)
      author_fee = (payment.sender.amount_raised * 0.1).round(2)
      case payment.amount
      when ideadash_fee then payment.update(kind: 'ideadash_fee')
      when author_fee then payment.update(kind: 'author_reward')
      else payment.update(kind: 'implementation_funds')
      end
    end
  end

  def down
    remove_column :payments, :kind
  end
end
