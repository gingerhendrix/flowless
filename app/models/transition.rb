class Transition
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :source_step, :destination_step

  embedded_in :flow, class_name: 'Flow', inverse_of: 'transitions'

  field :name,        type: String
  field :description, type: String

  field :source_step_id,      type: BSON::ObjectId
  field :destination_step_id, type: BSON::ObjectId

  validates :name,                presence: true
  validates :source_step_id,      presence: true
  validates :destination_step_id, presence: true

  scope :for_destination,  ->(step) { where(source_step_id:      step.id) }
  scope :for_source,       ->(step) { where(destination_step_id: step.id) }

  def source_step=(step)
    self.source_step_id = step.id
  end

  def destination_step=(step)
    self.destination_step_id = step.id
  end

  def source_step
    flow.steps.find(source_step_id)
  end

  def destination_step
    flow.steps.find(destination_step_id)
  end

  def source_status
    source_step.name
  end

  def destination_status
    destination_step.name
  end
end
