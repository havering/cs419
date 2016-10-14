class User < ApplicationRecord
  include ActiveModel::Validations

  validates :email, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, presence: true
  validates :answer1, presence: true
  validates :answer2, presence: true
  validates :answer3, presence: true

  # validate that the username is a valid email address format
  # example regex from: stackoverflow.com/questions/4770133/rails-regex-for-email-validation
  validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }

  has_secure_password

  has_many :awards

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

end
