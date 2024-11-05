class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :plan_id, presence: true, if: -> { stripe_subscription_id.present? }

  # please check this below line we need to remove
  def jwt_subject
    id
  end

  # Find or create a user based on Google OAuth data
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # user.name = auth.info.name
    end
  end

  # Method to generate JWT token
  def generate_jwt
    Warden::JWTAuth::UserEncoder.new.call(self, :user, nil).first
  end
end
