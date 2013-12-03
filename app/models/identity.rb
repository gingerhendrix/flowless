class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, index: true

  field :uid, type: String
  field :provider, type: String
  field :token, type: String
  field :secret, type: String
  field :expires_at, type: DateTime

  field :email, type: String
  field :image, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  index({ uid: 1, provider: 1 }, { unique: true })

  def self.from_omniauth(auth)
    identity = where(auth.slice(:provider, :uid)).first_or_create do |ident|
      ident.update_attributes(get_identity_attributes_from_auth(auth))
    end
    identity.save!

    if !identity.persisted?
      redirect_to root_url, alert: "Something went wrong, please try again."
    end
    identity
  end

  def find_or_create_user(current_user)
    if current_user && self.user == current_user
      # User logged in and the identity is associated with the current user
      # do nothing
    elsif current_user && self.user != current_user
      # User logged in and the identity is not associated with the current user
      # so lets associate the identity and update missing info
      update_user_with_current!(current_user)
      self.save!
    elsif self.user.present?
      # User not logged in and we found the identity associated with user
      # so let's just log them in here
      # do nothing
    else
      # No user associated with the identity so we need to create a new one
      create_new_user!
      self.save!
    end
    self.user
  end

  def create_user
  end

  private

    def get_identity_attributes_from_auth(auth)
      {
        provider:   auth.provider,
        uid:        auth.uid,
        token:      auth.credentials.token,
        secret:     auth.credentials.secret,
        expires_at: auth.credentials.expires_at,
        email:      auth.info.email,
        image:      auth.info.image,
        nickname:   auth.info.nickname,
        first_name: auth.info.first_name,
        last_name:  auth.info.last_name
      }.reject{ |k,v| v.nil? }
    end

    def create_new_user!
      self.build_user(
        email:      self.email,
        image:      self.image,
        first_name: self.first_name,
        last_name:  self.last_name,
        roles:      [AppConfig.default_role]
      )
      self.user.save!(validate: false)
    end

    def update_user_with_current!(cur_user)
      self.user               = cur_user
      self.user.email       ||= self.email
      self.user.image       ||= self.image
      self.user.first_name  ||= self.first_name
      self.user.last_name   ||= self.last_name
      self.user.skip_reconfirmation!
      self.user.save!
    end
end
