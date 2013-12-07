class FieldValue
  include Mongoid::Document
  include Mongoid::Timestamps

  delegate :field_type_to_value, to: :field_container

  VALUES = AppConfig.fields.map{ |field| "FieldValue/#{field}_value".camelcase }

  embedded_in :field_container, class_name: 'FieldContainer', inverse_of: 'field_values'

  field :_type # needs to be hard coded to be able to perform the validation to prevent instanciating an object from the base class

  # Verifying that the FieldValue matches with the associated FieldType
  validates :_type, inclusion: { in: proc { |v| [ v.field_type_to_value ] } }

  scope :versionned, desc(:_id)
end