class Flag < ActiveRecord::Base
  KINDS = {
      spam: 'Spam',
      illegal: 'It is illegal',
      tos_violation: 'It violates ToS',
      duplicate: 'It is duplicate',
      dislike: 'I do not like it'
  }

  belongs_to :user
  belongs_to :flaggable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:flaggable_id, :flaggable_type] }
end
