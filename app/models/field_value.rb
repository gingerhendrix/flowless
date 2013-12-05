class FieldValue
  include Mongoid::Document
  include Mongoid::Timestamps

  VALUES = Fields::AVAILABLE.map{ |field| "FieldValue/#{field}_value".camelcase }

  embedded_in :field_container, class_name: 'FieldContainer', inverse_of: 'field_values'

  field :_type # need to be hard coded to be able to perform the validation to prevent instanciating an object from the base class

  validates :_type, inclusion: { in: VALUES }

  scope :versionned, desc(:_id)
end