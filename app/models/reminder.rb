class Reminder
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :calculate_next_occurence, :if => lambda { |e| e.recurring? }

  embedded_in :item, class_name: 'Item', inverse_of: 'reminders'

  belongs_to  :user, class_name: 'User', inverse_of: nil, validate: false, index: true

  field :remind_at,  type: Time
  field :recurrence, type: Hash, default: {}
  field :message,    type: String
  field :complete,   type: Mongoid::Boolean, default: false
  field :private,    type: Mongoid::Boolean, default: true

  validates :remind_at, presence: true
  validates :message,   presence: true
  validates :complete,  presence: true
  validates :user,      presence: true

  scope :ready, ->(now) { where(:remind_at.lte => now, complete: false) }

  def calculate_next_occurence
    self.remind_at = Recurrence.new(ActiveSupport::HashWithIndifferentAccess.new(recurrence)).next + time_of_day
  rescue Exception
    self.recurrence = {}
  end

  def time_of_day
    remind_at ? remind_at.utc.hour.hours + remind_at.utc.min.minutes : 0
  end

  def remind_users
    # TODO: actually remind something
  end

  def remind!
    remind_users
    if recurring?
      calculate_next_occurence
    else
      self.complete = true
    end
    save!
  end

  def recurring?
    !recurrence.empty?
  end
end
