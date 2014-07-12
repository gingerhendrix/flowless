module Followable
  extend ActiveSupport::Concern

  included do
    embeds_many :followers,   class_name: 'Follower', as: :followable, cascade_callbacks: true

    scope :followed_by,             ->(user) { where(:'followers.user_id'  => user.id) }
    scope :remindable_for_follower, ->(user) { where(:followers.elem_match => { remindable: true, user_id: user.id }) }
  end
end