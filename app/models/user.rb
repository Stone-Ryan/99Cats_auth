class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence: true

  after_initialize :ensure_session_token

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password.is_password?(@password)
  end

  def self.find_by_credentials(user_name, password)
    user = find_by(user_name: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end
end
