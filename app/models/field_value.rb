class FieldValue
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :item, class_name: 'Item', inverse_of: 'field_values'
end