# We store the field_values inside a field_container rather than directly in the item because we want to
# keep all the possible version of the field_values, and therefore we need to attach all field_value history
class FieldContainer
  include Mongoid::Document
  include Mongoid::Timestamps

  delegate :flow, to: :item

  embedded_in :item, class_name: 'Item', inverse_of: 'field_containers'

  embeds_many :field_values, class_name: 'FieldValue', inverse_of: 'field_container'
  alias :values :field_values

  field :field_type_id, type: BSON::ObjectId

  scope :with_current_values, ->()              { where(:'field_values.current' => true) }
  scope :with_field_type,     ->(field_type_id) { where(field_type_id: field_type_id) }

  validates :item,          presence:  true
  validates :field_type_id, presence:  true

  def current_values
    field_values.current
  end

  # because we want to be easily able to list all the current field_values of an item with thinking about versionning
  # options can either be passing a selector or a scope to search directly within the field_values
  # options = { scope: { name: :my_scope, params: [ :stuff1, :stuff2 ] } } or { scope: { name: :my_scope, params: :one_stuff } }
  # or passing selector: options = { selector: { field: :value } }
  # TOTEST
  def current_field_value(options = {})
    scope    = options[:scope]
    selector = options[:selector]
    # there is supposed to be only one current value, so using .first is supposed to be safe here
    if options[:scope]
      if (params = scope[:params] ? [*scope[:params]] : nil)
        current_values.send(scope[:name], *params)
      else
        current_values.send(scope[:name])
      end
    elsif selector
      current_values.where(selector)
    else
      current_values
    end.first
  end
  alias_method :field_value, :current_field_value

  # TOTEST
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
  %w( new build create create! ).each do |method|
    bang = method.slice!('!')
    define_method("#{method}_value#{bang}") do |value=nil, options={}|
      options.merge!(value: value) if value
      field_values.send "#{method}#{bang}", options, field_type_to_value.constantize
    end
  end
end