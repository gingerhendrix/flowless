require 'exceptions'

class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Followable
  include Eventable

  delegate :valid_statuses, to: :flow

  embeds_many :field_containers, class_name: 'FieldContainer', inverse_of: 'item'
  alias :containers :field_containers

  embeds_many :reminders,        class_name: 'Reminder',       inverse_of: 'item'
  embeds_many :comments,         class_name: 'Comment',        inverse_of: 'item'

  belongs_to :user, class_name: 'User', inverse_of: 'items', validate: false, index: true
  belongs_to :flow, class_name: 'Flow', inverse_of: 'items', validate: false, index: true

  validates :user, presence: true
  validates :flow, presence: true

  scope :ready_to_remind,                    ->(now)           { where(:reminders.elem_match => { remind_at.lte => now , complete: false }) }
  scope :with_pending_reminder_for,          ->(user)          { where(:reminders.elem_match => { user_id: user.id, complete: false }) }
  scope :with_current_values_for_field_type, ->(field_type_id) { where(:field_containers.elem_match => { field_type_id: field_type_id, :'field_values.current' => true }) }

  field :status, type: String # TODO perform validation on the status with the steps associated to the Flow

  # verify if the status is among the available steps name
  validates :status, inclusion: { in: proc { |i| i.valid_statuses } }

  def step
    flow.steps.with_status(status).first
  end

  def incoming_transitions
    flow.transitions.for_source(self)
  end

  def outgoing_transitions
    flow.transitions.for_destination(self)
  end

  # because we want to be easily able to list all the current field_values of an item with thinking about versionning
  # options can either be passing a selector or a scope to search directly within the field_values or influence the scopes
  # and criteria on the field_containers:
  # i.e: options = { field_container: { scope: { name: 'some_scope', params: ... } }, field_value: { selector: { some: :selector} } }
  # TOTEST
  def current_field_values(options = {})
    options.reverse_merge!(field_container: {}, field_value: {})

    scope      = options[:field_container][:scope]
    selector   = options[:field_container][:selector]

    containers = field_containers.with_current_values

    if scope
      if (params = scope[:params] ? [*scope[:params]] : nil)
        containers.send(scope[:name], *params)
      else
        containers.send(scope[:name])
      end
    elsif selector
      containers.where(selector)
    else
      containers
    end.map do |field_container|
      field_container.current_field_value(options[:field_value])
    end.compact # to avoid return an array with nil items
  end
  alias_method :values, :current_field_values

  def apply_transition!(transition)
    if can_apply_transition?(transition)
      set_status!(transition.destination_status)
    else
      raise Exceptions::InapplicableTransition, "Tried to apply Transition '#{transition.id}' from Flow '#{transition.flow.id}' on Item '#{id}'"
    end
  end

  private

    def can_apply_transition?(transition)
      status == transition.source_status && flow == transition.flow
    end

    def set_status!(status)
      self.status = status
      save!
    end
end
