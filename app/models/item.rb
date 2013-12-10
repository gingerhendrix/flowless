class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Followable
  include Eventable

  embeds_many :field_containers, class_name: 'FieldContainer', inverse_of: 'item'
  embeds_many :reminders,        class_name: 'Reminder',       inverse_of: 'item'
  embeds_many :comments,         class_name: 'Comment',        inverse_of: 'item'

  belongs_to :user, class_name: 'User', inverse_of: 'items', validate: false, index: true
  belongs_to :flow, class_name: 'Flow', inverse_of: 'items', validate: false, index: true

  validates :user, presence: true
  validates :flow, presence: true

  scope :ready_to_remind,           ->(now)  { where(:reminders.elem_match => { remind_at.lte => now , complete: false }) }
  scope :with_pending_reminder_for, ->(user) { where(:reminders.elem_match => { user_id: user.id, complete: false }) }
end
