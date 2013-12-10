class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :comment, class_name: 'Comment', inverse_of: 'messages'

  scope :versionned, -> { desc(:_id) }

  field :content, type: String

  validates :content, presence: true
end
