class FieldValue
  include Mongoid::Document
  include Mongoid::Timestamps

  delegate :field_type_to_value, :field_type, :field_type_id, :item, :flow, to: :field_container
  delegate :default_value, to: :field_type

  VALUES = AppConfig.fields.map{ |field| "FieldValue/#{field}_value".camelcase }

  embedded_in :field_container, class_name: 'FieldContainer', inverse_of: 'field_values'
  alias :container :field_container

  field :_type # needs to be hard coded to be able to perform the validation to prevent instanciating an object from the base class

  field :current, type: Boolean, default: false # need to implement a logic to identify which value is the current one (considering the versioning abilities) this is necessary to perform queries

  # Verifying that the FieldValue matches with the associated FieldType
  validates :_type, inclusion: { in: ->{ [ field_type_to_value ] } }
  #validates :_type, acceptance: { accept: proc { |v| binding.pry; v.field_type_to_value } }
  #validates :_type, acceptance: { accept: lambda { |v| v.field_type_to_value } }

  scope :versionned, -> { desc(:_id) }
  scope :current,    -> { where(current: true) }

  ## validation from the associated field_type for all the default options
  validates :value, presence: true,               unless: ->{ field_type.optional }
  validate  :value_special_uniqueness_validation, if:     ->{ field_type.uniq }

  # Setting the default value in a after_build callback because at the time of instanciation
  # the object is not yet linked to the parent and therfore the default_value is not accessible
  # TOTEST
  after_build :set_default_value
  # TOTEST
  def set_default_value
    self.value = default_value if value.nil? && default_value
  end

  # value needs to be uniq only in the context of a given collection of item and only the 'current' value
  # WARNING: need to lock the object creation on a given collection to guarantee true unicity
  # TOTEST
  def value_special_uniqueness_validation
    if value && current_values_of_same_field_type_from_other_items_in_the_same_flow.include?(value)
      errors.add :value, I18n.t('errors.messages.taken')
    end
  end

  private

    # first we need to get the list of all the values from all the items in the flow that are using the same field type
    # need to make sure that the current field we are checking is not part of the list (hence the reject)
    # we then "simply" need to check that the value is not part of that list of value, then we will know it is uniq
    # TOTEST
    def current_values_of_same_field_type_from_other_items_in_the_same_flow
      flow.items.with_current_values_for_field_type(field_type_id).map do |item|
        item.current_field_values(field_container: { scope: {
          name: 'with_field_type',
          params: field_type_id } }).reject{ |field_value| field_value._id == _id }.map(&:value)
      end.flatten
    end
end