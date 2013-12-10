class FieldContainer
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :item, class_name: 'Item', inverse_of: 'field_containers'

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'field_container'

  field :field_type_id, type: BSON::ObjectId

  validates :item,          presence:  true
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

  # A bit of metra programming to create 4 news methods to ease the creation of new values
  # using the proper FieldValue type (linked from the associated FieldType)
  #
  # Creating the 4 basic methods used to build or create an object.
  #
  # @note Added a little trick to "move" the bang to the end of the method when present
  #
  # @return new methods definition
  %w( new build create create! ).each do |method|
    bang = method.slice!('!')
    define_method("#{method}_value#{bang}") do |value, options={}|
      field_values.send "#{method}#{bang}", options.merge(value: value), field_type_to_value.constantize
    end
  end
end