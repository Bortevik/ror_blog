class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  has_many :comments
  has_many :assignments
  has_many :roles, through: :assignments

  before_save { email.downcase! }
  before_create { generate_token :auth_token }

  validates :name, :email, :password_confirmation, presence: true
  validates :name, length: { minimum: 3, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :update

  default_scope order: 'name'

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:secret_token)
    self.secret_token_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def send_activation_link
    generate_token(:secret_token)
    save!(validate: false)
    UserMailer.activate_account(self).deliver
  end

  def role?(symbol)
    role = Role.find_by_name(symbol.to_s)
    self.roles.include?(role)
  end
end
