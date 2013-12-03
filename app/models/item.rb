class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'item', store_as: "fvals"

  belongs_to :user,     class_name: 'User',     inverse_of: 'items', validate: false, index: true
  belongs_to :flow, class_name: 'Flow', inverse_of: 'items', validate: false, index: true

  validates :user, presence: true
  validates :flow, presence: true
end
