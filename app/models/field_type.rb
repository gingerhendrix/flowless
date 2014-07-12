class FieldType
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = AppConfig.fields.map{ |field| "FieldType/#{field}_type".camelcase }

  embedded_in :flow, class_name: 'Flow', inverse_of: 'field_types'

  field     :_type # need to be hard coded to be able to perform the validation to prevent instanciating an object from the base class
  validates :_type, inclusion: { in: TYPES }

  ## default field options present for all field types
  field     :index,     type: Integer, default: 0   # give the position of the field 0 => top
  validates :index,     numericality: { only_integer: true, greater_or_equal_than: 0 }, uniqueness: true

  field     :name,      type: String    # mandatory field name, that must be unique within a collection
  validates :name,      presence: true, uniqueness: true

  field     :optional,  type: Boolean, default: true   # determines wether or not a field is optional
  validates :optional,  presence: true  # with mongoid 4, a string "true" will automatically be converted to true

  field     :uniq,      type: Boolean, default: false  # determines wether or not having the field must contain uniq values #WARNING to ensure real unicity the db most likely will need to be 'block' during create/update of objects
  validates :uniq,      presence: true

  field     :help_info, type: String  # allow a help description to be inserted on the field form
  ##

  default_scope -> { order_by([[:index, :asc], [:_id, :asc]]) }
end