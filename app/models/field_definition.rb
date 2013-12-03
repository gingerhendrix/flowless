class FieldDefinition
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :workflow, class_name: 'Workflow', inverse_of: 'field_definitions'

  field :index, type: Integer

  validates :index, numericality: { only_integer: true, greater_than: 0 }
end