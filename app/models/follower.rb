class Follower
  include Mongoid::Document

  embedded_in :followable, inverse_of: 'followers', polymorphic: true

  belongs_to  :user, class_name: 'User', inverse_of: nil, validate: false, index: true

  field :remindable, type: Mongoid::Boolean, default: true

  scope :to_remind, -> { where(remindable: true) }

  validates :user, presence: true
  # to prevent a bug where validation of uniquement fails if user is nil
  validates :user, uniqueness: true, if: lambda { |f| f.user }
end
