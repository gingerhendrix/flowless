class FieldContainer
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :item, class_name: 'Item', inverse_of: 'field_containers'

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'field_container'

  def field_value
    field_values.versionned.first
  end

  def value
    field_value.try(:value)
  end
end