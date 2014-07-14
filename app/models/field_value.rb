class FieldValue
  include Mongoid::Document
  include Mongoid::Timestamps

  before_create :switch_current_flag_to_new_field_value

  delegate :field_type_to_value, :field_type, :field_type_id, :item, :flow, to: :field_container
  delegate :default_value, :unique?, :optional?, to: :field_type

  VALUES = AppConfig.fields.map{ |field| "FieldValue/#{field}_value".camelcase }

  embedded_in :field_container, class_name: 'FieldContainer', inverse_of: 'field_values'
  alias :container :field_container

  #TOTEST
  default_scope -> { order_by([[:current, :desc], [:_id, :desc]]) }

  attr_accessor :current_value

  field :_type # needs to be hard coded to be able to perform the validation to prevent instanciating an object from the base class

  field :current, type: Boolean, default: false # need to implement a logic to identify which value is the current one (considering the versioning abilities) this is necessary to perform queries

  # Verifying that the FieldValue matches with the associated FieldType
  validates :_type, inclusion: { in: ->(v) { [ v.field_type_to_value ] } }

  scope :versionned, ->        { desc(:_id) }
  scope :current,    ->        { where(current: true) }
  scope :with_value, ->(value) { where(value: value) }

  ## validation from the associated field_type for all the default options
  validates :value, presence: true,               on: :create, unless: ->{ optional? }
  validate  :value_special_uniqueness_validation, on: :create, if:     ->{ unique? }

  # Setting the default value in a after_build callback because at the time of instanciation
  # the object is not yet linked to the parent and therfore the default_value is not accessible
  after_build :set_default_value

  def set_default_value
    self.value = default_value if value.nil? && default_value
  end

  # value needs to be uniq only in the context of a given collection of item and only the 'current' value
  # WARNING: need to lock the object creation on a given collection to guarantee true unicity
  def value_special_uniqueness_validation
    if value && current_values_of_same_field_type_from_other_items_in_the_same_flow.include?(value)
      errors.add :value, I18n.t('errors.messages.taken')
    end
  end

  #TOTEST
  def switch_current_flag_to_new_field_value
    unless current
      field_container.current_values.each do |old_field_values|
        old_field_values.current = false
      end
      self.current = true
    end
  end

  def self.unpersisted
    field_values.reject{ |field_value| field_value.persisted? }
  end

  private

    # first we need to get the list of all the values from all the items in the flow that are using the same field type
    # need to make sure that the current field field container we are checking is not part of the list (hence the reject)
    # we then "simply" need to check that the value is not part of that list of value, then we will know it is uniq
    def current_values_of_same_field_type_from_other_items_in_the_same_flow
      flow.items.with_current_values_for_field_type(field_type_id).flat_map do |item|
        item.current_field_values_with_field_type_id(field_type_id).reject{ |field_value|
          field_value.field_container.id == field_container.id }.map(&:value)
      end
    end
end