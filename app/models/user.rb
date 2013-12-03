class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include User::AuthDefinitions
  include User::Roles

  has_many :identities

  has_many :flows, class_name: 'Flow', inverse_of: 'user', validate: false
  has_many :items, class_name: 'Item', inverse_of: 'user', validate: false

  field :image,      type: String
  field :first_name, type: String
  field :last_name,  type: String
  field :roles_mask, type: Integer

  def full_name
    if first_name.blank? || last_name.blank?
      "undefined"
    else
      "#{first_name} #{last_name}"
    end
  end

end
