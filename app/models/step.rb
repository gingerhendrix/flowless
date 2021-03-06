class Step
  include Mongoid::Document
  include Mongoid::Timestamps

  validate :single_initial_step

  embedded_in :flow, class_name: 'Flow', inverse_of: 'steps'

  field :name,        type: String
  field :description, type: String

  field :initial,     type: Mongoid::Boolean, default: false
  field :terminal,    type: Mongoid::Boolean, default: false

  validates :name,  presence: true,  uniqueness: true

  scope :initials,    ->         { where(initial:  true) }
  scope :terminals,   ->         { where(terminal: true) }
  scope :with_status, ->(status) { where(name: status) }

  def single_initial_step
    errors.add :initial, I18n.t('errors.messages.taken') if flow.steps.initials.count > 1
  end

  def incoming_transitions
    flow.transitions.for_source(self)
  end

  def outgoing_transitions
    flow.transitions.for_destination(self)
  end

  def create_transition_to!(step, name, description = nil)
    flow.transitions.create!(source_step: self, destination_step: step, name: name, description: description)
  end

  def create_transition_from!(step, name, description = nil)
    flow.transitions.create!(source_step: step, destination_step: self, name: name, description: description)
  end

  def self.initial
    initials.first
  end
end
