module PaymentsHelper
  def humanize_payment_kind kind
    case kind
      when 'funding' then 'Idea funding'
      when 'ideadash_fee' then 'IdeaDash fee'
      when 'author_reward' then 'Author reward'
      when 'implementation_funds' then 'Implementation funds'
    end
  end
end
