class FieldType
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :flow, class_name: 'Flow', inverse_of: 'field_types'

  field :index, type: Integer

  validates :index, numericality: { only_integer: true, greater_than: 0 }
end