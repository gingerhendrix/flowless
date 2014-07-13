# We store the field_values inside a field_container rather than directly in the item because we want to
# keep all the possible version of the field_values, and therefore we need to attach all field_value history
class FieldContainer
  include Mongoid::Document
  include Mongoid::Timestamps

  delegate :flow, to: :item

  embedded_in :item, class_name: 'Item', inverse_of: 'field_containers'

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'field_container', cascade_callbacks: true#, after_add: :set_field_values_current_flag
  #TO TEST #TEMP #TOIMPROVE the rejection bit !?!
  accepts_nested_attributes_for :field_values, reject_if: ->(attributes) { attributes['value'].blank? ? false : attributes['value'] == attributes['current_value'] }
  alias :values :field_values

  field :field_type_id, type: BSON::ObjectId

  scope :with_current_values, ->()              { where(:'field_values.current' => true) }
  scope :with_field_type,     ->(field_type_id) { where(field_type_id: field_type_id) }

  validates :item,          presence:  true
  validates :field_type_id, presence:  true

  def current_values
    field_values.current
  end

  #TEMP #TOTEST
  # get all field_values that did not get persisted yet, but if none are available
  # because for instance the value got rejected because if was the same as the current value
  # then we need to rebuild it for the form
  def non_persisted_field_values
    values = field_values.reject{ |field_value| field_value.persisted? }
    if values.empty?
      # if there are no `new` value, let's build one
      # and run validation on it, to make sure that if it's invalid
      # the forms knows about it
      value = build_value current_value, { current_value: current_value }
      value.valid?
      [ value ]
    else
      values
    end
  end

  # because we want to be easily able to list all the current field_values of an item with thinking about versionning
  # options can either be passing a selector or a scope to search directly within the field_values
  # options = { scope: { name: :my_scope, params: [ :stuff1, :stuff2 ] } } or { scope: { name: :my_scope, params: :one_stuff } }
  # or passing selector: options = { selector: { field: :value } }
  def current_field_value(options = {})
    scope    = options[:scope]
    selector = options[:selector]
    if scope
      current_values.send(scope[:name], *scope.fetch(:params, nil))
    elsif selector
      current_values.where(selector)
    else
      current_values
    end.first # there is supposed to be only one current value, so using .first is supposed to be safe here, #TODO add validation to make sure there is only one :current value in a given object
  end
  alias_method :field_value, :current_field_value

  def current_value
    current_field_value.try(:value)
  end
  alias_method :value, :current_value

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
  #
  # TODO: add a logic to set the new value with the "current" flag and unset the previous one
  %w( new build create create! ).each do |method|
    bang = method.slice!('!')
    define_method("#{method}_value#{bang}") do |value=nil, options={}|
      options.merge!(value: value) if value
      field_values.send "#{method}#{bang}", options, field_type_to_value.constantize
    end
  end

  # TOTEST # Set the newly added field_values's current flag to true and remove it from the previous one
  # def set_field_values_current_flag(new_field_value)
  #   #binding.pry
  # end
end