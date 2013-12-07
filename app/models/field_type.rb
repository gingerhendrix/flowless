class FieldType
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = AppConfig.fields.map{ |field| "FieldType/#{field}_type".camelcase }

  embedded_in :flow, class_name: 'Flow', inverse_of: 'field_types'

  field :_type # need to be hard coded to be able to perform the validation to prevent instanciating an object from the base class
  field :index, type: Integer

  validates :index, numericality: { only_integer: true, greater_than: 0 }, uniqueness: true
  validates :_type, inclusion: { in: TYPES }
end