class FieldContainer
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :item, class_name: 'Item', inverse_of: 'field_containers'

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'field_container'

  field :field_type_id, type: BSON::ObjectId

  validates :field_type_id, presence:  true

  def field_value
    field_values.versionned.first
  end

  def value
    field_value.try(:value)
  end

  def field_type
    if @field_type && @field_type.id == field_type_id
      @field_type
    else
      @field_type = item.flow.field_types.find(field_type_id)
    end
  end

  def field_type_to_value
    field_type._type.gsub(/Type(?=::|$)/, "Value")
  end

  def create_value(value, options={})
    field_values.create *field_values_parameters(value, options)
  end

  def create_value!(value, options={})
    field_values.create! *field_values_parameters(value, options)
  end

  private

    def field_values_parameters(value, options={})
      [ options.merge(value: value), field_type_to_value.constantize ]
    end
end