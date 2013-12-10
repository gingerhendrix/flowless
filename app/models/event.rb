class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :entity

  before_validation :set_entity, :if => lambda { |e| e.entity }

  ACTIONS = %w( creation update transition reminder )

  belongs_to :user, class_name: 'User', inverse_of: 'items', validate: false, index: true

  field :entity_class, type: String
  field :action,       type: String

  field :entity_id,    type: BSON::ObjectId
  field :read_at,      type: Time

  field :data,         type: Hash

  validates :entity_class, presence: true
  validates :entity_id,    presence: true
  validates :user,         presence: true
  validates :data,         presence: true
  validates :action,       inclusion: { in: ACTIONS }

  index({ entity_class: 1 })
  index({ entity_id: 1 })
  index({ action: 1 })
  index({ read_at: 1 })

  scope :unread,              ->                 { where(read_at: nil) }
  scope :with_entity_classes, ->(entity_classes) { where(:entity_class.in => entity_classes) }
  scope :with_actions,        ->(actions)        { where(:action.in => actions) }
  scope :sorted,              ->                 { asc(:_id) }

  def get_entity
    entity_class.constantize.find(entity_id)
  end

  def set_entity
    self.entity_id    = entity.id
    self.entity_class = entity.class.to_s
  end

  def mark_as_read!
    self.read_at = Time.now.utc
    save!
  end

  def read?
    !!read_at
  end

  # Allows the creationg of the same event (entity, action and data) for a whole bunch
  # of users at the same time
  #
  # Not using create with a bang in order to avoid not creating the other events if an error is encountered
  #
  # @note This needs to be call in as a background task
  #
  # @return [ list_of_failed_events ] will be empty if everything was successfull
  def create_multiple_for(user_ids, entity, action, data)
    failed_events = []
    user_ids.each do |user_id|
      e = Event.build(user_id: user_id, entity: self, action: action, data: data)
      failed_events << e unless e.save
    end
    failed_events
  end
end
