class Flow
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :field_definitions, class_name: 'FieldDefinition', inverse_of: 'item', store_as: "fdefs"

  has_many    :items, class_name: 'Item', inverse_of: 'flow',  validate: false

  belongs_to  :user,  class_name: 'User', inverse_of: 'flows', validate: false, index: true

  field :name, type: String

  validates :name, presence: true
  validates :user, presence: true
end
