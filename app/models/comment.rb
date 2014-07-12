class Comment
  include Mongoid::Document

  embeds_many :messages, class_name: 'Message', inverse_of: 'message', cascade_callbacks: true

  embedded_in :item, class_name: 'Item', inverse_of: 'messages'

  field :deleted_at, type: Time

  def message
    messages.versionned.first
  end

  def content
    message.try(:content)
  end
end
