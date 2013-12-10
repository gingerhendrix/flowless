require 'exceptions'

class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Followable
  include Eventable

  delegate :valid_statuses, to: :flow

  embeds_many :field_containers, class_name: 'FieldContainer', inverse_of: 'item'
  embeds_many :reminders,        class_name: 'Reminder',       inverse_of: 'item'
  embeds_many :comments,         class_name: 'Comment',        inverse_of: 'item'

  belongs_to :user, class_name: 'User', inverse_of: 'items', validate: false, index: true
  belongs_to :flow, class_name: 'Flow', inverse_of: 'items', validate: false, index: true

  validates :user, presence: true
  validates :flow, presence: true

  scope :ready_to_remind,           ->(now)  { where(:reminders.elem_match => { remind_at.lte => now , complete: false }) }
  scope :with_pending_reminder_for, ->(user) { where(:reminders.elem_match => { user_id: user.id, complete: false }) }

  field :status, type: String # todo perform validation on the status with the steps associated to the Flow

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
